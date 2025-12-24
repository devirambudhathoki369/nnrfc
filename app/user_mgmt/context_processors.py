from user_mgmt.models import Menu


def get_dashboard_menus(request):
    all_menus = Menu.objects.all()
    u = request.user
    if u.is_authenticated and not u.is_superuser:
        # filter authorized menus by the user roles
        u_roles = u.roles.all()
        qs = all_menus.filter(permissions__role__in=u_roles, permissions__can_view=True)
        all_menus = qs.filter(parent__isnull=True).distinct()

    context = {"menus": all_menus}
    return context

