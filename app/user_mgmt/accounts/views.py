import logging

from django.conf import settings
from django.contrib import messages

logger = logging.getLogger(__name__)
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
from user_mgmt.accounts.forms import (
    PasswordResetRequestForm,
    SetNewStaffPasswordForm,
    UserLoginForm,
    UserSetupForm,
)
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


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _build_invitation_context(request, user, pwd):
    """Return the template context used for the user-invitation email."""
    url = Site.objects.get_current().domain
    return {
        "email": user.email,
        "pwd": pwd,
        "domain": url,
        "full_name": user.full_name,
        "login_url": request.build_absolute_uri(reverse("user_mgmt:login")),
        "logo_img": request.build_absolute_uri(static("email/logo.png")),
        "protocol": "https",
    }


def _collect_recipients(user):
    """
    Return a de-duplicated list of email addresses to notify when a new
    user account is created.

    Rules
    -----
    * personal_email  – always included (primary credential-delivery address).
    * email (office)  – added only when it is non-empty AND differs from the
                        personal email, so we never send the same address twice.
    """
    recipients = []

    personal = (user.personal_email or "").strip().lower()
    office   = (user.email or "").strip().lower()

    if personal:
        recipients.append(personal)

    if office and office != personal:
        recipients.append(office)

    return recipients


# ---------------------------------------------------------------------------
# User Creation
# ---------------------------------------------------------------------------

class StaffUserCreateView(SuccessMessageMixin, CreateView):
    model = User
    template_name = "accounts/user_setup.html"
    success_url = reverse_lazy("user_mgmt:user_list")
    success_message = "प्रयोगकर्ता सिर्जना भयो। प्रमाण-पत्र इमेल गरिएको छ।"
    form_class = UserSetupForm

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["roles"]       = Role.objects.all()
        context["users"]       = get_users_by_level(self.request.user)
        context["departments"] = Department.objects.all()
        return context

    def form_valid(self, form):
        # 1. Use the password the admin explicitly entered in the form.
        pwd = self.request.POST.get("password", "").strip()
        confirm = self.request.POST.get("confirm_password", "").strip()

        if not pwd:
            return JsonResponse({"password": "पासवर्ड आवश्यक छ।"})
        if len(pwd) < 8:
            return JsonResponse({"password": "पासवर्ड कम्तिमा ८ अक्षर हुनुपर्छ।"})
        if pwd != confirm:
            return JsonResponse({"confirm_password": "पासवर्डहरू मेल खाएनन्।"})

        form.instance.set_password(pwd)
        form.instance.is_first_login = True
        form.instance.is_active      = True

        # 2. Persist the user FIRST — never lose the record due to email failure.
        user = form.save()

        # 3. Build email payload.
        html_template = "email/user_invitation.html"
        context       = _build_invitation_context(self.request, user, pwd)
        msg           = render_to_string(html_template, context)
        recipients    = _collect_recipients(user)

        # 4. Send synchronously so failures are caught immediately.
        email_failed = False

        if not recipients:
            email_failed = True
        else:
            try:
                from django.core.mail import send_mail
                send_mail(
                    subject="तपाईंको NNRFC खाता सिर्जना गरियो",
                    message="",
                    html_message=msg,
                    from_email=settings.DEFAULT_FROM_EMAIL,
                    recipient_list=recipients,
                    fail_silently=False,
                )
            except Exception as exc:
                email_failed = True
                logger.warning(
                    "User created but invitation email failed. "
                    "User: %s (id=%s) | Recipients: %s | Error: %s | "
                    "Password (reset ASAP): %s",
                    user.email, user.pk, recipients, exc, pwd,
                )

        is_dev = settings.DEBUG and getattr(
            settings, "EMAIL_BACKEND", ""
        ) == "django.core.mail.backends.console.EmailBackend"

        if email_failed:
            if is_dev:
                return JsonResponse({
                    "success":      True,
                    "email_failed": True,
                    "msg": (
                        f"प्रयोगकर्ता सिर्जना भयो। "
                        f"(Dev mode — console backend) | "
                        f"ईमेल: {', '.join(recipients) if recipients else 'कुनै ईमेल छैन'} | "
                        f"पासवर्ड: {pwd}"
                    ),
                })
            return JsonResponse({
                "success":      True,
                "email_failed": True,
                "msg": (
                    "प्रयोगकर्ता सिर्जना भयो तर इमेल पठाउन सकिएन। "
                    "पासवर्ड सर्भर लगमा सुरक्षित रूपमा रेकर्ड गरिएको छ।"
                ),
            })

        if is_dev:
            return JsonResponse({
                "success": True,
                "msg": (
                    f"प्रयोगकर्ता सिर्जना भयो। "
                    f"(Dev mode — टर्मिनलमा हेर्नुहोस्) | "
                    f"ईमेल: {', '.join(recipients)} | "
                    f"पासवर्ड: {pwd}"
                ),
            })

        return JsonResponse({
            "success": True,
            "msg": f"प्रयोगकर्ता सिर्जना भयो। प्रमाण-पत्र {', '.join(recipients)} मा पठाइयो।",
        })

    def form_invalid(self, form):
        return JsonResponse(form.errors)


