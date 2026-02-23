from django.urls.conf import include
from django.views.generic.base import TemplateView
from core.dashboard.views import (
    AddIndexView,
    AddMoreIndexToSurvey,
    IndexCreateView,
    IndexDeleteView,
    IndexOptionCreateView,
    IndexOptionUpdateView,
    IndexUpdateView,
    OptionCreateView,
    SettingsView,
    SurveyDetailView,
    assign_department_to_index,
    complaint_detail,
    correction_fix_view,
    fill_surveys_list,
    get_correction_detail,
    get_correction_requests,
    get_question_options,
    level_complaints,
    list_complaints,
    log_detail_view,
    mark_complaint_checked,
    show_activity_logs,
    show_questions_logs,
    survey_filled_questions,
    survey_list,
    view_filled_ans,
    MasterConfigurationView,
    ProvinceNameCreateView,
    ProvinceNameUpdateView,
    LocalNameUpdateView,
    DepartmentNameListView,
    DepartmentNameUpdateView,
    UsersPostNameUpdateView,
    appraisal_review_request,
    appraisal_review_request_detail,
    level_appraisals,
    mark_appraisal_checked,
    DistrictNameUpdateView,
    FiscalYearUpdateView
)
from django.urls import path
from . import views


app_name = "dashboard"
urlpatterns = [
    # path(
    #     "",
    #     TemplateView.as_view(template_name="core/dashboard/dashboard_home.html"),
    #     name="dashboard",
    # ),
    path("",views.DashBoardHome.as_view(),name="dashboard"),
    path("index/", views.DashboardIndexView.as_view(), name="home"),
    path("index-create/", IndexCreateView.as_view(), name="index_create"),
    path(   
        "survey-detail/<int:survey_id>/",
        SurveyDetailView.as_view(),
        name="survey_detail",
    ),
    path(
        "assign-department/<int:q_id>/",
        assign_department_to_index,
        name="assign_depart",
    ),
    path("index-delete/<int:pk>/", IndexDeleteView.as_view(), name="index_delete"),
    path("index-update/<int:pk>/", IndexUpdateView.as_view(), name="index_update"),
    path(
        "index-option-create/<int:ques_id>/",
        IndexOptionCreateView.as_view(),
        name="index_option_create",
    ),
    path(
        "option-create/<int:ques_id>/",
        OptionCreateView.as_view(),
        name="option_create",
    ),
    path(
        "index-option-update/<int:ques_id>/",
        IndexOptionUpdateView.as_view(),
        name="index_option_update",
    ),
    path(
        "index-add/<int:survey_id>/",
        AddIndexView.as_view(),
        name="add_index",
    ),
    path(
        "get-question-options/<int:q_id>/",
        get_question_options,
        name="q_options",
    ),
    path(
        "index-option-add/<int:ques_id>/",
        AddMoreIndexToSurvey.as_view(),
        name="index_option_add_more",
    ),
    path("correction-requests/", get_correction_requests, name="correction_req"),
    path(
        "correction-detail/<int:level_id>/",
        get_correction_detail,
        name="correction_detail",
    ),
    path(
        "correction/<int:correction_id>/<int:ques_id>/",
        correction_fix_view,
        name="correction_fix",
    ),
    path("activity-logs/", show_activity_logs, name="activity_log"),
    path("activity_log_detail/<action_level>/", log_detail_view, name="log_detail"),
    path("show-question-logs/<int:q_id>/<level>/", show_questions_logs, name="q_logs"),
    path(
        "activity_log_detail/<action_level>/<int:q_id>/",
        log_detail_view,
        name="log_detail",
    ),
    path("list-all-complaints/", list_complaints, name="list_complaints"),
    path("level-complaints/<int:level_id>/", level_complaints, name="level_complaints"),
    path(
        "complaint-detail/<int:complaint_id>", complaint_detail, name="complaint_detail"
    ),
    path("mark-checked/<int:complaint_id>/", mark_complaint_checked, name="mark_check"),
    path("survey-list/", survey_list, name="survey_list"),
    path(
        "survey-filled-questions/<int:survey_id>/<int:level_id>/",
        survey_filled_questions,
        name="filled_ques",
    ),
    path(
        "filled-surveys/<int:survey_id>/list/", fill_surveys_list, name="fill_surveys"
    ),
    path("filled_answers/<int:q_id>/<int:level_id>/", view_filled_ans, name="view_ans"),
    path(
        "master/", views.MasterConfigurationView.as_view(), name="master_configuration"
    ),
    path("prov_create/", ProvinceNameCreateView.as_view(), name="province_create"),
    path(
        "prov_edit/<int:pk>/", ProvinceNameUpdateView.as_view(), name="province_update"
    ),
    path("local_edit/<int:pk>/", LocalNameUpdateView.as_view(), name="local_update"),
    path("depart_list/", DepartmentNameListView.as_view(), name="department_list"),
    path(
        "depart_edit/<int:pk>/",
        DepartmentNameUpdateView.as_view(),
        name="department_update",
    ),
    path("post_edit/<int:pk>/", UsersPostNameUpdateView.as_view(), name="post_update"),
    path(
        "appraisal-review-rquest/list/",
        appraisal_review_request,
        name="appraisal_review_request",
    ),
    path("level-appraisals/<int:level_id>/", level_appraisals, name="level_appraisals"),
    path(
        "appraisal-review-rquest/detail/<int:appraisal_id>/",
        appraisal_review_request_detail,
        name="appraisal_review_request_detail",
    ),
    path(
        "mark-checkedappraisal/<int:appraisal_id>/",
        mark_appraisal_checked,
        name="mark_check_appraisal",
    ),
    path("district_edit/<int:pk>/", DistrictNameUpdateView.as_view(), name="district_update"),

    path("fiscal_edit/<int:pk>/", FiscalYearUpdateView.as_view(), name="fiscal_update"),

    path("settings/", SettingsView.as_view(), name="settings"),
]
