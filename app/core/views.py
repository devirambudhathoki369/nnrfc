import json
from user_mgmt.utils import get_index_by_department
from core.utils import (
    get_file_option_field,
    OPTION_FIELD_INPUT_TYPE,
    OPTION_FIELD_INDICATOR,
)
from core.dashboard.validators import validate_file
from django.shortcuts import get_object_or_404, render
from django.views.generic import DetailView, CreateView, ListView, TemplateView, View
from django.shortcuts import redirect
from django.http import JsonResponse, request, response
from django.views.decorators.csrf import csrf_exempt
from django.template.loader import get_template
from weasyprint import HTML
from django.http import HttpResponse
from django.urls.base import reverse_lazy


from core.models import (
    Notification,
    Question,
    Option,
    Answer,
    FillSurvey,
    Survey,
    AnswerDocument,
    FiscalYear,
    Complaint,
    SurveyCorrection,
    AppraisalReviewRequest,
)
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.contrib import messages

# import the logging library
import logging

# Get an instance of a logger
logger = logging.getLogger(__name__)


def check_answered_month_id(question, fill_survey_id):
    options = question.options.all()
    if options:
        answers = Answer.objects.filter(
            option=options[0].id, fill_survey=fill_survey_id
        )[0]
        month_id = answers.month
        return month_id


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


class QuestionaireDetailView(LoginRequiredMixin, DetailView):
    model = Question
    template_name = "core/indicator.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        context["parent"] = Question.objects.get(pk=question_id)
        context["children"] = Question.objects.filter(parent__id=question_id)
        context["title"] = Question.objects.all()
        return context


class AnswerCreateView(CreateView):
    model = Answer
    template_name = "core/indicator.html"
    fields = ["month", "value"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id
        child_questions = Question.objects.filter(parent=question_id).order_by(
            "sequence_id"
        )
        has_months = question_obj.month_requires
        context["has_months"] = has_months
        context["has_child"] = False
        child_options = []

        if len(child_questions) > 0:
            context["has_child"] = True
            for child_question in child_questions:
                options = (
                    Option.objects.filter(question=child_question)
                    .exclude(field_type="F")
                    .order_by("sequence_id")
                )

                options_data = []
                for option in options:
                    if option.field_type == "FY":
                        fiscal_years = FiscalYear.objects.all()
                        fy_data = []
                        for fiscal_year in fiscal_years:
                            fy_dict = {
                                "id": fiscal_year.id,
                                "name": fiscal_year.name,
                            }
                            fy_data.append(fy_dict)
                        option_data = {
                            "id": option.id,
                            "title": option.title,
                            "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                            # "field_indicator": "",
                            "option_type": option.option_type,
                            "fy_data": fy_data,
                        }
                    else:
                        option_data = {
                            "id": option.id,
                            "title": option.title,
                            "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                            "field_indicator": OPTION_FIELD_INDICATOR.get(
                                option.field_type, ""
                            ),
                            "option_type": option.option_type,
                        }
                    options_data.append(option_data)
                child_option_pair = {
                    "child_question": child_question,
                    "options": options_data,
                }
                child_options.append(child_option_pair)
        context["child_questions"] = child_questions
        context["question_id"] = question_id
        context["question_title"] = question_obj.title
        context["child_options"] = child_options
        context["survey_id"] = survey_id
        options = (
            Option.objects.filter(question=question_id)
            .exclude(field_type="F")
            .order_by("sequence_id")
        )

        options_data = []
        for option in options:
            if option.field_type == "FY":
                fiscal_years = FiscalYear.objects.all()
                fy_data = []
                for fiscal_year in fiscal_years:
                    fy_dict = {
                        "id": fiscal_year.id,
                        "name": fiscal_year.name,
                    }
                    fy_data.append(fy_dict)
                option_data = {
                    "id": option.id,
                    "title": option.title,
                    "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                    "option_type": option.option_type,
                    "fy_data": fy_data,
                }
            else:
                option_data = {
                    "id": option.id,
                    "title": option.title,
                    "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
                    "field_indicator": OPTION_FIELD_INDICATOR.get(
                        option.field_type, ""
                    ),
                    "option_type": option.option_type,
                }
            options_data.append(option_data)
        context["options"] = options_data
        return context

    def post(self, request, **kwargs):
        question_id = self.kwargs.get("pk")
        return redirect("core:filled_question", pk=question_id)