# ---------------------------------------------------------------------------
# User Update
# ---------------------------------------------------------------------------

class UserUpdateView(UpdateView):
    model               = User
    template_name       = "accounts/user_edit.html"
    success_url         = reverse_lazy("user_mgmt:user_list")
    form_class          = UserSetupForm
    context_object_name = "user"
    success_message     = "प्रयोगकर्ता सफलतापूर्वक अपडेट गरियो।"

    def get_context_data(self, **kwargs):
        user    = self.request.user
        context = super().get_context_data(**kwargs)
        context["provinces"]   = Level.objects.filter(type__type="P")
        context["roles"]       = Role.objects.all()
        context["departments"] = Department.objects.all()
        context["posts"]       = UserPost.objects.all()
        context["l_levels"]    = get_local_levels_by_province(user.level, user)
        return context

    def form_valid(self, form):
        user           = form.save()
        user.is_staff  = user.roles.all().exists()
        user.save()
        messages.success(self.request, self.success_message)
        return JsonResponse({"success": True, "msg": self.success_message})

    def form_invalid(self, form):
        return JsonResponse(form.errors)


# ---------------------------------------------------------------------------
# User List
# ---------------------------------------------------------------------------

class UserListView(ListView):
    model               = User
    template_name       = "accounts/user_setup.html"
    context_object_name = "users"

    def get_context_data(self, **kwargs):
        user    = self.request.user
        context = super().get_context_data(**kwargs)
        context["level_types"] = LevelType.objects.all()
        context["provinces"]   = Level.objects.filter(type__type="P")
        context["roles"]       = Role.objects.all()
        context["departments"] = Department.objects.all()
        context["posts"]       = UserPost.objects.all()
        context["l_levels"]    = get_local_levels_by_province(user.level, user)

        qs                  = get_users_by_level(user)
        context["p_users"]  = qs.filter(level__type__type="P")
        context["l_users"]  = qs.filter(level__type__type="L")
        return context


# ---------------------------------------------------------------------------
# Authentication
# ---------------------------------------------------------------------------

class UserLoginView(LoginView):
    template_name             = "accounts/login.html"
    redirect_authenticated_user = True

    def get_success_url(self):
        if self.request.user.is_first_login:
            return reverse("set_password")
        return reverse("dashboard:dashboard")


class SetNewPasswordView(UserPassesTestMixin, SuccessMessageMixin, FormView):
    """Force a staff user to set their own password after first login."""

    form_class       = SetNewStaffPasswordForm
    template_name    = "accounts/set_new_password.html"
    success_message  = "पासवर्ड सफलतापूर्वक परिवर्तन गरियो।"

    def test_func(self):
        if self.request.user.is_authenticated:
            return self.request.user.is_first_login
        raise Http404

    def form_valid(self, form):
        password          = form.cleaned_data.get("new_password2")
        user              = self.request.user
        user.is_staff     = user.roles.all().exists()
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


class UserLogoutView(LogoutView):
    next_page = reverse_lazy("user_mgmt:login")


