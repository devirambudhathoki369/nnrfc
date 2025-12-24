from functools import wraps
from user_mgmt.utils import get_user_perm
from user_mgmt.models import Menu
from django.core.exceptions import PermissionDenied


def check_perm(code, **perm):
    """
    use this decorator to check permission if your view is function based
    """
    # example:
    # @check_perm('your_menu_code', can_view=True)
    # def your_view():

    def _method_wrapper(view_method):
        def _arguments_wrapper(request, *args, **kwargs):
            menu = Menu.objects.get(code=code)
            qs = get_user_perm(request.user, menu)
            if request.user.is_superuser or qs.filter(**perm).exists():
                return view_method(request, *args, **kwargs)
            raise PermissionDenied

        return _arguments_wrapper

    return _method_wrapper
