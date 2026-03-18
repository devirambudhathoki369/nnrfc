import json
import logging

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import transaction
from django.http import JsonResponse, HttpResponse
from django.shortcuts import get_object_or_404, render, redirect
from django.template.loader import get_template
from django.views.decorators.csrf import csrf_exempt
from django.views.generic import CreateView, ListView, TemplateView, View
from weasyprint import HTML

from core.dashboard.validators import validate_file
from core.models import (
    Answer,
    AnswerDocument,
    AppraisalReviewRequest,
    Complaint,
    FillSurvey,
    FiscalYear,
    Notification,
    Option,
    Question,
    Survey,
    SurveyCorrection,
)
from core.utils import (
    get_file_option_field,
    OPTION_FIELD_INPUT_TYPE,
    OPTION_FIELD_INDICATOR,
)
from user_mgmt.utils import get_index_by_department

logger = logging.getLogger(__name__)

# ─── Maximum upload size (5 MB) ──────────────────────────────────────────────
MAX_UPLOAD_SIZE = 5 * 1024 * 1024  # 5,242,880 bytes


# ─────────────────────────────────────────────────────────────────────────────
# Helper functions
# ─────────────────────────────────────────────────────────────────────────────

def check_answered_month_id(question, fill_survey_id):
    """Return the month id of an already-answered question, or None."""
    options = question.options.all()
    if options.exists():
        answers = Answer.objects.filter(
            option=options[0].id, fill_survey=fill_survey_id
        )
        if answers.exists():
            return answers[0].month
    return None


def get_numerator_denominator_value(question_id, option_type, fill_survey_id, month_id=None):
    """Get the numerator or denominator value for percentage calculation."""
    try:
        options = Option.objects.filter(question=question_id, option_type=option_type)
        if not options.exists():
            return 0
        answer = Answer.objects.filter(
            option=options[0].id, fill_survey=fill_survey_id, month=month_id
        )
        if not answer.exists():
            return 0
        return float(answer[0].value)
    except (ValueError, IndexError, TypeError):
        return 0


def calculate_percentage(numerator, denominator):
    """Calculate percentage with exactly 2 decimal places."""
    try:
        if denominator and denominator != 0:
            result = (numerator / denominator) * 100
            return "{:.2f}".format(result)
        return "0.00"
    except (ValueError, TypeError, ZeroDivisionError):
        return "0.00"


def _validate_uploaded_file(file_data):
    """
    Validate file extension and size.
    Returns (is_valid, error_response_or_None).
    """
    if not validate_file(file_data.name):
        return False, JsonResponse({
            "success": False,
            "message": "यो फाइल प्रकार अनुमति छैन। (Invalid file extension)",
            "not_valid_ext": True,
        })
    if file_data.size > MAX_UPLOAD_SIZE:
        return False, JsonResponse({
            "success": False,
            "message": "फाइल साइज ५ MB भन्दा बढी हुनु हुँदैन। (Max 5 MB)",
            "not_valid_ext": True,
        })
    return True, None


# ─────────────────────────────────────────────────────────────────────────────
# Survey List — Landing page for province / local users
# ─────────────────────────────────────────────────────────────────────────────

@login_required
def SurveyList(request):
    """
    Shows survey cards for the logged-in user.
    - Users with roles → redirected to dashboard
    - Superusers → redirected to dashboard
    - Province users WITH a department → only see surveys that have
      at least one question assigned to their department
    - Local level users → see all surveys for their level
    """
    user = request.user

    # Users with roles or superusers go straight to dashboard
    if user.roles.exists() or user.is_superuser:
        return redirect('dashboard:dashboard')

    try:
        user_level_type = user.level.type.type  # "P" or "L"
        survey_list = Survey.objects.filter(level=user_level_type)

        # Province users with a department: filter surveys by department
        if user.department and user_level_type == "P":
            survey_ids = Question.objects.filter(
                department=user.department,
                survey__level=user_level_type,
                parent__isnull=True,
            ).values_list('survey_id', flat=True).distinct()
            survey_list = survey_list.filter(id__in=survey_ids)

    except AttributeError:
        survey_list = Survey.objects.all()

    context = {
        "survey_list": survey_list,
        "questions": Question.objects.all(),
    }
    return render(request, "core/survey.html", context)


# ─────────────────────────────────────────────────────────────────────────────
# Index View — Shows list of questions/indicators inside a survey
# ─────────────────────────────────────────────────────────────────────────────

class IndexView(LoginRequiredMixin, ListView):
    model = Question
    template_name = "core/index.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        survey_id = self.kwargs.get("pk")
        survey = Survey.objects.get(id=survey_id)
        context["questionaire"] = get_index_by_department(survey, self.request.user)
        context["survey"] = survey
        return context