def get_numerator_denominator_value(
    question_id, option_type, fill_survey_id, month_id=None
):
    try:
        options = Option.objects.filter(
            question=question_id,
            option_type=option_type,
        )
        answer = Answer.objects.filter(
            option=options[0].id, fill_survey=fill_survey_id, month=month_id
        )
        return float(answer[0].value)
    except:
        return 0


class AnswerDetailView(TemplateView):
    template_name = "core/indicator_detail.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("pk")
        month_id = self.kwargs.get("month")
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id
        current_user = self.request.user
        fill_survey_id = FillSurvey.objects.filter(
            survey=survey_id, level_id=current_user.level
        )[0]
        # if not month_id:
        #     month_id = check_answered_month_id(question_obj, fill_survey_id)
        child_questions = Question.objects.filter(parent=question_id).order_by(
            "sequence_id"
        )
        context["has_child"] = False
        context["survey_id"] = survey_id
        has_months = question_obj.month_requires
        context["has_months"] = has_months
        context["month_id"] = month_id
        question_option_value = []
        if len(child_questions) > 0:
            context["has_child"] = True
            for child_question in child_questions:
                options = (
                    Option.objects.filter(question=child_question)
                    .exclude(field_type="F")
                    .order_by("sequence_id")
                )
                file_option = Option.objects.filter(
                    question=child_question.id,
                    field_type="F",
                )
                files = []
                question_option = {"question": child_question}
                option_answer_pair = []
                for option in options:
                    if option.option_type == "Per":
                        try:
                            numerator = get_numerator_denominator_value(
                                child_question.id, "Num", fill_survey_id
                            )
                            denominator = get_numerator_denominator_value(
                                child_question.id, "Deno", fill_survey_id
                            )
                            answer = (numerator / denominator) * 100
                            answer = round(answer)
                        except ValueError:
                            answer = "Invalid data type"
                        except Exception as e:
                            answer = 0
                            print(e)
                    else:
                        answer = Answer.objects.filter(
                            option=option.id, fill_survey=fill_survey_id
                        )[0].value
                    option_title = option.title
                    option_answer_value = {
                        "title": option_title,
                        "answer": answer,
                        "indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
                    }
                    option_answer_pair.append(option_answer_value)
                question_option["option_answer"] = option_answer_pair

                if len(file_option) > 0:
                    file_optn = file_option[0]

                    answer_obj = Answer.objects.filter(
                        option=file_optn.id, fill_survey=fill_survey_id
                    )

                    if len(answer_obj) > 0:
                        answer_obj = answer_obj[0]

                        files = AnswerDocument.objects.filter(answer=answer_obj.id)
                        # try:
                        #     files = [file.document.name.split('/')[1] for file in files]
                        # except:
                        #     pass
                question_option["files"] = files
                question_option_value.append(question_option)

            context["files"] = files
            context["question_option_value"] = question_option_value
            context["child_questions"] = child_questions
        else:
            option_answer = []
            options = (
                Option.objects.filter(question=question_id)
                .exclude(field_type="F")
                .order_by("sequence_id")
            )
            file_option = Option.objects.filter(
                question=question_id,
                field_type="F",
            )
            files = []
            for option in options:
                if option.option_type == "Per":
                    try:
                        numerator = get_numerator_denominator_value(
                            question_id, "Num", fill_survey_id, month_id
                        )
                        denominator = get_numerator_denominator_value(
                            question_id, "Deno", fill_survey_id, month_id
                        )
                        answer = (numerator / denominator) * 100
                        answer = round(answer)
                    except ValueError:
                        answer = "Invalid data type"
                    except:
                        answer = 0
                else:
                    try:
                        if month_id:
                            answer_obj = Answer.objects.filter(
                                option=option.id,
                                fill_survey=fill_survey_id,
                                month=month_id,
                            )[0]
                            answer = answer_obj.value
                        else:
                            answer_obj = Answer.objects.filter(
                                option=option.id, fill_survey=fill_survey_id
                            )[0]
                            fy_answer = answer_obj.fiscal_year
                            if fy_answer:
                                answer = fy_answer.name
                            else:
                                answer = answer_obj.value
                    except IndexError:
                        answer = ""
                option_answer_pair = {
                    "option_title": option.title,
                    "answer_value": answer,
                    "indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
                }
                option_answer.append(option_answer_pair)
            if len(file_option) > 0:
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

                    files = AnswerDocument.objects.filter(answer=answer_obj.id)
                except Exception as e:
                    logger.error(
                        "Error while searching for uploaded file on Answer Template."
                    )
                try:
                    # files = [file.document.name.split('/')[1] for file in files]
                    files = [file.document for file in files]
                except:
                    pass
            context["files"] = files
            context["option_answer_pairs"] = option_answer
        context["question_obj"] = question_obj
        context["question_id"] = question_obj.id
        return context


