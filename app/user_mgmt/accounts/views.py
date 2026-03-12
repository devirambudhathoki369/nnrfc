from django.conf import settings
from django.contrib import messages
from django.contrib.auth import authenticate, get_user_model, login
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.mixins import LoginRequiredMixin, UserPassesTestMixin
from django.contrib.auth.views import LoginView, LogoutView, PasswordChangeView
from django.contrib.messages.views import SuccessMessageMixin
from django.core.exceptions import PermissionDenied
from django.core.paginator import Paginator
from django.db import models
from django.http.response import Http404, HttpResponse, JsonResponse
from django.shortcuts import redirect, render, resolve_url
from django.template.loader import render_to_string
from django.templatetags.static import static
from django.urls import reverse, reverse_lazy
from django.views import View
from django.views.generic import CreateView, ListView
from django.views.generic.edit import FormView, UpdateView
from user_mgmt.accounts.forms import (PasswordResetRequestForm, SetNewStaffPasswordForm, UserLoginForm,
                                      UserSetupForm)
from user_mgmt.models import Department, Level, LevelType, Role, UserPost
from user_mgmt.tasks import send_email, send_html_email
from user_mgmt.utils import get_local_levels_by_province, get_users_by_level
import json
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.sites.models import Site

account_activation_token = PasswordResetTokenGenerator()

User = get_user_model()


class StaffUserCreateView(SuccessMessageMixin, CreateView):
    model = User
    template_name = "accounts/user_setup.html"
    success_url = reverse_lazy("user_mgmt:user_list")
    success_message = "Created Successfully. A mail has been sent to user email."
    form_class = UserSetupForm

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["roles"] = Role.objects.all()
        context["users"] = get_users_by_level(self.request.user)
        context["departments"] = Department.objects.all()
        return context

    def form_valid(self, form):
        pwd = User.objects.make_random_password(length=8)
        email = form.instance.email
        url = Site.objects.get_current().domain
        form.instance.set_password(pwd)
        form.instance.is_first_login = True
        form.instance.is_active = True

        # SAVE USER FIRST (before attempting email)
        form.save()

        html_template = "email/user_invitation.html"
        context = {
            "email": email,
            "pwd": pwd,
            "domain": url,
            "full_name": form.instance.full_name,
            "login_url": self.request.build_absolute_uri(reverse("user_mgmt:login")),
            "logo_img": self.request.build_absolute_uri(static("email/logo.png")),
            "protocol": "https",
        }
        msg = render_to_string(html_template, context)
        try:
            send_email.delay(msg, [form.instance.personal_email])
        except:
            # User is already saved, just warn about email
            return JsonResponse({
                "success": True,
                "msg": "User created successfully but invitation email could not be sent. Password: " + pwd
            })

        return JsonResponse({"success": True, "msg": self.success_message})

    def form_invalid(self, form):
        return JsonResponse(form.errors)


class UserUpdateView(UpdateView):
    model = User
    template_name = "accounts/user_edit.html"
    success_url = reverse_lazy("user_mgmt:user_list")
    form_class = UserSetupForm
    context_object_name = "user"
    success_message = "User updated successfully."

    def get_context_data(self, **kwargs):
        user = self.request.user
        context = super().get_context_data(**kwargs)
        context["provinces"] = Level.objects.filter(type__type="P")
        context["roles"] = Role.objects.all()
        context["departments"] = Department.objects.all()
        context["posts"] = UserPost.objects.all()
        user_province = user.level
        context["l_levels"] = get_local_levels_by_province(user_province, user)
        return context

    def form_valid(self, form):
        user = form.save()
        if user.roles.all().exists():
            user.is_staff = True
        else:
            user.is_staff = False
        user.save()
        messages.success(self.request, "User Updated Successfully.")
        return JsonResponse({"success": True, "msg": self.success_message})

    def form_invalid(self, form):
        return JsonResponse(form.errors)


