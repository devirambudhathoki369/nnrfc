from django.urls import path

from core.reports.views import export_reports, export_reports_all_levels, filter_local_levels, reports_view


app_name = "report"
urlpatterns = [
    path("", reports_view, name="reports"),
    path(
        "export-report/<int:q_id>/<int:level_id>/", export_reports, name="export_report"
    ),
    path("filter-local-levels/<int:p_id>/", filter_local_levels, name="filter_locals"),
    path(
        "export-report-levels/<int:q_id>/<str:level_type>", export_reports_all_levels, name="export_report_levels"
    ),
]
