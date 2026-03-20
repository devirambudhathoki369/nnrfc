from django.urls import reverse
from django.shortcuts import redirect


class DashboardRestrictMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path.startswith("/dashboard/"):
            # Allow login/logout pages without authentication
            login_path = reverse("user_mgmt:login")
            exempt_paths = [login_path, "/dashboard/users/login/"]
            
            if request.path not in exempt_paths and not request.user.is_authenticated:
                return redirect(login_path)
        
        response = self.get_response(request)
        return response