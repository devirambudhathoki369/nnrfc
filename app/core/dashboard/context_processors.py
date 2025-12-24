from core.models import Notification
from django.db.models import Q


def get_notifications(request):
    u = request.user
    qs = Notification.objects.filter(is_viewed=False)
    # dashboard admin notifications
    d_notifs = qs.filter(correction_checked=False)
    u_end_notifs = None
    if u.is_authenticated and not u.is_superuser:
        # filter admin notifications based on user level
        u_level = u.level
        child_levels = u_level.child_level.all()
        d_notifs = d_notifs.filter(Q(level=u_level) | Q(level__in=child_levels))
        # user side notifications
        u_end_notifs = qs.filter(correction_checked=True, user=u)
    return {"notifications": d_notifs, "u_end_notifs": u_end_notifs}
