from django.http.response import Http404
from django.urls import reverse
from django.shortcuts import redirect


class DashboardRestrictMiddleware:
    """
    Middleware: /dashboard/ is only for authenticated users.
    Non-authenticated users are redirected to login.
    """
 
    def __init__(self, get_response):
        self.get_response = get_response
 
    def __call__(self, request):
        if request.path.startswith("/dashboard/"):
            if not request.user.is_authenticated:
                return redirect(reverse("user_mgmt:login"))
        response = self.get_response(request)
        return response