# ─────────────────────────────────────────────────────────────────────────────
# Question Detail View (unused but kept for compatibility)
# ─────────────────────────────────────────────────────────────────────────────

class QuestionaireDetailView(LoginRequiredMixin, TemplateView):
    model = Question
    template_name = "core/indicator.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        context["parent"] = Question.objects.get(pk=question_id)
        context["children"] = Question.objects.filter(parent__id=question_id)
        context["title"] = Question.objects.all()
        return context


# ─────────────────────────────────────────────────────────────────────────────
# Answer Create View — Form to fill an indicator
# ─────────────────────────────────────────────────────────────────────────────

class AnswerCreateView(LoginRequiredMixin, CreateView):
    model = Answer
    template_name = "core/indicator.html"
    fields = ["month", "value"]

    def _build_options_data(self, options):
        """Build the options data list for template context."""
        options_data = []
        for option in options:
            if option.field_type == "FY":
                fiscal_years = FiscalYear.objects.all()
                option_data = {
                    "id": option.id,
                    "title": option.title,
                    "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                    "option_type": option.option_type,
                    "fy_data": [{"id": fy.id, "name": fy.name} for fy in fiscal_years],
                }
            else:
                option_data = {
                    "id": option.id,
                    "title": option.title,
                    "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                    "field_indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
                    "option_type": option.option_type,
                }
            options_data.append(option_data)
        return options_data

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id

        child_questions = Question.objects.filter(parent=question_id).order_by("sequence_id")
        has_months = question_obj.month_requires

        context["has_months"] = has_months
        context["has_child"] = False
        context["question_id"] = question_id
        context["question_title"] = question_obj.title
        context["survey_id"] = survey_id

        # Build child question options
        child_options = []
        if child_questions.exists():
            context["has_child"] = True
            for child_question in child_questions:
                options = (
                    Option.objects.filter(question=child_question)
                    .exclude(field_type="F")
                    .order_by("sequence_id")
                )
                child_options.append({
                    "child_question": child_question,
                    "options": self._build_options_data(options),
                })

        context["child_questions"] = child_questions
        context["child_options"] = child_options

        # Build parent question options
        options = (
            Option.objects.filter(question=question_id)
            .exclude(field_type="F")
            .order_by("sequence_id")
        )
        context["options"] = self._build_options_data(options)

        return context

    def post(self, request, **kwargs):
        question_id = self.kwargs.get("pk")
        return redirect("core:filled_question", pk=question_id)


# ─────────────────────────────────────────────────────────────────────────────
# Answer Detail View — Shows filled answers for an indicator
# ─────────────────────────────────────────────────────────────────────────────

