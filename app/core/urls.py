from django.urls import path
from core.dashboard.views import update_notification_status

from core.views import (
    IndexView,
    QuestionaireDetailView,
    AnswerCreateView,
    AnswerDetailView,
    SurveyList,
    submit_answer,
    register_SimpleComplaint,
    send_for_correction,
    check_level_month_data,
    register_EvaluationComplaint,
    get_correction_data,
    add_correction_file,
)

from user_mgmt.accounts.views import LoginUserView
from django.conf import settings
from django.conf.urls.static import static
from .views import PdfGenerateView

app_name = "core"
urlpatterns = [
    # path("", LoginUserView.as_view(), name="login"),
    path("", SurveyList, name="survey_list"),
    # path("survey/", SurveyList, name="survey_list"),
    path("survey/<int:pk>/", IndexView.as_view(), name="homepage"),
    path(
        "question/<int:pk>/",
        AnswerCreateView.as_view(),
        name="create_answer",
    ),
    path(
        "filled_question/<int:pk>/",
        AnswerDetailView.as_view(),
        name="filled_question",
    ),
    path(
        "filled_question/<int:pk>/<int:month>",
        AnswerDetailView.as_view(),
        name="filled_question_month",
    ),
    path(
        "ajax/submit_answer",
        submit_answer,
        name="submit_answer",
    ),
    path("ajax/submit_for_correction", send_for_correction, name="send_for_correction"),
    path(
        "ajax/check_level_month_data",
        check_level_month_data,
        name="check_level_month_data",
    ),
    path("update-notif/", update_notification_status, name="notif_update"),
    path("survey/complaint/simpleform/", register_SimpleComplaint, name="register_SimpleComplaintForm"),
    
    path("survey/complaint/evaluationform/", register_EvaluationComplaint, name="register_EvaluationComplaintForm"),
    path("pdf-generate/<int:pk>/", PdfGenerateView.as_view(), name="pdf_generate"),

    path("ajax/get_correction_data", get_correction_data, name="get_correction_data"),
    path("ajax/add_correction_file", add_correction_file, name="add_correction_file"),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
