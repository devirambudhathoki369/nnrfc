from user_mgmt.views import RoleCreateView, RoleListView, RoleUpdateView, delete_role
from user_mgmt.accounts.views import (
    DepartmentCreateView,
    DepartmentListView,
    DepartmentUpdateView,
    SetNewPasswordView,
    UserListView,
    StaffUserCreateView,
    UserLoginView,
    UserUpdateView,
    delete_department,
    delete_user,
    get_level_departments,
    get_levels,
    registration_view,
    LoginUserView,
    UserLogoutView
)

from django.urls.conf import include, path


app_name = "user_mgmt"

urlpatterns = [
    path("", UserListView.as_view(), name="user_list"),
    path("create/", StaffUserCreateView.as_view(), name="staff_create"),
    path("update/<int:pk>/", UserUpdateView.as_view(), name="user_edit"),
    path("delete/<int:user_id>/", delete_user, name="user_delete"),
    path("roles/", RoleListView.as_view(), name="role_list"),
    path("roles/create/", RoleCreateView.as_view(), name="role_create"),
    path("roles/update/<int:pk>/", RoleUpdateView.as_view(), name="role_update"),
    path("roles/delete/<int:role_id>/", delete_role, name="role_delete"),
    path("levels/<int:type_id>/", get_levels, name="get_levels"),
    path("level-departs/<int:level_id>/", get_level_departments, name="get_level_departs"),
    path("login/", UserLoginView.as_view(), name="login"),
    path("department-create/", DepartmentCreateView.as_view(), name="depart_create"),
    path("department-list/", DepartmentListView.as_view(), name="depart_list"),
    path("department-update/<int:pk>/", DepartmentUpdateView.as_view(), name="depart_update"),
    path("department-delete/<int:department_id>/", delete_department, name="depart_delete"),
    # path(
    #     "change/password/",
    #     UserPasswordChangeView.as_view(
    #         template_name="accounts/change-password.html", success_url="/"
    #     ),
    #     name="change-password",
    # ),
]