class AnswerDetailView(LoginRequiredMixin, TemplateView):
    template_name = "core/indicator_detail.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        month_id = self.kwargs.get("month", None)
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id
        current_user = self.request.user

        context["question_obj"] = question_obj
        context["question_id"] = question_obj.id
        context["survey_id"] = survey_id
        context["has_months"] = question_obj.month_requires
        context["month_id"] = month_id
        context["has_child"] = False

        # Get fill survey for current user's level
        try:
            fill_survey_id = FillSurvey.objects.filter(
                survey=survey_id, level_id=current_user.level
            ).first()
        except (IndexError, FillSurvey.DoesNotExist):
            fill_survey_id = None

        if not fill_survey_id:
            context["option_answer_pairs"] = []
            context["files"] = []
            return context

        child_questions = Question.objects.filter(parent=question_id).order_by("sequence_id")

        if child_questions.exists():
            context["has_child"] = True
            question_option_value = []
            files = []

            for child_question in child_questions:
                options = (
                    Option.objects.filter(question=child_question)
                    .exclude(field_type="F")
                    .order_by("sequence_id")
                )
                file_option = Option.objects.filter(
                    question=child_question.id, field_type="F"
                )
                question_option = {"question": child_question}
                option_answer_pair = []

                for option in options:
                    if option.option_type == "Per":
                        numerator = get_numerator_denominator_value(
                            child_question.id, "Num", fill_survey_id, month_id
                        )
                        denominator = get_numerator_denominator_value(
                            child_question.id, "Deno", fill_survey_id, month_id
                        )
                        answer = calculate_percentage(numerator, denominator)
                    else:
                        try:
                            if month_id:
                                answer = Answer.objects.filter(
                                    option=option.id,
                                    fill_survey=fill_survey_id,
                                    month=month_id,
                                ).first()
                            else:
                                answer = Answer.objects.filter(
                                    option=option.id, fill_survey=fill_survey_id
                                ).first()
                            answer = answer.value if answer else ""
                        except (IndexError, Answer.DoesNotExist, AttributeError):
                            answer = ""

                    option_answer_pair.append({
                        "title": option.title,
                        "answer": answer,
                        "indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
                    })

                question_option["option_answer"] = option_answer_pair

                # Get attached files
                child_files = []
                if file_option.exists():
                    file_optn = file_option[0]
                    try:
                        if month_id:
                            answer_obj = Answer.objects.filter(
                                option=file_optn.id,
                                fill_survey=fill_survey_id,
                                month=month_id,
                            ).first()
                        else:
                            answer_obj = Answer.objects.filter(
                                option=file_optn.id, fill_survey=fill_survey_id
                            ).first()
                        if answer_obj:
                            child_files = AnswerDocument.objects.filter(answer=answer_obj.id)
                    except Exception as e:
                        logger.error(f"Error fetching files for child question: {e}")

                question_option["files"] = child_files
                question_option_value.append(question_option)

            context["files"] = files
            context["question_option_value"] = question_option_value
            context["child_questions"] = child_questions

        else:
            # No child questions — show parent's options directly
            option_answer = []
            options = (
                Option.objects.filter(question=question_id)
                .exclude(field_type="F")
                .order_by("sequence_id")
            )
            file_option = Option.objects.filter(question=question_id, field_type="F")
            files = []

            for option in options:
                if option.option_type == "Per":
                    numerator = get_numerator_denominator_value(
                        question_id, "Num", fill_survey_id, month_id
                    )
                    denominator = get_numerator_denominator_value(
                        question_id, "Deno", fill_survey_id, month_id
                    )
                    answer = calculate_percentage(numerator, denominator)
                else:
                    try:
                        if month_id:
                            answer_obj = Answer.objects.filter(
                                option=option.id,
                                fill_survey=fill_survey_id,
                                month=month_id,
                            ).first()
                        else:
                            answer_obj = Answer.objects.filter(
                                option=option.id, fill_survey=fill_survey_id
                            ).first()

                        if answer_obj:
                            fy_answer = answer_obj.fiscal_year
                            answer = fy_answer.name if fy_answer else answer_obj.value
                        else:
                            answer = ""
                    except (IndexError, Answer.DoesNotExist, AttributeError):
                        answer = ""

                option_answer.append({
                    "option_title": option.title,
                    "answer_value": answer,
                    "indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
                })

            # Get attached files
            if file_option.exists():
                file_optn = file_option[0]
                try:
                    if month_id:
                        answer_obj = Answer.objects.filter(
                            option=file_optn.id,
                            fill_survey=fill_survey_id,
                            month=month_id,
                        ).first()
                    else:
                        answer_obj = Answer.objects.filter(
                            option=file_optn.id, fill_survey=fill_survey_id
                        ).first()
                    if answer_obj:
                        doc_files = AnswerDocument.objects.filter(answer=answer_obj.id)
                        files = [f.document for f in doc_files]
                except Exception as e:
                    logger.error(f"Error fetching uploaded files: {e}")

            context["files"] = files
            context["option_answer_pairs"] = option_answer

        return context


# ─────────────────────────────────────────────────────────────────────────────
# Submit Answer (AJAX POST)
# FIX: Gracefully handle missing file Option, proper 5MB check, proper errors
# ─────────────────────────────────────────────────────────────────────────────

