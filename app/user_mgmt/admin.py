from django.contrib import admin
from django.contrib.auth import get_user_model
from user_mgmt.models import (
    Department,
    Level,
    LevelType,
    Menu,
    MenuPermission,
    Role,
    UserPost,
    District,
)

User = get_user_model()
# Register your models here.

admin.site.register(
    [Menu, MenuPermission, Role, User, LevelType, District, Level, Department, UserPost]
)
