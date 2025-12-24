from user_mgmt.permissions import RolesCreatePerm, RolesUpdatePerm, RolesViewPerm
from user_mgmt.decorators import check_perm
from django.contrib import messages
from django.views.generic.edit import UpdateView
from user_mgmt.utils import role_menus_bulk_create
from django.shortcuts import redirect, render
from django.views.generic import CreateView, ListView
from user_mgmt.models import Level, Menu, Role
from django.urls import reverse_lazy
from django.db import transaction
from django.contrib.messages.views import SuccessMessageMixin

# Create your views here.


class RoleCreateView(RolesCreatePerm, SuccessMessageMixin, CreateView):
    model = Role
    fields = ["name", "desc"]
    template_name = "user_mgmt/role_create.html"
    success_url = reverse_lazy("user_mgmt:role_list")
    success_message = "Role Created Successfully."

    def form_valid(self, form):
        formdata = self.request.POST
        menus = formdata.getlist("m_id")
        can_add = formdata.getlist("can_add")
        can_view = formdata.getlist("can_view")
        can_update = formdata.getlist("can_change")
        can_delete = formdata.getlist("can_delete")
        v_perms = [True if id in can_view else False for id in menus]
        a_perms = [True if id in can_add else False for id in menus]
        u_perms = [True if id in can_update else False for id in menus]
        d_perms = [True if id in can_delete else False for id in menus]
        with transaction.atomic():
            role = form.save()
            if menus:
                role.menus.set(menus)
                role_menus_bulk_create(role, menus, a_perms, v_perms, u_perms, d_perms)
        return super().form_valid(form)


class RoleUpdateView(RolesUpdatePerm, SuccessMessageMixin, UpdateView):
    model = Role
    fields = ["name", "desc"]
    template_name = "user_mgmt/role_edit.html"
    success_url = reverse_lazy("user_mgmt:role_list")
    success_message = "Role Updated Successfully."
    context_object_name = "role"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        role_menus = self.get_object().menus.all()
        context["role_menus"] = Menu.objects.filter(id__in=role_menus)
        return context

    def form_valid(self, form):
        formdata = self.request.POST
        menus = formdata.getlist("m_id")
        can_add = formdata.getlist("can_add")
        can_view = formdata.getlist("can_view")
        can_update = formdata.getlist("can_change")
        can_delete = formdata.getlist("can_delete")
        v_perms = [True if id in can_view else False for id in menus]
        a_perms = [True if id in can_add else False for id in menus]
        u_perms = [True if id in can_update else False for id in menus]
        d_perms = [True if id in can_delete else False for id in menus]
        with transaction.atomic():
            role = form.save()
            if menus:
                role.menus.set(menus)
                role_menus_bulk_create(role, menus, a_perms, v_perms, u_perms, d_perms)

        return super().form_valid(form)


class RoleListView(RolesViewPerm, ListView):
    model = Role
    template_name = "user_mgmt/role_list.html"
    context_object_name = "roles"
    ordering = ["name"]


@check_perm("roles", can_delete=True)
def delete_role(request, role_id):
    role = Role.objects.get(id=role_id)
    if request.method == "POST":
        role.delete()
        messages.success(request, "Role Deleted Successfully.")
        return redirect("user_mgmt:role_list")
