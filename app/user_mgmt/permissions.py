from user_mgmt.utils import admin, get_user_perm
from user_mgmt.models import Menu
from django.contrib.auth.mixins import UserPassesTestMixin
from django.db.models import Q


class DashboardPerm(UserPassesTestMixin):
    """returns `True` if permission granted otherwise `False`"""

    def get_qs(self):
        # get menu with the code of menu
        menu = Menu.objects.get(code="dashboard")
        # returns users permissions in dashboard menu
        return get_user_perm(self.request.user, menu)

    def test_func(self):
        # returns True if user has `can_view` permission on the dashboard menu
        can_view = self.get_qs().filter(can_view=True).exists()
        return can_view or admin(self.request)


class RolesViewPerm(DashboardPerm):
    def get_qs(self):
        menu = Menu.objects.get(code="roles")
        return get_user_perm(self.request.user, menu)


class RolesCreatePerm(RolesViewPerm):
    def test_func(self):
        return self.get_qs().filter(can_add=True).exists() or admin(self.request)


class RolesUpdatePerm(RolesViewPerm):
    def test_func(self):
        return self.get_qs().filter(can_change=True).exists() or admin(self.request)


class RolesDeletePerm(RolesViewPerm):
    def test_func(self):
        return self.get_qs().filter(can_delete=True).exists() or admin(self.request)