@csrf_exempt
@transaction.atomic
def submit_answer(request):
    if request.method != "POST":
        return JsonResponse(
            {"success": False, "message": "Invalid request method."}, status=405
        )

    try:
        submitted_answers = request.POST.get("answers", "[]")
        question_id = request.POST.get("question_id")
        fy_answers_raw = request.POST.get("fy_answers", "[]")
        month_value = request.POST.get("month_value", "")

        if not month_value or month_value in ("", "null", "undefined"):
            month_value = None

        fy_answers = json.loads(fy_answers_raw)
        question_obj = Question.objects.get(id=question_id)
        file_required = question_obj.is_document_required
        files = request.FILES
        current_user = request.user

        # ── Validate: file required but not uploaded ─────────────────────
        if file_required and len(files) <= 0:
            return JsonResponse({
                "success": False,
                "message": "कृपया फाइल अपलोड गर्नुहोस्। (Please add file before submission)",
                "file_required_validation": True,
            })

        survey = question_obj.survey
        answers = json.loads(submitted_answers)

        # ── Validate: answer data ────────────────────────────────────────
        for answer in answers:
            if answer.get("is_valid") is False:
                return JsonResponse({
                    "success": False,
                    "message": "अमान्य डाटा। कृपया जाँच गर्नुहोस्। (Invalid data)",
                    "invalid_data": True,
                })

        # ── Get or create FillSurvey ─────────────────────────────────────
        try:
            fill_survey = FillSurvey.objects.get(
                survey=survey, level_id=current_user.level
            )
        except FillSurvey.DoesNotExist:
            fill_survey = FillSurvey.objects.create(
                survey=survey, level_id=current_user.level
            )

        # ── Process file uploads ─────────────────────────────────────────
        if files:
            for file_key in files:
                try:
                    question_id_from_file = int(file_key.replace("f", ""))
                    file_data = files[file_key]

                    # Validate extension and size
                    is_valid, error_resp = _validate_uploaded_file(file_data)
                    if not is_valid:
                        return error_resp

                    # Find the File-type option for this question
                    try:
                        option_field_file = get_file_option_field(question_id_from_file)
                    except (IndexError, Option.DoesNotExist, Exception):
                        # No file Option exists for this question — skip gracefully
                        logger.warning(
                            f"No file field (Option field_type='F') for question "
                            f"{question_id_from_file}. Skipping file upload."
                        )
                        continue

                    answer_file = Answer.objects.create(
                        fill_survey=fill_survey,
                        option=option_field_file,
                        value=file_data.name,
                        month=month_value,
                        created_by=current_user,
                        created_by_level=current_user.level,
                    )
                    AnswerDocument.objects.create(
                        answer=answer_file, document=file_data
                    )

                except ValueError as e:
                    logger.error(f"File key parsing error for '{file_key}': {e}")
                    continue

        # ── Save regular answers ─────────────────────────────────────────
        for answer in answers:
            try:
                option_obj = Option.objects.get(id=answer["option_id"])
                Answer.objects.create(
                    fill_survey=fill_survey,
                    option=option_obj,
                    value=answer["value"],
                    created_by=current_user,
                    created_by_level=current_user.level,
                    month=month_value,
                )
            except Option.DoesNotExist:
                logger.error(f"Option not found: {answer.get('option_id')}")
                return JsonResponse({
                    "success": False,
                    "message": f"Option ID {answer.get('option_id')} फेला परेन।",
                    "invalid_data": True,
                })

        # ── Save fiscal year answers ─────────────────────────────────────
        if fy_answers:
            for fy_ans in fy_answers:
                try:
                    option_obj = Option.objects.get(id=fy_ans["option_id"])
                    fiscal_year_obj = FiscalYear.objects.get(id=fy_ans["value"])
                    Answer.objects.create(
                        fill_survey=fill_survey,
                        option=option_obj,
                        fiscal_year=fiscal_year_obj,
                        created_by=current_user,
                        created_by_level=current_user.level,
                        month=month_value,
                    )
                except (Option.DoesNotExist, FiscalYear.DoesNotExist) as e:
                    logger.error(f"FY answer error: {e}")

        return JsonResponse({"success": True})

    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error in submit_answer: {e}")
        return JsonResponse({
            "success": False,
            "message": "अमान्य डाटा ढाँचा। (Invalid data format)",
            "invalid_data": True,
        }, status=400)
    except Exception as e:
        logger.error(f"Unexpected error in submit_answer: {e}", exc_info=True)
        return JsonResponse({
            "success": False,
            "message": "सर्भर त्रुटि। कृपया पुन: प्रयास गर्नुहोस्। (Server error)",
            "invalid_data": True,
        }, status=500)


# ─────────────────────────────────────────────────────────────────────────────
# Check Level Month Data (AJAX POST)
# Checks both parent and child question options
# ─────────────────────────────────────────────────────────────────────────────

@csrf_exempt
def check_level_month_data(request):
    if request.method != "POST":
        return JsonResponse({"success": False}, status=405)

    question_id = request.POST.get("question_id")
    month_value = request.POST.get("month_value")
    current_user = request.user
    data = {"success": True, "has_month_value": False}

    try:
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id

        fill_survey = FillSurvey.objects.filter(
            survey_id=survey_id, level_id=current_user.level
        ).first()

        if not fill_survey:
            return JsonResponse(data)

        # Check child questions if they exist, otherwise check parent's options
        child_questions = Question.objects.filter(parent=question_id)

        questions_to_check = child_questions if child_questions.exists() else [question_obj]

        for q in questions_to_check:
            for option in q.options.all():
                answers = option.answers.filter(
                    fill_survey=fill_survey.id, month=month_value
                )
                if answers.exists() and answers[0].value:
                    data["has_month_value"] = True
                    return JsonResponse(data)

    except (Question.DoesNotExist, AttributeError, IndexError) as e:
        logger.error(f"Error checking month data: {e}")

    return JsonResponse(data)


