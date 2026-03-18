from django.conf import settings
from django.core.exceptions import ValidationError
from django.db import models
from django.urls import reverse
from django.utils.translation import ugettext as _
from user_mgmt.models import AbstractInfo, Department, Level, LevelType
import os
from .get_username import current_request


class AbstractCommonInfo(models.Model):
    created_at = models.DateTimeField(_("Created at"), auto_now_add=True)
    updated_at = models.DateTimeField(_("Updated at"), auto_now=True)

    class Meta:
        abstract = True


class CentralBody(AbstractCommonInfo):
    name = models.CharField(_("Name"), unique=True, max_length=50)
    name_np = models.CharField(
        _("Nepali Name"), unique=True, max_length=50, null=True, blank=True
    )

    def __str__(self) -> str:
        return self.name


class ProvinceBody(AbstractCommonInfo):
    central = models.ForeignKey(
        CentralBody,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="province_bodies",
        verbose_name=_("Central Bod"),
    )
    name = models.CharField(_("Name"), unique=True, max_length=50)
    name_np = models.CharField(
        _("Nepali Name"), unique=True, max_length=50, null=True, blank=True
    )

    def __str__(self) -> str:
        return self.name


class LocalBody(AbstractCommonInfo):
    province = models.ForeignKey(
        ProvinceBody,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="local_bodies",
        verbose_name=_("Central Bod"),
    )
    name = models.CharField(_("Name"), unique=True, max_length=50)
    name_np = models.CharField(
        _("Nepali Name"), unique=True, max_length=50, null=True, blank=True
    )

    def __str__(self) -> str:
        return self.name


class FiscalYear(AbstractCommonInfo):
    name = models.CharField(_("Name"), max_length=50, unique=True)
    start_date = models.DateField(_("Start Date"), null=True, blank=True)
    end_date = models.DateField(_("End Date"), null=True, blank=True)
    start_date_bs = models.CharField("Start Date BS", max_length=20, null=True)
    end_date_bs = models.CharField("End Date BS", max_length=20, null=True)
    active_fy = models.BooleanField(_("Active Fiscal Year?"), default=False)

    def __str__(self) -> str:
        return self.name

    @property
    def nepali_start_date(self):
        return "Nepali Date"

    def clean_fields(self, exclude=None):
        super().clean_fields(exclude=exclude)

        # Don't allow to add end date smaller to the start date
        if (self.end_date and self.start_date) and (
            self.end_date_bs < self.start_date_bs
        ):
            raise ValidationError(
                _("Fiscal Year end date can not be smaller than start date.")
            )


class Survey(AbstractCommonInfo):
    level_choices = (
        ("C", _("Central Level")),
        ("P", _("Province Level")),
        ("L", _("Local Level")),
    )

    approval_states = (
        ("P", _("Pending")),
        ("A", _("Approved")),
        ("R", _("Rejected")),
        ("C", _("Cancelled")),
    )
    name = models.CharField(
        _("Name"), max_length=100, unique=True, null=True, blank=True
    )
    level = models.CharField(_("Level"), max_length=1, choices=level_choices)
    approval_state = models.CharField(
        _("Approval State"), max_length=1, choices=approval_states, default="P"
    )
    fiscal_year = models.ForeignKey(
        FiscalYear,
        on_delete=models.CASCADE,
        related_name="surveys",
        verbose_name=_("Fiscal Year"),
    )

    is_active = models.BooleanField(_("Active"), default=True)

    def __str__(self) -> str:
        return self.name
    
    @property
    def total_full_marks(self):
        """Sum of full_marks across all top-level questions in this survey."""
        from django.db.models import Sum
        total = self.questions.filter(
            parent__isnull=True
        ).aggregate(total=Sum('full_marks'))['total']
        return total or 0
 
    def to_json(self):
        file_name = ""
        file_url = ""
        if self.complaint_file and self.complaint_file.name:
            file_name = self.complaint_file.name
            try:
                file_url = self.complaint_file.url
            except ValueError:
                file_url = ""
        return {
            "id": self.id,
            "sub": self.sub,
            "msg": self.msg,
            "is_checked": self.is_checked,
            "file_name": file_name,
            "level": self.level.name if self.level else "",
            "file_url": file_url,
        }
 
 
    def to_json(self):
        file_name = ""
        file_url = ""
        if self.file_upload and self.file_upload.name:
            file_name = self.file_upload.name
            try:
                file_url = self.file_upload.url
            except ValueError:
                file_url = ""
        return {
            "id": self.id,
            "sub": self.subject,
            "msg": self.reason,
            "is_checked": self.is_checked,
            "question_title": self.question_id.title if self.question_id else "",
            "file_name": file_name,
            "level": self.level.name if self.level else "",
            "file_url": file_url,
        }


