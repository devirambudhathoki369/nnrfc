from core.models import Question
from django.contrib.auth import get_user_model
from user_mgmt.models import Department, Level, MenuPermission, Role
from django.db.models import Q
from user_mgmt.models import User

# User = get_user_model()


def get_user_perm(user, menu):
    return MenuPermission.objects.filter(menu=menu, role__users=user).distinct()


def admin(request):
    return request.user.is_superuser


def role_menus_bulk_create(role, m_ids, *perms):
    params = zip(m_ids, *perms)
    for p in params:
        role_perms = {
            "can_add": p[1],
            "can_view": p[2],
            "can_change": p[3],
            "can_delete": p[4],
        }

        MenuPermission.objects.update_or_create(menu_id=p[0], role=role)
        MenuPermission.objects.filter(menu_id=p[0], role=role).update(**role_perms)


def get_users_by_level(user):
    qs = User.objects.all()
    if not user.is_superuser:
        u_lvl = user.level
        child_levels = u_lvl.child_level.all()
        qs = qs.filter(Q(level=u_lvl) | Q(level__in=child_levels))
    return qs


def get_local_levels_by_province(province, user):
    qs = Level.objects.filter(type__type="L")
    if not user.is_superuser:
        qs = qs.filter(province_level=province)
    return qs


def get_index_by_department(survey, user):
    qs = survey.questions.filter(parent=None).order_by("sequence_id")
    if not user.is_superuser:
        qs = qs.filter(department=user.department)
    return qs