# ─────────────────────────────────────────────────────────────────────────────
# Send for Correction (AJAX POST)
# FIX: Proper error messages instead of generic "5MB" for all failures
# ─────────────────────────────────────────────────────────────────────────────

@csrf_exempt
@login_required
def send_for_correction(request):
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method."}, status=405)
 
    subject = request.POST.get("subject", "").strip()
    message = request.POST.get("message", "").strip()
    month = request.POST.get("month_id", "")
    question_id = request.POST.get("question_id", "")
 
    # ── Validate required fields ─────────────────────────────────────
    if not subject:
        return JsonResponse({
            "success": False,
            "message": "कृपया विषय लेख्नुहोस्।",
        })
    if not message:
        return JsonResponse({
            "success": False,
            "message": "कृपया सुधार विवरण लेख्नुहोस्।",
        })
    if not question_id:
        return JsonResponse({
            "success": False,
            "message": "प्रश्न ID फेला परेन। कृपया पेज रिफ्रेस गर्नुहोस्।",
        })
 
    # ── Parse month ──────────────────────────────────────────────────
    try:
        month = int(month) if month else None
    except (ValueError, TypeError):
        month = None
 
    current_user = request.user
    user_level = current_user.level
 
    # ── Validate file if uploaded ────────────────────────────────────
    document = request.FILES.get("filename")
    if document:
        if document.size > MAX_UPLOAD_SIZE:
            return JsonResponse({
                "success": False,
                "message": "फाइल साइज ५ MB भन्दा बढी हुनु हुँदैन। (Max 5 MB)",
            })
        if not validate_file(document.name):
            return JsonResponse({
                "success": False,
                "message": "यो फाइल प्रकार अनुमति छैन।",
            })
 
    # ── Get question object ──────────────────────────────────────────
    try:
        question_obj = Question.objects.get(pk=question_id)
    except (Question.DoesNotExist, ValueError):
        return JsonResponse({
            "success": False,
            "message": f"प्रश्न ID {question_id} फेला परेन।",
        })
 
    # ── Create correction request ────────────────────────────────────
    try:
        SurveyCorrection.objects.create(
            sub=subject,
            msg=message,
            question=question_obj,
            document=document,
            user=current_user,
            level=user_level,
            month=month,
        )
 
        # ── Send EXACTLY ONE notification to admin ───────────────────
        # get_or_create ensures no duplicate notifications
        Notification.objects.get_or_create(
            question=question_obj,
            level=user_level,
            correction_checked=False,
            defaults={
                "user": current_user,
                "msg": f"{user_level.name} बाट सुधार अनुरोध प्राप्त भयो।",
                "is_viewed": False,
            },
        )
 
        return JsonResponse({
            "success": True,
            "message": "संशोधन अनुरोध सफलतापूर्वक पठाइयो।",
        })
 
    except Exception as e:
        logger.error(f"Correction creation error: {e}", exc_info=True)
        # Return 200 with success=False so AJAX success callback handles it
        # (not error callback which can't parse the message properly)
        return JsonResponse({
            "success": False,
            "message": "संशोधन अनुरोध पठाउन सकिएन। कृपया पुन: प्रयास गर्नुहोस्। Error: " + str(e),
        })
 

# ─────────────────────────────────────────────────────────────────────────────
# Register Simple Complaint (गुनासो)
# ─────────────────────────────────────────────────────────────────────────────

@login_required
def register_SimpleComplaint(request):
    if request.method == "POST":
        sub = request.POST.get("sub", None)
        msg = request.POST.get("msg", None)

        complaint_file = request.FILES.get("document", None)
        if complaint_file:
            is_valid, error_resp = _validate_uploaded_file(complaint_file)
            if not is_valid:
                return JsonResponse({
                    "message": "यो फाइल प्रकार अनुमति छैन। (Invalid file type)",
                    "invalid_file": True,
                })

        complaint = Complaint(
            sub=sub,
            msg=msg,
            level=request.user.level,
            user=request.user,
            complaint_file=complaint_file,
        )
        complaint.save()
        messages.success(request, "तपाईंको गुनासो सफलतापूर्वक दर्ता भयो।")

    return JsonResponse({"success": True})


# ─────────────────────────────────────────────────────────────────────────────
# Register Evaluation Complaint (मूल्याङ्कन पुनरावलोकन)
# ─────────────────────────────────────────────────────────────────────────────