class Question(AbstractCommonInfo):
    survey = models.ForeignKey(
        Survey,
        on_delete=models.CASCADE,
        related_name="questions",
        verbose_name=_("Survey"),
    )
    title = models.CharField(
        _("Title"),
        max_length=500,
    )
    parent = models.ForeignKey(
        "self",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="children_questions",
        verbose_name=_("Parent Question"),
    )
    is_document_required = models.BooleanField(
        _("Is Document Required"),
        default=False,
        help_text=_(
            "Designates whether the option answer required document file or not."
        ),
    )
    month_requires = models.BooleanField(_("Month Requires"), default=False)
    sequence_id = models.PositiveIntegerField(
        verbose_name=_("Sequence id"), null=True, blank=False
    )
    is_options_created = models.BooleanField(default=True)
    department = models.ForeignKey(
        Department, on_delete=models.SET_NULL, null=True, blank=True
    )
    full_marks = models.PositiveIntegerField(null=True, blank=True, verbose_name=_("Full Marks"))


    def __str__(self) -> str:
        return self.title

    @property
    def has_child(self):
        """
        checks if the question has child questions
        """
        has_child_questions = False
        child_questions = Question.objects.filter(parent=self.id)
        if len(child_questions) > 0:
            has_child_questions = True
        return has_child_questions

    @property
    def is_question_filled(self):
        """
        to see if the question has already been filled by the current user
        """
        survey_id = self.survey.id
        current_user = current_request().user
        is_filled = False
        try:
            fill_survey = FillSurvey.objects.get(
                survey_id=survey_id, level_id=current_user.level
            )
            # wip, to check if the child question for a question has already been filled by the user
            if self.has_child:
                child_questions = Question.objects.filter(parent=self.id)
                child_questions_id = [
                    child_question.id for child_question in child_questions
                ]
                options = Option.objects.filter(question__id__in=child_questions_id)
            else:
                options = self.options.all()
            for option in options:
                answers = option.answers.filter(fill_survey=fill_survey.id)
                if len(answers) > 0:
                    if answers[0].value:
                        is_filled = True
        except FillSurvey.DoesNotExist:
            fill_survey = None
        return is_filled

    @property
    def has_calculations(self):
        return self.options.filter(option_type__isnull=False).exists()

    class Meta:
        ordering = ["-created_at"]


class Option(AbstractCommonInfo):
    sequence_id = models.PositiveIntegerField(
        verbose_name=_("Sequence id"), null=True, blank=False
    )
    field_type_choices = (
        ("C", _("Character")),
        ("B", _("Checkbox")),
        ("D", _("Date")),
        ("De", _("Amount")),
        ("F", _("File")),
        ("P", _("Percentage Field")),
        ("FY", _("Fiscal Year")),
    )
    option_type_choices = (
        ("Num", _("Numerator")),
        ("Deno", _("Denominator")),
        ("Per", _("Percentage")),
    )
    option_type = models.CharField(
        _("Option Type"),
        choices=option_type_choices,
        max_length=5,
        null=True,
        blank=True,
    )
    question = models.ForeignKey(
        Question,
        on_delete=models.CASCADE,
        related_name="options",
        verbose_name=_("Question"),
    )

    title = models.CharField(_("Title"), max_length=500)
    field_type = models.CharField(
        _("Field Type"), choices=field_type_choices, max_length=2
    )
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        related_name="options_created",
        verbose_name=_("Created By"),
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    is_calc_field = models.BooleanField(
        _("Is Calculation Field"),
        default=False,
        help_text=_("Designates whether the option is used for calculation or not."),
    )

    def __str__(self) -> str:
        return self.title