@csrf_exempt
@transaction.atomic
def submit_answer(request):
    if request.is_ajax() and request.method == "POST":
        submitted_answers = request.POST.get("answers")
        question_id = request.POST.get("question_id")
        fy_answers = request.POST.get("fy_answers")
        month_value = request.POST.get("month_value")
        question_file = request.POST.get("question_file")
        if month_value == "":
            month_value = None
        fy_answers = json.loads(fy_answers)
        question_obj = Question.objects.get(id=question_id)
        file_required = question_obj.is_document_required
        files = request.FILES
        if file_required:
            if len(files) <= 0:
                data = {
                    "success": False,
                    "message": "Please add file before submittion.",
                    "file_required_validation": True,
                }
                return JsonResponse(data)

        is_question_filled = question_obj.is_question_filled
        survey = question_obj.survey
        survey_id = survey.id
        current_user = request.user
        answers = json.loads(submitted_answers)
        for answer in answers:
            if answer.get("is_valid") == False:
                data = {
                    "success": False,
                    "message": "Invalid data. Please check your answer before submitting.",
                    "invalid_data": True,
                }
                return JsonResponse(data)

        try:
            fill_survey = FillSurvey.objects.get(
                survey=survey.id, level_id=current_user.level
            )
        except FillSurvey.DoesNotExist:
            fill_survey_create = FillSurvey.objects.create(
                survey=survey, level_id=current_user.level
            )
            fill_survey = fill_survey_create

        if files:
            for file in files:
                question_id = int(file.split("f")[1])
                option_field_file = get_file_option_field(question_id)

                try:
                    file_data = files[file]
                    is_valid_file = validate_file(file_data.name)
                    if not is_valid_file:
                        data = {
                            "success": False,
                            "message": "Invalid file extension.",
                            "not_valid_ext": True,
                        }
                        return JsonResponse(data)
                    answer_file = Answer.objects.create(
                        fill_survey=fill_survey,
                        option=option_field_file,
                        value=file_data.name,
                        month=month_value,
                        created_by_level=current_user.level,
                    )

                    create_document = AnswerDocument.objects.create(
                        answer=answer_file, document=file_data
                    )

                except IndexError:
                    data = {
                        "success": False,
                        "message": "No file field allocated for given question.",
                        "no_file_field": True,
                    }
                    return JsonResponse(data)

        for answer in answers:
            option_obj = Option.objects.get(id=answer["option_id"])
            create_answer = Answer.objects.create(
                fill_survey=fill_survey,
                option=option_obj,
                value=answer["value"],
                created_by=current_user,
                created_by_level=current_user.level,
                month=month_value,
            )

        if fy_answers:
            for fy_ans in fy_answers:
                option_obj = Option.objects.get(id=fy_ans["option_id"])
                fiscal_year_obj = FiscalYear.objects.get(id=fy_ans["value"])
                create_answer = Answer.objects.create(
                    fill_survey=fill_survey,
                    option=option_obj,
                    fiscal_year=fiscal_year_obj,
                    created_by=current_user,
                    created_by_level=current_user.level,
                    month=month_value,
                )
        data = {"success": True}
        return JsonResponse(data)