@login_required
def register_EvaluationComplaint(request):
    if request.method == "POST":
        questions = request.POST.get("questions", None)
        question_obj = Question.objects.get(pk=questions)
        subject = request.POST.get("subject", None)
        score_obtained = request.POST.get("score_obtained", None)
        reason = request.POST.get("reason", None)
        expected_score = request.POST.get("expected_score", None)

        file_upload = request.FILES.get("document", None)
        if file_upload:
            is_valid, error_resp = _validate_uploaded_file(file_upload)
            if not is_valid:
                return JsonResponse({
                    "message": "यो फाइल प्रकार अनुमति छैन। (Invalid file type)",
                    "invalid_file": True,
                })

        complaint = AppraisalReviewRequest(
            question_id=question_obj,
            subject=subject,
            score_obtained=score_obtained,
            reason=reason,
            expected_score=expected_score,
            level=request.user.level,
            user=request.user,
            file_upload=file_upload,
        )
        complaint.save()
        messages.success(request, "तपाईंको मूल्याङ्कन गुनासो सफलतापूर्वक दर्ता भयो।")

    return JsonResponse({"success": True})


# ─────────────────────────────────────────────────────────────────────────────
# PDF Generation
# ─────────────────────────────────────────────────────────────────────────────

class PdfGenerateView(LoginRequiredMixin, View):
    def get(self, request, pk):
        html_template = get_template("pdf_generate.html")
        survey = get_object_or_404(Survey, pk=pk)
        questions = get_index_by_department(survey, self.request.user)
        data = []

        try:
            fill_survey = FillSurvey.objects.get(
                survey=survey.id, level_id=self.request.user.level
            )
        except FillSurvey.DoesNotExist:
            return HttpResponse(
                "तपाईंले अहिलेसम्म कुनै डाटा भर्नुभएको छैन। (No data submitted yet)",
                status=404,
            )

        for question in questions:
            question_data = {"title": question.title}
            option_answer = []
            files = []

            if question.has_child:
                child_questions = Question.objects.filter(parent=question.id).order_by(
                    "sequence_id"
                )
                question_data = {
                    "is_parent": True,
                    "parent_question": question,
                }
                child_data = []
                for child in child_questions:
                    child_datum = {"title": child.title}
                    child_option_answer = []
                    child_files = []
                    options = child.options.all().order_by("sequence_id")
                    for option in options:
                        answer = Answer.objects.filter(
                            fill_survey=fill_survey.id, option=option.id
                        ).first()
                        if option.field_type == "F":
                            child_files.append(answer)
                        else:
                            child_option_answer.append({
                                "answers": answer,
                                "options": option.title,
                            })
                    child_datum["option_answer"] = child_option_answer
                    child_datum["files"] = child_files
                    child_data.append(child_datum)
                question_data["child_data"] = child_data
            else:
                for option in question.options.all().order_by("sequence_id"):
                    answer = Answer.objects.filter(
                        fill_survey=fill_survey.id, option=option.id
                    ).first()
                    if option.field_type == "F":
                        files.append(answer)
                    else:
                        option_answer.append({
                            "answers": answer,
                            "options": option.title,
                        })
                question_data["option_answer"] = option_answer
                question_data["files"] = files

            data.append(question_data)

        context = {"data": data}
        html_template_data = html_template.render(context)
        pdf_file = HTML(
            string=html_template_data, base_url=request.build_absolute_uri()
        ).write_pdf()
        response = HttpResponse(pdf_file, content_type="application/pdf")
        response["Content-Disposition"] = 'filename="pdf_generate.pdf"'
        return response


# ─────────────────────────────────────────────────────────────────────────────
# Custom error handlers
# ─────────────────────────────────────────────────────────────────────────────

def bad_request(request, exception):
    return render(request, 'core/custom_error/bad_request.html', status=400)


def permission_denied(request, exception):
    return render(request, 'core/custom_error/permission_denied_page.html', status=403)


def page_not_found(request, exception):
    return render(request, 'core/custom_error/page_not_found.html', status=404)


def server_error(request):
    return render(request, 'core/custom_error/server_error_page.html', status=500)


class FileCreateView():
    template_name = "hello"