month_choices = (
    (1, _("वैशाख")),
    (2, _("ज्येष्ठ")),
    (3, _("असार")),
    (4, _("श्रावण")),
    (5, _("भदौ")),
    (6, _("असोज")),
    (7, _("कार्तिक")),
    (8, _("मंसिर")),
    (9, _("पौष")),
    (10, _("माघ")),
    (11, _("फागुन")),
    (12, _("चैत्र")),
)


class Answer(AbstractCommonInfo):
    option = models.ForeignKey(
        Option,
        on_delete=models.CASCADE,
        related_name="answers",
        verbose_name=_("Option"),
    )
    fill_survey = models.ForeignKey(
        "FillSurvey",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name=_("Fill Survey"),
    )
    month = models.IntegerField(
        _("Month"), null=True, blank=True, choices=month_choices
    )
    value = models.CharField(_("Value"), max_length=150)
    fiscal_year = models.ForeignKey(
        "FiscalYear",
        on_delete=models.PROTECT,
        related_name="answers",
        null=True,
        blank=True,
    )
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        related_name="answer",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    created_by_level = models.ForeignKey(
        Level,
        on_delete=models.PROTECT,
        null=True,
        blank=False,
        related_name="level_answer",
    )

    def __str__(self) -> str:
        question_id = self.option.question.id
        return f"{question_id} {self.option_id} {self.option.title} {self.value}"
        # return str(question_id) + " " + str(self.option.id)


class AnswerDocument(AbstractCommonInfo):
    answer = models.ForeignKey(
        Answer,
        on_delete=models.CASCADE,
        related_name="documents",
        verbose_name=_("Answer"),
    )
    document = models.FileField(
        _("Document"),
        upload_to="answer-documents/",
    )

    def __str__(self) -> str:
        return str(self.document)

    def get_document_name(self):
        return os.path.basename(self.document.name)


class FillSurvey(AbstractCommonInfo):
    survey = models.ForeignKey(
        Survey, on_delete=models.CASCADE, related_name="fill_surveys"
    )

    budget_period = models.CharField(
        _("Budget Period"), max_length=10, blank=True, null=True
    )
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        related_name="fill_surveys_created",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    approval_state = models.CharField(
        _("Approval State"), max_length=20, blank=True, null=True
    )
    level_id = models.ForeignKey(
        Level,
        on_delete=models.PROTECT,
        null=True,
        blank=False,
        related_name="level_fill_survey",
    )

    def __str__(self) -> str:
        return f"{self.survey}, {self.level_id}"

    def get_correction_requests(self):
        survey_questions = self.survey.questions.all()
        return SurveyCorrection.objects.filter(
            level=self.level_id, question__in=survey_questions
        ).count()


class SurveyCorrection(AbstractInfo):
    question = models.ForeignKey(
        Question, on_delete=models.CASCADE, related_name="corrections"
    )
    sub = models.CharField(max_length=255)
    msg = models.TextField()
    document = models.FileField(upload_to="correction-files/", blank=True, null=True)

    status_choices = (("P", "Pending"), ("C", "Checked"))
    status = models.CharField(max_length=1, default="P", choices=status_choices)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="correction_requests",
    )
    level = models.ForeignKey(Level, on_delete=models.CASCADE, blank=True, null=True)
    month = models.PositiveSmallIntegerField(
        null=True, blank=True, choices=month_choices
    )
    remarks = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.sub

    @property
    def get_level_correction_pending(self):
        return SurveyCorrection.objects.filter(level=self.level, status="P").count()

    @property
    def get_level_correction_checked(self):
        return SurveyCorrection.objects.filter(level=self.level, status="C").count()


