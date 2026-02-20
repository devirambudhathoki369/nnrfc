from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import ugettext as _
from django.conf import settings


# Create your models here.


class AbstractInfo(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True 


class User(AbstractUser):
    full_name = models.CharField(_("Full Name"), max_length=100, null=True)
    roles = models.ManyToManyField("Role", blank=True, related_name="users")
    email = models.EmailField((_("Email")), unique=True)
    personal_email = models.EmailField(_("Personal Email"), null=True)          
    department = models.ForeignKey(
        "Department",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        verbose_name=_("Department"),
    )
    mobile_num = models.CharField(
        _("Mobile Number"), max_length=12, blank=True, null=True
    )
    address = models.CharField(_("Address"), max_length=50, blank=True, null=True)
    designation = models.CharField(
        _("Designation"), max_length=50, blank=True, null=True
    )
    level = models.ForeignKey("Level", on_delete=models.SET_NULL, null=True)
    is_first_login = models.BooleanField(default=False)
    is_office_head = models.BooleanField(default =False)
    post = models.ForeignKey(
        "UserPost",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="users",
    )

    def save(self, *args, **kwargs):
        self.username = self.email
        return super().save(*args, **kwargs)

    class Meta:
        ordering = ["-date_joined"]

    def __str__(self):
        return self.email


class UserPost(AbstractInfo):
    name = models.CharField(_("User Post"), max_length=50)

    def __str__(self):
        return self.name


class Menu(AbstractInfo):
    name = models.CharField(max_length=200, unique=True)
    code = models.CharField(max_length=50, unique=True, db_index=True)
    parent = models.ForeignKey(
        "self", on_delete=models.CASCADE, null=True, blank=True, related_name="children"
    )
    order_id = models.PositiveSmallIntegerField(null=True, blank=True)
    url = models.CharField(max_length=100, default="/")
    ic_class = models.CharField(max_length=50, null=True, blank=True)

    def __str__(self):
        return f"{self.name} (CODE:{self.code})"

    class Meta:
        ordering = ["order_id"]

    def save(self, *args, **kwargs):
        if not self.order_id:
            try:
                self.order_id = Menu.objects.order_by("pk").last().order_id + 1
            except Exception as e:
                self.order_id = 1
        return super().save(*args, **kwargs)


class MenuPermission(models.Model):
    menu = models.ForeignKey(Menu, on_delete=models.CASCADE, related_name="permissions")
    role = models.ForeignKey(
        "Role",
        blank=True,
        related_name="menu_permissions",
        null=True,
        on_delete=models.CASCADE,
    )
    can_add = models.BooleanField((_("Can add")), default=False)
    can_change = models.BooleanField((_("Can change")), default=False)
    can_view = models.BooleanField((_("Can view")), default=False)
    can_delete = models.BooleanField((_("Can delete")), default=False)
    can_approve = models.BooleanField((_("Can approve")), default=False)

    def __str__(self):
        return f"{self.role} ==> {self.menu}"


class Role(AbstractInfo):
    name = models.CharField((_("Name")), max_length=50, unique=True)
    menus = models.ManyToManyField(Menu, blank=True)
    desc = models.TextField(_("Description"), blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = _("Role")
        verbose_name_plural = _("Roles")


class LevelType(models.Model):
    type_choices = (("L", "Local Level"), ("P", "Province Level"))
    type = models.CharField(max_length=1, choices=type_choices)

    def __str__(self):
        return self.type

class District(models.Model):
    name_eng = models.CharField(max_length=150)
    name_np = models.CharField(max_length=150)
    code = models.CharField(max_length=15, null=True)

    def __str__(self) -> str:
        return self.name_np


class Level(models.Model):
    type = models.ForeignKey(LevelType, null=True, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    province_level = models.ForeignKey(
        "self",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="child_level",
        verbose_name=_("Provience Level"),
    )
    district = models.ForeignKey(
        District,
        null=True,
        blank=True,
        on_delete=models.PROTECT,
        related_name="levels"
    )
    level_code = models.CharField(max_length=50, null=True, blank=True)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ["name"]


class Department(AbstractInfo):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=100, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ["name"]