@login_required
def get_correction_data(request):
    """
    AJAX GET: Returns existing correction requests and their files
    for a specific question and user's level.
    """
    question_id = request.GET.get("question_id")
    if not question_id:
        return JsonResponse({"corrections": []})
 
    user_level = request.user.level
    if not user_level:
        return JsonResponse({"corrections": []})
 
    corrections = SurveyCorrection.objects.filter(
        question_id=question_id,
        level=user_level,
    ).order_by("-created_at")
 
    data = []
    for corr in corrections:
        files = []
 
        # Get files from NEW CorrectionDocument model
        try:
            from core.models import CorrectionDocument
            docs = CorrectionDocument.objects.filter(correction=corr)
            for doc in docs:
                files.append({
                    "id": doc.id,
                    "name": os.path.basename(doc.document.name),
                    "url": doc.document.url,
                    "date": corr.created_at.strftime("%Y-%m-%d"),
                })
        except Exception as e:
            logger.error(f"Error loading CorrectionDocument: {e}")
 
        # Also include OLD single document field if it has data
        if corr.document and corr.document.name:
            try:
                files.append({
                    "id": 0,
                    "name": os.path.basename(corr.document.name),
                    "url": corr.document.url,
                    "date": corr.created_at.strftime("%Y-%m-%d"),
                })
            except (ValueError, Exception):
                pass
 
        data.append({
            "id": corr.id,
            "subject": corr.sub,
            "message": corr.msg,
            "status": "जाँच भयो" if corr.status == "C" else "पेन्डिङ",
            "status_code": corr.status,
            "date": corr.created_at.strftime("%Y-%m-%d %H:%M"),
            "files": files,
        })
 
    return JsonResponse({"corrections": data})
 
 
@csrf_exempt
@login_required
def add_correction_file(request):
    """
    AJAX POST: Add a new file to an existing correction request.
    """
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method."}, status=405)
 
    correction_id = request.POST.get("correction_id")
    file = request.FILES.get("file")
 
    if not correction_id or not file:
        return JsonResponse({"success": False, "message": "Correction ID र फाइल आवश्यक छ।"})
 
    # Validate file
    if file.size > MAX_UPLOAD_SIZE:
        return JsonResponse({"success": False, "message": "फाइल साइज ५ MB भन्दा बढी हुनु हुँदैन।"})
    if not validate_file(file.name):
        return JsonResponse({"success": False, "message": "यो फाइल प्रकार अनुमति छैन।"})
 
    try:
        correction = SurveyCorrection.objects.get(id=correction_id)
 
        if correction.level != request.user.level:
            return JsonResponse({"success": False, "message": "अनुमति छैन।"})
 
        from core.models import CorrectionDocument
        doc = CorrectionDocument.objects.create(
            correction=correction,
            document=file,
        )
 
        return JsonResponse({
            "success": True,
            "file": {
                "id": doc.id,
                "name": os.path.basename(doc.document.name),
                "url": doc.document.url,
                "date": doc.created_at.strftime("%Y-%m-%d"),
            }
        })
    except SurveyCorrection.DoesNotExist:
        return JsonResponse({"success": False, "message": "Correction फेला परेन।"})
    except Exception as e:
        logger.error(f"add_correction_file error: {e}", exc_info=True)
        return JsonResponse({"success": False, "message": str(e)})
 
 
@csrf_exempt
@login_required
def send_for_correction(request):
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method."}, status=405)
 
    subject = request.POST.get("subject", "").strip()
    message = request.POST.get("message", "").strip()
    month = request.POST.get("month_id", "")
    question_id = request.POST.get("question_id", "")
 
    if not subject:
        return JsonResponse({"success": False, "message": "कृपया विषय लेख्नुहोस्।"})
    if not message:
        return JsonResponse({"success": False, "message": "कृपया सुधार विवरण लेख्नुहोस्।"})
    if not question_id:
        return JsonResponse({"success": False, "message": "प्रश्न ID फेला परेन।"})
 
    try:
        month = int(month) if month else None
    except (ValueError, TypeError):
        month = None
 
    current_user = request.user
    user_level = current_user.level
 
    document = request.FILES.get("filename")
    if document:
        if document.size > MAX_UPLOAD_SIZE:
            return JsonResponse({"success": False, "message": "फाइल साइज ५ MB भन्दा बढी हुनु हुँदैन।"})
        if not validate_file(document.name):
            return JsonResponse({"success": False, "message": "यो फाइल प्रकार अनुमति छैन।"})
 
    try:
        question_obj = Question.objects.get(pk=question_id)
    except (Question.DoesNotExist, ValueError):
        return JsonResponse({"success": False, "message": f"प्रश्न ID {question_id} फेला परेन।"})
 
    try:
        # Create correction (NO file in old field — use new model only)
        correction = SurveyCorrection.objects.create(
            sub=subject,
            msg=message,
            question=question_obj,
            user=current_user,
            level=user_level,
            month=month,
        )
 
        # Save file to NEW CorrectionDocument model
        if document:
            from core.models import CorrectionDocument
            CorrectionDocument.objects.create(
                correction=correction,
                document=document,
            )
 
        # Send ONE notification
        Notification.objects.get_or_create(
            question=question_obj,
            level=user_level,
            correction_checked=False,
            defaults={
                "user": current_user,
                "msg": f"{user_level.name} बाट सुधार अनुरोध प्राप्त भयो।",
                "is_viewed": False,
            },
        )
 
        return JsonResponse({
            "success": True,
            "message": "संशोधन अनुरोध सफलतापूर्वक पठाइयो।",
            "correction_id": correction.id,
        })
 
    except Exception as e:
        logger.error(f"Correction error: {e}", exc_info=True)
        return JsonResponse({"success": False, "message": f"त्रुटि: {str(e)}"})
 