@login_required
def SurveyList(request):
    user=request.user
    user_roles=request.user.roles.all().count()
    if user_roles >= 1:
        return redirect('dashboard:dashboard')
    if user.is_superuser:
        return redirect('dashboard:dashboard')
    try:
        user_level_type = request.user.level.type.type
        survey_list = Survey.objects.filter(level=user_level_type)
    except AttributeError:
        survey_list = Survey.objects.all()
    context = {"survey_list": survey_list, "questions": Question.objects.all()}
    return render(request, "core/survey.html", context)


@csrf_exempt
def send_for_correction(request):
    if request.is_ajax() and request.method == "POST":
        subject = request.POST.get("subject")
        message = request.POST.get("message")
        month = request.POST.get("month_id")
        try:
            month = int(month)
        except:
            month = None
        current_user = request.user
        user_obj = current_user
        user_level = current_user.level
        try:
            document = request.FILES["filename"]
            if document.size > 2097152:
                return JsonResponse({"message":"Please select image size no more than 2 MB"},status=400)

        except:
            document = None
        question_id = request.POST.get("question_id")
        question_obj = get_object_or_404(Question, pk=question_id)
        try:
            correction_obj = SurveyCorrection.objects.create(
                sub=subject,
                msg=message,
                question=question_obj,
                document=document,
                user=user_obj,
                level=user_level,
                month=month,
            )
            success = True
            message = "Correction request submitted successfully."
        except Exception as e:
            success = False
            message = "Correction request could not be submitted."
        response_data = {
            "success": success,
            "message": message,
        }
        return JsonResponse(response_data)


@csrf_exempt
def check_level_month_data(request):
    if request.is_ajax() and request.method == "POST":
        question_id = request.POST.get("question_id")
        month_value = request.POST.get("month_value")
        current_user = request.user
        question_obj = Question.objects.get(id=question_id)
        survey_id = question_obj.survey.id
        is_filled = False
        data = {}
        try:
            fill_survey = FillSurvey.objects.filter(
                survey_id=survey_id, level_id=current_user.level
            )
            options = question_obj.options.all()
            for option in options:
                answers = option.answers.filter(
                    fill_survey=fill_survey[0].id, month=month_value
                )
                if len(answers) > 0:
                    if answers[0].value:
                        is_filled = True
                    data = {
                        "success": True,
                        "has_month_value": True,
                    }
        except AttributeError:
            fill_survey = None

        return JsonResponse(data)


@login_required
def register_SimpleComplaint(request):
    if request.is_ajax and request.method == "POST":

        sub = request.POST.get("sub", None)
        msg = request.POST.get("msg", None)

        complaint_file = request.FILES.get("document", None)
        if complaint_file:
            complaint_file_name = complaint_file.name
            is_file_valid = validate_file(complaint_file_name)
            if not is_file_valid:
                response_data = {
                    "message": "This file extension is not allowed.",
                    "invalid_file": True
                }
                return JsonResponse(response_data)

        user = request.user
        user_level_type = request.user.level

        complaint = Complaint(
            sub=sub,
            msg=msg,
            level=user_level_type,
            user=request.user,
            complaint_file=complaint_file,
        )
        complaint.save()
        messages.success(
            request, "Your Simple Complaint Has Been Registered Successfully."
        )

    return JsonResponse({"success": True})


