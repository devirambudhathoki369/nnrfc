from django.contrib import admin

from core.models import (
    CentralBody,
    Complaint,
    AppraisalReviewRequest,
    Notification,
    ProvinceBody,
    LocalBody,
    FiscalYear,
    Survey,
    Question,
    Option,
    Answer,
    AnswerDocument,
    FillSurvey,
    SurveyCorrection,
    CorrectionActivityLog,
)


admin.site.register(
    [
        CentralBody,
        ProvinceBody,
        LocalBody,
        FiscalYear,
        Survey,
        Question,
        Answer,
        Option,
        AnswerDocument,
        FillSurvey,
        SurveyCorrection,
        Complaint,
        AppraisalReviewRequest,
        Notification
    ]
)


class CorrectionActivityLogAdmin(admin.ModelAdmin):
    def has_change_permission(self, request, obj=None):
        return False

    def has_add_permission(self, request):
        return False


admin.site.register(CorrectionActivityLog, CorrectionActivityLogAdmin)