# ---------------------------------------------------------------------------
# Admin: Change a user's password (no current password required)
# ---------------------------------------------------------------------------

def admin_change_user_password(request, user_id):
    """
    Allow an admin to reset any user's password without knowing the current one.
    Responds with JSON for the AJAX modal on the user-setup page.
    """
    if request.method != "POST":
        return JsonResponse({"success": False, "msg": "Invalid request method."})

    try:
        target_user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return JsonResponse({"success": False, "msg": "प्रयोगकर्ता फेला परेन।"})

    new_password     = request.POST.get("new_password", "").strip()
    confirm_password = request.POST.get("confirm_password", "").strip()

    # --- Validation ---
    if len(new_password) < 8:
        return JsonResponse({
            "success":      False,
            "new_password": "पासवर्ड कम्तिमा ८ अक्षर हुनुपर्छ।",
        })

    if new_password != confirm_password:
        return JsonResponse({
            "success":          False,
            "confirm_password": "पासवर्डहरू मेल खाएनन्।",
        })

    # --- Apply ---
    target_user.set_password(new_password)
    target_user.is_first_login = False   # clear forced-change flag if set
    target_user.save()

    # --- Notify the user by email (both addresses, non-fatal) ---
    recipients = _collect_recipients(target_user)
    if recipients:
        try:
            ctx = {
                "full_name": target_user.full_name,
                "login_url": request.build_absolute_uri(reverse("user_mgmt:login")),
                "logo_img":  request.build_absolute_uri(static("email/logo.png")),
            }
            msg = render_to_string("email/password_changed.html", ctx)
            from django.core.mail import send_mail
            send_mail(
                subject="तपाईंको NNRFC पासवर्ड परिवर्तन गरियो",
                message="",
                html_message=msg,
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=recipients,
                fail_silently=True,
            )
        except Exception:
            pass

    return JsonResponse({"success": True, "msg": "पासवर्ड सफलतापूर्वक परिवर्तन गरियो।"})


# ---------------------------------------------------------------------------
# Delete helpers
# ---------------------------------------------------------------------------

def delete_user(request, user_id):
    if request.method == "POST":
        User.objects.filter(id=user_id).delete()
        messages.success(request, "प्रयोगकर्ता सफलतापूर्वक मेटाइयो।")
        return redirect("user_mgmt:user_list")


def delete_department(request, department_id):
    if request.method == "POST":
        Department.objects.filter(id=department_id).delete()
        messages.success(request, "विभाग सफलतापूर्वक मेटाइयो।")
        return redirect("user_mgmt:depart_list")


# ---------------------------------------------------------------------------
# Department CRUD
# ---------------------------------------------------------------------------

class DepartmentCreateView(SuccessMessageMixin, CreateView):
    model           = Department
    template_name   = "accounts/depart_list.html"
    fields          = ["name", "address", "email"]
    success_url     = reverse_lazy("user_mgmt:depart_list")
    success_message = "विभाग सफलतापूर्वक सिर्जना गरियो।"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["departs"] = Department.objects.all()
        return context


class DepartmentUpdateView(SuccessMessageMixin, UpdateView):
    model               = Department
    template_name       = "accounts/depart_update.html"
    success_url         = reverse_lazy("user_mgmt:depart_list")
    fields              = ["name", "address", "email"]
    success_message     = "विभाग सफलतापूर्वक अपडेट गरियो।"
    context_object_name = "depart"


class DepartmentListView(ListView):
    model               = Department
    template_name       = "accounts/depart_list.html"
    context_object_name = "departs"


# ---------------------------------------------------------------------------
# Level / Department AJAX endpoints
# ---------------------------------------------------------------------------

def get_levels(request, type_id):
    level_type = LevelType.objects.filter(id=type_id).first()
    qs         = list(Level.objects.filter(type=level_type).values("id", "name"))

    if request.user.is_superuser:
        levels = qs
    elif level_type and level_type.type == "P":
        user_role_levels = request.user.roles.all().values_list("level")
        levels = list(
            Level.objects.filter(type=level_type, id__in=user_role_levels)
            .values("id", "name")
        )
    else:
        levels = qs

    return JsonResponse({"levels": levels})