@csrf_exempt
@login_required
def add_correction_file(request):
    """
    AJAX POST: Add a new file to an existing correction request.
    """
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method."}, status=405)
 
    correction_id = request.POST.get("correction_id")
    file = request.FILES.get("file")
 
    if not correction_id or not file:
        return JsonResponse({"success": False, "message": "Correction ID र फाइल आवश्यक छ।"})
 
    # Validate file
    is_valid, error_resp = _validate_uploaded_file(file)
    if not is_valid:
        return error_resp
 
    try:
        correction = SurveyCorrection.objects.get(id=correction_id)
 
        # Only allow adding files to own corrections
        if correction.level != request.user.level:
            return JsonResponse({"success": False, "message": "अनुमति छैन।"})
 
        from core.models import CorrectionDocument
        doc = CorrectionDocument.objects.create(
            correction=correction,
            document=file,
        )
 
        return JsonResponse({
            "success": True,
            "file": {
                "id": doc.id,
                "name": doc.get_document_name(),
                "url": doc.document.url,
                "date": doc.created_at.strftime("%Y-%m-%d"),
            }
        })
    except SurveyCorrection.DoesNotExist:
        return JsonResponse({"success": False, "message": "Correction फेला परेन।"})
 
 
# ─── ALSO UPDATE send_for_correction to save files to new model ──────
# REPLACE the send_for_correction function with:
 
@csrf_exempt
@login_required
def send_for_correction(request):
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method."}, status=405)
 
    subject = request.POST.get("subject", "").strip()
    message = request.POST.get("message", "").strip()
    month = request.POST.get("month_id", "")
    question_id = request.POST.get("question_id", "")
 
    if not subject:
        return JsonResponse({"success": False, "message": "कृपया विषय लेख्नुहोस्।"})
    if not message:
        return JsonResponse({"success": False, "message": "कृपया सुधार विवरण लेख्नुहोस्।"})
    if not question_id:
        return JsonResponse({"success": False, "message": "प्रश्न ID फेला परेन।"})
 
    try:
        month = int(month) if month else None
    except (ValueError, TypeError):
        month = None
 
    current_user = request.user
    user_level = current_user.level
 
    # Validate file if uploaded
    document = request.FILES.get("filename")
    if document:
        if document.size > MAX_UPLOAD_SIZE:
            return JsonResponse({"success": False, "message": "फाइल साइज ५ MB भन्दा बढी हुनु हुँदैन।"})
        if not validate_file(document.name):
            return JsonResponse({"success": False, "message": "यो फाइल प्रकार अनुमति छैन।"})
 
    try:
        question_obj = Question.objects.get(pk=question_id)
    except (Question.DoesNotExist, ValueError):
        return JsonResponse({"success": False, "message": f"प्रश्न ID {question_id} फेला परेन।"})
 
    try:
        # Create correction request (without document in old field)
        correction = SurveyCorrection.objects.create(
            sub=subject,
            msg=message,
            question=question_obj,
            user=current_user,
            level=user_level,
            month=month,
        )
 
        # Save file to new CorrectionDocument model
        if document:
            from core.models import CorrectionDocument
            CorrectionDocument.objects.create(
                correction=correction,
                document=document,
            )
 
        # Send ONE notification
        Notification.objects.get_or_create(
            question=question_obj,
            level=user_level,
            correction_checked=False,
            defaults={
                "user": current_user,
                "msg": f"{user_level.name} बाट सुधार अनुरोध प्राप्त भयो।",
                "is_viewed": False,
            },
        )
 
        return JsonResponse({
            "success": True,
            "message": "संशोधन अनुरोध सफलतापूर्वक पठाइयो।",
            "correction_id": correction.id,
        })
 
    except Exception as e:
        import logging
        logging.getLogger(__name__).error(f"Correction error: {e}", exc_info=True)
        return JsonResponse({
            "success": False,
            "message": f"त्रुटि: {str(e)}",
        })