class CorrectionActivityLog(AbstractInfo):
    question_id = models.PositiveBigIntegerField(null=True, blank=True)
    question_title = models.CharField(max_length=500, blank=True, null=True)
    user_name = models.CharField(max_length=255)
    user_email = models.EmailField()
    user_level = models.CharField(max_length=100, null=True)
    level_type_choices = (("L", "Local Level"), ("P", "Province Level"))
    action_level = models.CharField(max_length=100, null=True)
    action_level_type = models.CharField(
        max_length=1, null=True, choices=level_type_choices
    )
    option = models.CharField(max_length=255, blank=True, null=True)
    option_id = models.PositiveBigIntegerField(blank=True, null=True)
    old_value = models.CharField(max_length=255, blank=True, null=True)
    changed_value = models.CharField(max_length=255, blank=True, null=True)
    activity = models.CharField(max_length=500)

    def __str__(self):
        return f"{self.user_email}: {self.activity}"

    class Meta:
        ordering = ["-created_at"]

    @property
    def total_logs_by_level(self):
        return CorrectionActivityLog.objects.filter(
            action_level=self.action_level
        ).count()


class Complaint(AbstractInfo):
    sub = models.CharField(max_length=50)
    msg = models.TextField()
    is_checked = models.BooleanField(default=False)
    level = models.ForeignKey(
        Level, on_delete=models.CASCADE, related_name="complaints"
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True
    )
    complaint_file = models.FileField(
        upload_to="complaint-files/",
        blank=True,
        null=True,
    )

    def __str__(self):
        return self.sub

    def total_complaints_by_level(self):
        return Complaint.objects.filter(level=self.level).count()

    def total_active_complaints(self):
        return Complaint.objects.filter(level=self.level, is_checked=False).count()

    def to_json(self):
        return {
            "id": self.id,
            "sub": self.sub,
            "msg": self.msg,
            "is_checked": self.is_checked,
            "file_name": self.complaint_file.name,
            "level": self.level.name,
            "file_url": self.complaint_file.url,
        }


class AppraisalReviewRequest(AbstractInfo):
    question_id = models.ForeignKey(
        Question,
        on_delete=models.SET_NULL,
        null=True,
        blank=False,
    )
    subject = models.CharField(null=True, blank=False, max_length=200)
    score_obtained = models.FloatField(null=True, blank=False)
    reason = models.TextField(null=True, blank=False)
    expected_score = models.FloatField(null=True, blank=False)
    file_upload = models.FileField(
        upload_to="appraisal_review_request/",
        blank=True,
        null=True,
    )
    is_checked = models.BooleanField(default=False)
    level = models.ForeignKey(
        Level,
        on_delete=models.CASCADE,
        related_name="appraisal_review",
        null=True,
        blank=True,
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )

    def __str__(self) -> str:
        return self.subject

    def to_json(self):
        return {
            "id": self.id,
            "sub": self.subject,
            "msg": self.reason,
            "is_checked": self.is_checked,
            "question_title": self.question_id.title,
            "file_name": self.file_upload.name,
            "level": self.level.name,
            "file_url": self.file_upload.url,
        }


class Notification(AbstractInfo):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True
    )
    msg = models.CharField(max_length=255)
    correction = models.ForeignKey(
        SurveyCorrection, on_delete=models.CASCADE, null=True, blank=True
    )
    correction_checked = models.BooleanField(default=False)
    question = models.ForeignKey(
        Question, on_delete=models.CASCADE, blank=True, null=True
    )
    is_viewed = models.BooleanField(default=False)
    level = models.ForeignKey(Level, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return self.msg

    def get_detail_url(self):

        if self.correction:
            if self.correction_checked:
                url = reverse(
                    "core:filled_question", args=(self.correction.question_id,)
                )
            else:
                url = reverse(
                    "dashboard:correction_fix",
                    args=(self.correction_id, self.correction.question_id),
                )
        elif self.question:
            url = reverse("core:filled_question", args=(self.question_id,))
        else:
            url = "/"
        return url

    class Meta:
        ordering = ["-created_at"]


class CorrectionDocument(AbstractInfo):
    correction = models.ForeignKey(
        SurveyCorrection, on_delete=models.CASCADE, related_name="documents"
    )
    document = models.FileField(upload_to="correction-files/")

    def __str__(self):
        return f"{self.correction.sub} — {self.document.name}"

    def get_document_name(self):
        import os
        return os.path.basename(self.document.name)