class PdfGenerateView(View):
    def get(self, request, pk):
        html_template = get_template("pdf_generate.html")
        survey = get_object_or_404(Survey, pk=pk)
        questions = get_index_by_department(survey, self.request.user)
        data = []
        fill_survey = FillSurvey.objects.get(
            survey=survey.id, level_id=self.request.user.level
        )

        for question in questions:
            question_data = {}
            option_answer = []
            files = []
            question_data["title"] = question.title
            if question.has_child:
                child_questions = Question.objects.filter(parent=question.id).order_by(
                    "sequence_id"
                )
                question_data = {}
                question_data["is_parent"] = True
                question_data["parent_question"] = question
                child_data = []
                for child in child_questions:
                    child_datum = {}
                    child_datum["title"] = child.title
                    child_option_answer = []
                    child_files = []
                    options = child.options.all().order_by("sequence_id")
                    for option in options:
                        answer_dictionary = {}
                        answer = Answer.objects.filter(
                            fill_survey=fill_survey.id, option=option.id
                        ).first()
                        if option.field_type == "F":
                            child_files.append(answer)
                        else:
                            answer_dictionary["answers"] = answer
                            answer_dictionary["options"] = option.title
                            child_option_answer.append(answer_dictionary)
                    child_datum["option_answer"] = child_option_answer
                    child_datum["files"] = child_files
                    child_data.append(child_datum)
                question_data["child_data"] = child_data
                data.append(question_data)
            else:
                for option in question.options.all().order_by("sequence_id"):
                    answer_dictionary = {}
                    answer = Answer.objects.filter(
                        fill_survey=fill_survey.id, option=option.id
                    ).first()
                    if option.field_type == "F":
                        files.append(answer)
                    else:
                        answer_dictionary["answers"] = answer
                        answer_dictionary["options"] = option.title
                        option_answer.append(answer_dictionary)
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


@login_required
def register_EvaluationComplaint(request):
    if request.is_ajax and request.method == "POST":

        questions = request.POST.get("questions", None)
        question_obj = Question.objects.get(pk=questions)
        subject = request.POST.get("subject", None)
        score_obtained = request.POST.get("score_obtained", None)
        reason = request.POST.get("reason", None)
        expected_score = request.POST.get("expected_score", None)

        file_upload = request.FILES.get("document", None)
        if file_upload:
            complaint_file_name = file_upload.name
            is_file_valid = validate_file(complaint_file_name)
            if not is_file_valid:
                response_data = {
                    "message": "This file extension is not allowed.",
                    "invalid_file": True
                }
                return JsonResponse(response_data)

        user = request.user
        user_level_type = request.user.level

        complaint = AppraisalReviewRequest(
            question_id=question_obj,
            subject=subject,
            score_obtained=score_obtained,
            reason=reason,
            expected_score=expected_score,
            level=user_level_type,
            user=request.user,
            file_upload=file_upload,
        )
        complaint.save()
        messages.success(
            request, "Your Evaluation Complaint Has Been Registered Successfully."
        )

    return JsonResponse({"success": True})



def bad_request(request, exception): 
    response = render(request, 'core/custom_error/bad_request.html')
    response.status_code = 400
    return response


def permission_denied(request, exception): 
    response = render(request, 'core/custom_error/permission_denied_page.html')
    response.status_code = 403
    return response


def page_not_found(request, exception): 
    response = render(request, 'core/custom_error/page_not_found.html')
    response.status_code = 404
    return response

# def Handle500Error(request, *args, **argv): 
#     return render(request, 'core/custom_error/server_error_page.html', status=500)

def server_error(request): 
    response = render(request, 'core/custom_error/server_error_page.html')
    response.status_code = 500
    return response


