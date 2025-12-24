from django import template
from user_mgmt.models import Menu, MenuPermission
from user_mgmt.utils import admin

register = template.Library()


def menu_perms(request, menu_code):
    if request.user.is_authenticated:
        return MenuPermission.objects.filter(
            menu__code=menu_code, role__users=request.user
        )
    return MenuPermission.objects.none()


@register.simple_tag
def user_can_change(request, code):
    """returns True if user has the permission for update otherwise False"""
    can_change = menu_perms(request, code).filter(can_change=True).exists()
    return admin(request) or can_change


@register.simple_tag
def user_can_add(request, code):
    can_add = menu_perms(request, code).filter(can_add=True).exists()
    return admin(request) or can_add


@register.simple_tag
def user_can_view(request, code):
    can_view = menu_perms(request, code).filter(can_view=True).exists()
    return admin(request) or can_view


@register.simple_tag
def user_can_delete(request, code):
    can_delete = menu_perms(request, code).filter(can_delete=True).exists()
    return admin(request) or can_delete
