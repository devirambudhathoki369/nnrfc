from django import template
from user_mgmt.models import MenuPermission

register = template.Library()


# below template tags are for checking if the permission already checked inside role or not
def role_rights(menu, role):
    return  MenuPermission.objects.filter(menu=menu, role=role)

@register.simple_tag
def role_can_change(menu, role):
    """returns html class `checked` if menu right already in user role"""
    if role_rights(menu,role).filter(can_change=True).exists():
        return "checked"

@register.simple_tag
def role_can_add(menu, role):
    if role_rights(menu,role).filter(can_add=True).exists():
        return "checked"

@register.simple_tag
def role_can_view(menu, role):
    if role_rights(menu,role).filter(can_view=True).exists():
        return "checked"

@register.simple_tag
def role_can_delete(menu, role):
    if role_rights(menu,role).filter(can_delete=True).exists():
        return "checked"