def get_level_departments(request, level_id):
    departs = list(
        Department.objects.filter(level_id=level_id).values("id", "name")
    )
    return JsonResponse({"departs": departs})


# ---------------------------------------------------------------------------
# Password reset (public — no login required)
# ---------------------------------------------------------------------------

class UserPasswordResetRequestView(FormView):
    model       = User
    template_name = "accounts/forgot-password.html"
    success_url = reverse_lazy("user_mgmt:login")
    form_class  = PasswordResetRequestForm

    def form_valid(self, form):
        email        = form.cleaned_data["email"]
        current_user = User.objects.filter(email=email).first()

        if current_user:
            url    = Site.objects.get_current().domain
            tpl    = "accounts/password-reset/password_reset_email.html"
            ctx    = {
                "email":     current_user.email,
                "domain":    url,
                "site_name": "NNRFC",
                "logo_img":  self.request.build_absolute_uri(static("email/logo.png")),
                "uid":       urlsafe_base64_encode(force_bytes(current_user.pk)),
                "user":      current_user,
                "url":       url,
                "token":     account_activation_token.make_token(current_user),
                "protocol":  "https",
            }
            msg = render_to_string(tpl, ctx)
            try:
                send_html_email(msg, [current_user])
            except Exception:
                pass   # silently fail — never expose whether an address exists

        # Always redirect to "done" regardless of whether the user was found
        # (prevents user-enumeration attacks).
        return redirect("password_reset_done")


# ---------------------------------------------------------------------------
# Legacy / Deprecated views kept for URL compatibility
# ---------------------------------------------------------------------------

def change_password(request):
    """
    Self-service password change (requires the current password).
    Kept for URL compatibility — prefer the class-based view for new code.
    """
    response_data = {}
    if request.method == "POST":
        current_password      = request.POST.get("currentPassword", "")
        new_password          = request.POST.get("newPassword", "")
        confirm_new_password  = request.POST.get("confirmNewPassword", "")

        user  = User.objects.get(id=request.user.id)
        valid = user.check_password(current_password)

        if valid:
            if new_password and new_password == confirm_new_password:
                user.set_password(confirm_new_password)
                user.save()
                response_data["result"]  = "Success!"
                response_data["message"] = "Password Changed Successfully."
            else:
                response_data["result"]  = "Invalid Passwords!"
                response_data["message"] = "Passwords do not match."
        else:
            response_data["result"]  = "Incorrect Password!"
            response_data["message"] = "Current password is incorrect."

    return HttpResponse(
        json.dumps(response_data), content_type="application/json"
    )


def registration_view(request):
    if request.user.is_authenticated:
        return redirect("core/dashboard/home")

    form = UserLoginForm()
    if request.method == "POST":
        form = UserLoginForm(request.POST)
        if form.is_valid():
            email    = form.cleaned_data.get("email")
            password = form.cleaned_data.get("password")
            user     = User.objects.create(email=email, password=password)
            login(request, user)
            messages.success(request, "Account was created for " + user)
            return redirect("login")

    return render(request, "accounts/registration.html", {"form": form})


def authenticate_user(email, password):
    try:
        user = User.objects.get(email=email)
        return user if user.check_password(password) else None
    except User.DoesNotExist:
        return None


class LoginUserView(LoginView):
    """Legacy login view — prefer UserLoginView for new code."""
    template_name = "accounts/login.html"

    def get(self, request):
        return render(request, self.template_name)

    def post(self, request):
        email    = request.POST.get("email", "")
        password = request.POST.get("password", "")

        context = {
            "email_error":    "यो क्षेत्र आवश्यक छ।" if not email    else None,
            "password_error": "यो क्षेत्र आवश्यक छ।" if not password else None,
        }

        user = authenticate_user(email, password)
        if user is not None:
            login(request, user)
            messages.success(request, "सफलतापूर्वक लगइन गरियो।")
            return redirect("dashboard:home" if user.is_staff else "core:survey_list")

        context["error_message"] = "कृपया सही लगइन प्रमाण-पत्र दिनुहोस्।"
        return render(request, self.template_name, context)