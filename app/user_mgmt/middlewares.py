from django.http.response import Http404
from django.urls import reverse


class DashboardRestrictMiddleware:
    """
    Middleware which will restrict the normal users to access paths starting from `/dashboard`
    only active staff users will have access.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        login_path = reverse("user_mgmt:login")
        if request.path != login_path and request.path.startswith("/dashboard/"):
            if not request.user.is_staff:
                raise Http404
        response = self.get_response(request)
        return response
