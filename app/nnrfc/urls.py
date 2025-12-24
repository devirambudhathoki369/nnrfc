"""nnrfc URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib.auth.views import PasswordResetView, PasswordResetConfirmView, PasswordResetDoneView
from user_mgmt.accounts.forms import PasswordResetRequestForm
from user_mgmt.accounts.views import SetNewPasswordView, UserLogoutView, change_password, UserPasswordResetRequestView
from django.contrib import admin
from django.urls import path, reverse_lazy
from django.urls.conf import include
from django.conf import settings
from django.conf.urls.static import static
from django.conf.urls import (
    handler400, handler403, handler404, handler500
)

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("core.urls")),
    path("dashboard/users/", include("user_mgmt.urls")),
    path("dashboard/", include("core.dashboard.urls")),
    path("dashboard/reports/", include("core.reports.urls")),
    path("users/set-password/", SetNewPasswordView.as_view(), name="set_password"),
    path("logout/", UserLogoutView.as_view(), name="logout"),
    path("change_password/", change_password, name="change_password"),

    # forgot password
    path("users/password-reset/", UserPasswordResetRequestView.as_view(),name='password_reset'),
    
    path("users/password-reset-done/", PasswordResetDoneView.as_view(
                                                    template_name='accounts/password-reset/password_reset_done.html'),name='password_reset_done'),
    path("users/password-reset-confirm/<uidb64>/<token>/", PasswordResetConfirmView.as_view(
                                                    template_name='accounts/password-reset-form.html',
                                                    success_url=reverse_lazy('user_mgmt:login')
                                                    ),
                                                    name='password_reset_confirm'),
]
handler400 = "core.views.bad_request"
handler403 = "core.views.permission_denied"
handler404 = "core.views.page_not_found"
handler500 = "core.views.server_error"

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