class UserListView(ListView):
    model = User
    template_name = "accounts/user_setup.html"
    context_object_name = "users"

    def get_context_data(self, **kwargs):
        user = self.request.user
        context = super().get_context_data(**kwargs)
        context["level_types"] = LevelType.objects.all()
        context["provinces"] = Level.objects.filter(type__type="P")
        context["roles"] = Role.objects.all()
        context["departments"] = Department.objects.all()
        context["posts"] = UserPost.objects.all()
        u_province = user.level
        context["l_levels"] = get_local_levels_by_province(u_province, user)
        qs = get_users_by_level(user)
        province_users = qs.filter(level__type__type="P")
        local_users = qs.filter(level__type__type="L")
        context["p_users"] = province_users
        context["l_users"] = local_users
        return context


class UserLoginView(LoginView):
    template_name = "accounts/login.html"
    redirect_authenticated_user = True

    def get_success_url(self):
        if self.request.user.is_first_login:
            return reverse("set_password")
        if self.request.user.is_staff:
            return reverse("dashboard:dashboard")
        return reverse("core:survey_list")


class SetNewPasswordView(UserPassesTestMixin, SuccessMessageMixin, FormView):
    """set new password of staff user after first login successful."""

    form_class = SetNewStaffPasswordForm
    template_name = "accounts/set_new_password.html"
    success_message = "Password changed successfully."

    def test_func(self):
        if self.request.user.is_authenticated:
            return self.request.user.is_first_login
        raise Http404

    def form_valid(self, form):
        password = form.cleaned_data.get("new_password2")
        user = self.request.user
        if user.roles.all().exists():
            user.is_staff = True
        user.is_first_login = False
        user.set_password(password)
        user.save()
        auth = authenticate(self.request, username=user.email, password=password)
        if auth:
            login(self.request, auth)
        return super().form_valid(form)

    def get_success_url(self):
        if self.request.user.is_staff:
            return reverse("dashboard:dashboard")
        return reverse("core:survey_list")


def get_levels(request, type_id):
    type = LevelType.objects.filter(id=type_id).first()
    qs = list(Level.objects.filter(type=type).values("id", "name"))
    if request.user.is_superuser:
        levels = qs
    elif type and type.type == "P":
        user_roles = request.user.roles.all().values_list("level")
        levels = list(
            Level.objects.filter(type=type, id__in=user_roles).values("id", "name")
        )
    else:
        levels = qs
    return JsonResponse({"levels": levels})


def get_level_departments(request, level_id):
    departs = list(Department.objects.filter(level_id=level_id).values("id", "name"))
    return JsonResponse({"departs": departs})


def delete_user(request, user_id):
    if request.method == "POST":
        User.objects.filter(id=user_id).delete()
        messages.success(request, "Deleted Successfully.")
        return redirect("user_mgmt:user_list")


def delete_department(request, department_id):
    if request.method == "POST":
        Department.objects.filter(id=department_id).delete()
        messages.success(request, "Deleted Successfully.")
        return redirect("user_mgmt:depart_list")


class DepartmentCreateView(SuccessMessageMixin, CreateView):
    model = Department
    template_name = "accounts/depart_list.html"
    fields = ["name", "address", "email"]
    success_url = reverse_lazy("user_mgmt:depart_list")
    success_message = "Department Created Successfully."

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["departs"] = Department.objects.all()
        return context


class DepartmentUpdateView(SuccessMessageMixin, UpdateView):
    model = Department
    template_name = "accounts/depart_update.html"
    success_url = reverse_lazy("user_mgmt:depart_list")
    fields = ["name", "address", "email"]
    success_message = "Department Updated Successfully."
    context_object_name = "depart"


class DepartmentListView(ListView):
    model = Department
    template_name = "accounts/depart_list.html"
    context_object_name = "departs"


def registration_view(request):
    if request.user.is_authenticated:
        return redirect("core/dashboard/home")
    else:
        form = UserLoginForm()
        if request.method == "POST":
            form = UserLoginForm(request.POST)
            if form.is_valid():
                email = form.cleaned_data.get("email")
                password = form.cleaned_data.get("password")
                user = User.objects.create(email=email, password=password)
                login(request, user)
                # form.save()
                messages.success(request, "Account was created for " + user)
                return redirect("login")
            else:
                return render(request, "accounts/registration.html", {"form": form})
        else:
            return render(request, "accounts/registration.html", {"form": form})


def authenticate_user(email, password):
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return None
    else:
        if user.check_password(password):
            return user

    return None


class LoginUserView(LoginView):
    template_name = "accounts/login.html"

    def get(self, request):
        return render(request, self.template_name)

    def post(self, request):
        email = request.POST["email"]
        password = request.POST["password"]

        email_error = None
        password_error = None

        if not email:
            email_error = "यो क्षेत्र आवश्यक छ।"

        if not password:
            password_error = "यो क्षेत्र आवश्यक छ।"

        user = authenticate_user(email, password)
        context = {"email_error": email_error, "password_error": password_error}

        if user is not None:
            if user.is_staff:
                login(request, user)
                messages.success(request, "Login successfully done")
                return redirect("dashboard:home")
            elif not user.is_staff:
                login(request, user)
                return redirect("core:survey_list")
            else:
                context["error_message"] = "user is not staff"
        else:
            context["error_message"] = "Please enter correct login credentials"

        return render(request, self.template_name, context)


class UserLogoutView(LogoutView):
    next_page = reverse_lazy("user_mgmt:login")


# class UserPasswordChangeView(
#     LoginRequiredMixin, SuccessMessageMixin, PasswordChangeView
# ):
#     template_name = "accounts/change_password.html"
#     form_class = PasswordChangingForm
#     success_url = reverse_lazy("login")
#     success_message = "Password was changed successfully."



def change_password(request):
    uname = request.user.username
    response_data = {}
    if request.method == 'POST':
        currentPassword = request.POST['currentPassword']
        newPassword = request.POST['newPassword']
        confirmNewPassword = request.POST['confirmNewPassword']
        # user = authenticate(username=uname, password=currentPassword)
        user = User.objects.get(id=request.user.id)
        check = user.check_password(currentPassword)
        if check == True:
            if newPassword == confirmNewPassword and confirmNewPassword != '':
                u = User.objects.get(username=uname)
                u.set_password(confirmNewPassword)
                u.save()
                response_data["result"] = "Success!"
                response_data["message"] = "Password Changed Successfully."
            else:
                response_data["result"] = "Invalid Passwords!"
                response_data["message"] = "Password did not matches."
        else:
            response_data["result"] = "Enter Correct Passwords!"
            response_data["message"] = "Enter Correct Passwords!"
    return HttpResponse(json.dumps(response_data), content_type='application/json')


class UserPasswordResetRequestView(FormView):
    model = User
    template_name = "accounts/forgot-password.html"
    success_url = reverse_lazy("user_mgmt:login")
    form_class = PasswordResetRequestForm


    def form_valid(self, form):
        current_user_email = form.cleaned_data["email"]
        current_user = User.objects.filter(email=current_user_email)

        if current_user:
            url = Site.objects.get_current().domain
            user = current_user[0]
            email_template_name = "accounts/password-reset/password_reset_email.html"
            email_content = {
                "email": user.email,
                # 'domain': self.request.headers['Host'],
                "domain": url,
                'site_name': 'NNRFC',
                "logo_img": self.request.build_absolute_uri(static("email/logo.png")),
                'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                'user': user,
                'url':url,
                'token': PasswordResetTokenGenerator.make_token(self=account_activation_token, user=user),
				"protocol": "https",
            }
            msg = render_to_string(email_template_name, email_content)
            try:
                send_html_email(msg, current_user)
            except:
                print('email sending failed')
            return redirect('password_reset_done')

        return JsonResponse({"success": True, "msg": self.success_message})
