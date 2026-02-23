from django.contrib.messages.api import success
from django.forms.models import fields_for_model
from django.http import request
from typing import List

from django.views.generic.list import ListView
from core.utils import OPTION_FIELD_INPUT_TYPE
from user_mgmt.models import Department, District, Level
from django.contrib import messages
from django.http.response import (
    Http404,
    HttpResponseRedirect,
    JsonResponse,
    HttpResponse,
)
from django.urls.base import reverse_lazy
from django.views.generic.base import RedirectView, TemplateView
from django.views.generic.detail import DetailView
from django.views.generic.edit import DeleteView, UpdateView
from core.utils import (
    create_activity_log,
    filled_question_list_by_level,
    get_activity_log_data,
    get_field_type_choices,
    get_option_type_choices,
    get_options_with_field_types,
    new_options_bulk_create,
    option_bulk_update,
    options_bulk_create,
    options_calculation_conifg,
    question_bulk_update,
    surveys_by_user_level,
)
from user_mgmt.utils import get_local_levels_by_province

from django.views.generic import CreateView

from core.models import (
    AnswerDocument,
    Complaint,
    CorrectionActivityLog,
    Answer,
    FillSurvey,
    Notification,
    Option,
    Survey,
    Question,
    FiscalYear,
    SurveyCorrection,
    CentralBody,
    ProvinceBody,
    LocalBody,
    AppraisalReviewRequest,
)
from user_mgmt.models import Department, LevelType, Level, UserPost

from django.views import generic
from django.db import transaction
from django.shortcuts import get_object_or_404, redirect, render
from django.views import View
from django.urls import reverse
import json
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.messages.views import SuccessMessageMixin
from core.dashboard.forms import LevelForm


class DashboardIndexView(LoginRequiredMixin, generic.ListView):
    template_name = "core/dashboard/home.html"
    model = Survey
    context_object_name = "province_list"
    paginate_by = 10

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["province_list"] = Survey.objects.filter(level="P")
        context["local_list"] = Survey.objects.filter(level="L")
        return context


class DashBoardHome(LoginRequiredMixin, TemplateView):
    template_name = "core/dashboard/dashboard_home.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        try:
            fiscal = FiscalYear.objects.filter(active_fy=True).first()
            survey = Survey.objects.filter(fiscal_year=fiscal.id).first()
            questions = survey.questions.filter(parent=None, month_requires=False)
            try:
                question_count = questions.count()
                levels = Level.objects.filter(type__type="P")
                data = []
                for level in levels:
                    question_filled = 0
                    for question in questions:
                        children_question = Question.objects.filter(parent=question.id)
                        if len(children_question) >= 1:
                            options = Option.objects.filter(
                                question__id__in=children_question
                            )
                        else:
                            options = question.options.all()

                        for option in options:
                            answers = Answer.objects.filter(
                                option=option, created_by_level=level.id
                            )
                            if len(answers) >= 1:
                                question_filled = question_filled + 1
                                break
                    dictdata = {
                        "data": level.name,
                        "question_filled": (question_filled * 100) / question_count,
                        "question_filleds": question_filled,
                    }
                    data.append(dictdata)
            except ZeroDivisionError:
                context["question_filled"] = "No existing data found."

            context["questions"] = data
            context["count"] = question_count
        except:
            context["data"] = "No data available"

        return context


class IndexCreateView(LoginRequiredMixin, CreateView):
    model = Question
    template_name = "core/dashboard/index.html"
    fields = ["title", "month_requires", "sequence_id"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["f_years"] = FiscalYear.objects.all().order_by("start_date")
        return context

    def form_valid(self, form):
        with transaction.atomic():
            survey_name = self.request.POST.get("s_name")
            f_year = self.request.POST.get("f_year")
            level = self.request.POST.get("s_level")
            survey = Survey.objects.create(
                name=survey_name, fiscal_year_id=f_year, level=level
            )
            form.instance.survey = survey
            parent_ques = form.save()
            success_url = reverse(
                "dashboard:index_option_create",
                args=[
                    parent_ques.id,
                ],
            )
            messages.success(self.request, "Index Created Successfully.")
            return JsonResponse({"success": True, "url": success_url})

    def form_invalid(self, form):
        return JsonResponse(form.errors)


class AddIndexView(IndexCreateView):
    def form_valid(self, form):
        survey_id = self.kwargs.get("survey_id")
        form.instance.survey_id = survey_id
        ques = form.save()
        success_url = reverse(
            "dashboard:index_option_create",
            args=[
                ques.id,
            ],
        )
        messages.success(self.request, "Index Added Successfully.")
        return JsonResponse({"success": True, "url": success_url})


class SurveyDetailView(DetailView):
    model = Survey
    template_name = "core/dashboard/survey_detail.html"
    context_object_name = "survey"
    pk_url_kwarg = "survey_id"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        survey = self.get_object()
        context["questions"] = survey.questions.filter(parent=None).order_by(
            "sequence_id"
        )
        context["levels"] = Level.objects.filter(type__type="P")
        return context


class IndexDeleteView(DeleteView):
    model = Question
    template_name = "core/dashboard/survey_detail.html"

    def post(self, request, **kwargs):
        question = self.get_object()
        question_survey_id = question.survey.id
        question.delete()
        if question_survey_id:
            return redirect("dashboard:survey_detail", question_survey_id)
        return redirect("dashboard:home")


class IndexUpdateView(UpdateView):
    model = Question
    template_name = "core/dashboard/index_update.html"
    fields = ["title", "month_requires", "sequence_id", "department"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["departments"] = Department.objects.all()
        return context

    def form_valid(self, form):
        index = form.save()
        url = reverse("dashboard:survey_detail", kwargs={"survey_id": index.survey.id})
        messages.success(self.request, "Saved Successfully.")
        return JsonResponse({"success": True, "url": url})

    def form_invalid(self, form):
        return JsonResponse(form.errors)


class OptionCreateView(View):
    """view for `save and add another group` button.
    Creates multiple child questions with different option groups
    """

    def post(self, request, **kwargs):
        question = get_object_or_404(Question, pk=kwargs.get("ques_id"))
        data = json.loads(request.body.decode("utf-8"))
        option_titles = data.get("option_title")
        ques = data.get("ques_title")
        documents = data.get("is_file", 0)
        field_types = data.get("field_type")
        ## is_calc_field = data.get("is_calc_field", 0)
        numerator = data.get("n")
        denominator = data.get("d")
        with transaction.atomic():
            if ques and ques != "" and option_titles:
                q = Question.objects.create(
                    title=ques,
                    is_document_required=documents,
                    parent=question,
                    survey_id=question.survey.id,
                    is_options_created=False,
                )
                question.is_options_created = True
                question.save()
                options = options_bulk_create(q, option_titles, field_types)
                if numerator and denominator:
                    # update the options types and calculation field types
                    options_calculation_conifg(options, numerator, denominator)

                # after new option groups added to the child question,
                # delete existing options of parent question if any
                if Option.objects.filter(question=question):
                    Option.objects.filter(question=question).delete()

                messages.success(request, "Saved Successfully.")
                return JsonResponse({"success": True})
            return JsonResponse({"success": False})


class IndexOptionCreateView(View):
    """view for `save` button. Saves new changes of single parent question and it's multiple options"""

    template_name = "core/dashboard/index_options.html"

    def get(self, request, **kwargs):
        question = get_object_or_404(Question, pk=kwargs.get("ques_id"))
        context = {}
        context["ques"] = question
        context["childs"] = question.children_questions.all()
        context["field_type_choices"] = get_field_type_choices()
        return render(request, self.template_name, context)

    def post(self, request, **kwargs):
        question = get_object_or_404(Question, pk=kwargs.get("ques_id"))
        data = request.POST
        option_titles = data.getlist("title")
        documents_req = data.get("is_document_required", 0)
        field_types = data.getlist("field_type")
        ## is_calc_field = data.get("is_calc_field", 0)
        numerator = data.get("n")
        denominator = data.get("d")
        with transaction.atomic():
            question.is_document_required = documents_req
            question.is_options_created = False
            question.save()
            options = options_bulk_create(question, option_titles, field_types)
            if numerator and denominator:
                options_calculation_conifg(options, numerator, denominator)

            # if parent question has child questions before delete them
            if question.children_questions.all():
                question.children_questions.all().delete()
            url = reverse("dashboard:survey_detail", args=(question.survey.id,))
            messages.success(request, "Saved Successfully.")
            return JsonResponse({"success": True, "url": url})


class AddMoreIndexToSurvey(IndexOptionCreateView):
    template_name = "core/dashboard/add_more_index_options.html"


class IndexOptionUpdateView(View):
    """bulk update of multiple questions and options at a time"""

    template_name = "core/dashboard/index_options_update.html"

    def get(self, request, **kwargs):
        question = get_object_or_404(Question, pk=kwargs.get("ques_id"))
        context = {}
        context["ques"] = question
        context["childs"] = question.children_questions.all()
        context["field_type_choices"] = get_field_type_choices()
        context["option_type_choices"] = get_option_type_choices()[:2]
        return render(request, self.template_name, context)

    def post(self, request, **kwargs):
        question = get_object_or_404(Question, pk=kwargs.get("ques_id"))
        data = request.POST
        option_titles = data.getlist("title")  # existing option titles
        q_ids = data.getlist("q_id")  # question ids for the new options
        opt_ids = data.getlist("o_id")  # existing option ids
        ques = data.getlist("ques")  # existing question ids
        ques_titles = data.getlist("ques_title")  # existing question titles
        documents = data.getlist("is_document_required")
        calc_fields = data.getlist("is_calc_field")
        field_types = data.getlist("field_type")
        delete_option_ids = data.getlist("delete_option_id")
        documents_req = [True if i in documents else False for i in ques]
        calulation_ids = [0 if i in calc_fields else i for i in ques]
        numerator = data.getlist("n")
        denominator = data.getlist("d")
        n_ids = [i if i in numerator else None for i in opt_ids]
        d_ids = [i if i in denominator else None for i in opt_ids]
        new_option_titles = data.getlist("n_title")
        new_field_types = data.getlist("n_field_type")
        delete_group_ids = data.getlist("delete_group_ids")
        with transaction.atomic():
            question_bulk_update(ques, documents_req, ques_titles)
            option_bulk_update(opt_ids, option_titles, field_types, n_ids, d_ids)
            new_options_bulk_create(q_ids, new_option_titles, new_field_types)
            if delete_option_ids:
                Option.objects.filter(id__in=delete_option_ids).delete()
            if delete_group_ids:
                Question.objects.filter(id__in=delete_group_ids).delete()
            if calulation_ids:
                # udpate options type and calc field if calculation field doesn't enabled
                for id in calulation_ids:
                    q = Question.objects.filter(id=id).first()
                    if q:
                        q.options.all().update(is_calc_field=False, option_type=None)

        messages.success(self.request, "Details Updated Successfully.")
        return redirect("dashboard:survey_detail", question.survey.id)


def get_question_options(request, q_id):
    question = Question.objects.get(id=q_id)
    options = list(question.options.all().values("id", "title", "option_type"))
    numerator_type = question.options.filter(option_type="Num").first()
    denominator_type = question.options.filter(option_type="Deno").first()
    if numerator_type and denominator_type:
        n_id = numerator_type.id
        d_id = denominator_type.id
    else:
        n_id = None
        d_id = None
    data = {"options": options, "n_id": n_id, "d_id": d_id, "q_id": question.id}
    return JsonResponse(data)


def assign_department_to_index(request, q_id):
    index = Question.objects.get(id=q_id)
    department = request.POST.get("depart")
    Question.objects.filter(id=q_id).update(department=department)
    index.children_questions.all().update(department=department)
    messages.success(request, "Updated Successfully.")
    return redirect("dashboard:survey_detail", index.survey.id)


def get_correction_detail(request, level_id):
    corrections = SurveyCorrection.objects.filter(level=level_id).order_by("status")
    level = Level.objects.get(id=level_id)
    context = {"corrections": corrections, "level": level}
    return render(request, "core/dashboard/correction_detail.html", context)


def correction_fix_view(request, correction_id, ques_id):
    question = Question.objects.get(id=ques_id)
    correction = SurveyCorrection.objects.get(id=correction_id)
    level = correction.level
    options = question.options.all().order_by("sequence_id")
    options_data = get_options_with_field_types(options, level)
    context = {"ques": question, "correction": correction, "options_data": options_data}
    if request.method == "POST":
        answer_ids = request.POST.getlist("ans_id")
        ans_values = request.POST.getlist("ans")
        with transaction.atomic():
            correction.status = "C"
            correction.save()

            # update answer values
            params = zip(answer_ids, ans_values)
            for a_id, v in params:
                ans = Answer.objects.get(id=a_id)
                ans.value = v
                ans.save()
            # update if new files updated
            file_ans = request.POST.get("anss")
            file = request.FILES.get("new_file")
            if file_ans and file:
                answer_obj = AnswerDocument.objects.get(answer_id=file_ans)
                answer_obj.document = file
                answer_obj.save()
                Answer.objects.filter(id=file_ans).update(value=file.name)

            # update levels of activity log
            q_options = correction.question.options.all().values_list("id", flat=True)
            logs = CorrectionActivityLog.objects.filter(option_id__in=q_options)
            logs.update(
                action_level=correction.level.name,
                action_level_type=correction.level.type.type,
            )

            # send notification to correction user
            Notification.objects.create(
                user=correction.user,
                msg=f"तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।",
                correction=correction,
                level=level,
                correction_checked=True,
            )
            messages.success(request, "Updated Successfully.")
            return redirect("dashboard:correction_detail", correction.level_id)
    return render(request, "core/dashboard/correction_fix.html", context)


def show_activity_logs(request):
    logs = CorrectionActivityLog.objects.all().order_by()
    qs1 = logs.filter(action_level_type="P").distinct("action_level")
    qs2 = logs.filter(action_level_type="L").distinct("action_level")
    province_logs = logs.filter(id__in=qs1)
    local_logs = logs.filter(id__in=qs2)

    context = {"p_logs": province_logs, "l_logs": local_logs}
    return render(request, "core/dashboard/activity_logs.html", context)


def show_questions_logs(request, q_id, level):
    qs = CorrectionActivityLog.objects.all().order_by()
    logs = qs.filter(question_id=q_id, action_level=level).distinct("question_id")
    q_logs = qs.filter(id__in=logs)
    return render(request, "core/dashboard/activity_logs_ques.html", {"q_logs": q_logs})


def log_detail_view(request, action_level, q_id):
    logs = CorrectionActivityLog.objects.filter(
        action_level=action_level, question_id=q_id
    )
    return render(
        request,
        "core/dashboard/activity_log_detail.html",
        {"logs": logs, "a_level": action_level},
    )


def get_correction_requests(request):
    p_crts = SurveyCorrection.objects.filter(level__type__type="P",level=request.user.level).distinct("level")
    if request.user.is_office_head:
        p_crts = SurveyCorrection.objects.filter(level__type__type="P").distinct("level")
    l_crts = SurveyCorrection.objects.filter(level__type__type="L").distinct("level")

    context = {
        "p_corrections": p_crts,
        "l_corrections": l_crts,
    }

    return render(request, "core/dashboard/correction_req.html", context)


def list_complaints(request):
    p_complaints = Complaint.objects.filter(level__type__type="P",level=request.user.level).distinct("level")
    if request.user.is_office_head:
        p_complaints = Complaint.objects.filter(level__type__type="P").distinct("level")
    l_complaints = Complaint.objects.filter(level__type__type="L").distinct("level")
    context = {"p_complaints": p_complaints, "l_complaints": l_complaints}
    return render(request, "core/dashboard/list_complaints.html", context)


def level_complaints(request, level_id):
    complaints = Complaint.objects.filter(level_id=level_id)
    level = Level.objects.get(id=level_id)
    context = {"complaints": complaints, "level": level}
    return render(request, "core/dashboard/level_complaints.html", context)


def complaint_detail(request, complaint_id):
    complaint = Complaint.objects.get(id=complaint_id)
    data = complaint.to_json()
    return JsonResponse(data)


def mark_complaint_checked(request, complaint_id):
    if request.method == "POST":
        Complaint.objects.filter(id=complaint_id).update(is_checked=True)
        messages.success(request, "Checked Successfully.")
        return redirect(request.META.get("HTTP_REFERER", "dashboard:list_complaints"))


def update_notification_status(request):
    if request.method == "POST":
        data = json.loads(request.body.decode("utf-8"))
        Notification.objects.filter(id=data.get("notif_id")).update(is_viewed=True)
        return JsonResponse({"success": True})


def survey_list(request):
    qs = surveys_by_user_level(request.user)
    context = {
        "p_surveys": qs.filter(level="P"),
        "l_surveys": qs.filter(level="L"),
    }
    return render(request, "core/dashboard/survey_list.html", context)


def fill_surveys_list(request, survey_id):
    fill_surveys = FillSurvey.objects.filter(survey_id=survey_id)
    # if not request.user.is_superuser:
    if False:
        fill_surveys = fill_surveys.filter(level_id=request.user.level)
    context = {"fill_surveys": fill_surveys}
    return render(request, "core/dashboard/fill_surveys.html", context)


def survey_filled_questions(request, survey_id, level_id):
    survey = Survey.objects.get(id=survey_id)
    questions = filled_question_list_by_level(survey, level_id)
    context = {"questions": questions, "survey_id": survey_id, "level_id": level_id}
    return render(request, "core/dashboard/filled_ques.html", context)


def view_filled_ans(request, q_id, level_id):
    question = Question.objects.get(id=q_id)
    child_questions = question.children_questions.all()
    return render(
        request,
        "core/dashboard/filled_answers.html",
        {"q": question, "child_ques": child_questions, "level_id": level_id},
    )


class MasterConfigurationView(TemplateView):
    template_name = "core/dashboard/master_configuration.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["province_list"] = Level.objects.filter(type__type="P")
        context["local_list"] = Level.objects.filter(type__type="L")
        context["districts"] = District.objects.all()
        context["department_list"] = Department.objects.all()
        context["usersPost_list"] = UserPost.objects.all()
        context["fiscal_year"] = FiscalYear.objects.all()
        filter_val = self.request.GET.get("filter")
        context["active_tab"] = filter_val
        return context


class ProvinceNameCreateView(SuccessMessageMixin, CreateView):
    model = Level
    template_name = "core/dashboard/master_configuration.html"
    fields = ["name"]

    def get_context_data(self, **kwargs):
        prov_id = Level.objects.filter(type__type="P")
        filter_val = self.request.GET.get("filter")
        context = {}
        context["active_tab"] = filter_val
        return context

    def post(self, request, *args, **kwargs):
        context = self.get_context_data()
        filter_val = self.request.GET.get("filter")

        if filter_val == "local":
            level_code = request.POST["level_code"]

            district = request.POST["district"]
            district = District.objects.filter(id=district).first()

            province_level = request.POST["name"]
            name = Level.objects.filter(id=province_level).first()

            local_id = LevelType.objects.filter(type="L")
            localName = request.POST.get("localName")

            obj = Level.objects.create(
                name=localName,
                province_level=name,
                level_code=level_code,
                district=district,
            )

            obj.type = local_id[0]
            obj.save()
        elif filter_val == "department":
            depart_name = request.POST.get("depart_name")
            obj = Department.objects.create(name=depart_name)
            obj.save()
        elif filter_val == "province" or filter_val == None:
            prov_id = LevelType.objects.filter(type="P")
            name = request.POST.get("name")
            obj = Level.objects.create(name=name)
            obj.type = prov_id[0]
            obj.save()
        elif filter_val == "position":
            name = request.POST.get("name")
            obj = UserPost.objects.create(name=name)
            obj.save()
        elif filter_val == "district":
            name_eng = request.POST.get("name_eng")
            name_np = request.POST.get("name_np")
            obj = District.objects.create(name_np=name_np, name_eng=name_eng)
            obj.save()
        elif filter_val == "fiscalyear":
            name = request.POST.get("name")
            start_date_bs = request.POST.get("start_date_bs")
            end_date_bs = request.POST.get("end_date_bs")
            obj = FiscalYear.objects.create(
                name=name, start_date_bs=start_date_bs, end_date_bs=end_date_bs
            )
            obj.active_fy = True
            obj.save()

        res = {"redirect_url": f"?filter={filter_val}"}

        return JsonResponse(res)


class ProvinceNameUpdateView(SuccessMessageMixin, UpdateView):
    model = Level
    template_name = "core/dashboard/province_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    fields = ["name"]
    success_message = "Province Name Updated Successfully."

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["provinceNameList"] = Level.objects.filter(
            province_level=LevelType.type_choices == "P"
        )
        return context


class LocalNameUpdateView(SuccessMessageMixin, UpdateView):
    model = Level
    template_name = "core/dashboard/local_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    form_class = LevelForm
    # fields = ["name", "province_level", "district", "level_code"]
    success_message = "Local Name Updated Successfully."
    context_object_name = "context_level"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["province_list"] = Level.objects.filter(type__type="P")
        # context["selected_province_name"] = self.object.province_level
        # context["selected_district"] = self.object.district
        context["local_list"] = Level.objects.filter(type__type="L")
        context["districts"] = District.objects.all()
        return context

    def form_valid(self, form):
        messages.success(self.request, self.success_message)
        form.save()
        return JsonResponse({}, status=200)


class DepartmentNameListView(ListView):
    model = Department
    fields = ["name"]
    template_name = "core/dashboard/department_list.html"


class DepartmentNameUpdateView(SuccessMessageMixin, UpdateView):
    model = Department
    fields = ["name"]
    template_name = "core/dashboard/department_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    success_message = "Department Name Updated Successfully."

    def form_valid(self, form):
        messages.success(self.request, self.success_message)
        form.save()
        return JsonResponse({}, status=200)


class UsersPostNameUpdateView(SuccessMessageMixin, UpdateView):
    model = UserPost
    fields = ["name"]
    template_name = "core/dashboard/post_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    success_message = "Users Post Name Updated Successfully."

    def form_valid(self, form):
        messages.success(self.request, self.success_message)
        form.save()
        return JsonResponse({}, status=200)


def appraisal_review_request(request):
    p_appraisal_review_request = AppraisalReviewRequest.objects.filter(
        level__type__type="P"
    ).distinct("level")
    l_appraisal_review_request = AppraisalReviewRequest.objects.filter(
        level__type__type="L"
    ).distinct("level")
    context = {
        "p_appraisal_review_request": p_appraisal_review_request,
        "l_appraisal_review_request": l_appraisal_review_request,
    }
    return render(request, "core/dashboard/list_appraisal_review_request.html", context)


def level_appraisals(request, level_id):
    appraisals = AppraisalReviewRequest.objects.filter(level_id=level_id)
    level = Level.objects.get(id=level_id)
    context = {"appraisals": appraisals, "level": level}
    return render(request, "core/dashboard/level_appraisals.html", context)


def appraisal_review_request_detail(request, appraisal_id):
    appraisal = AppraisalReviewRequest.objects.get(id=appraisal_id)
    data = appraisal.to_json()
    return JsonResponse(data)


def mark_appraisal_checked(request, appraisal_id):
    if request.method == "POST":
        AppraisalReviewRequest.objects.filter(id=appraisal_id).update(is_checked=True)
        messages.success(request, "Checked Successfully.")
        return redirect(
            request.META.get("HTTP_REFERER", "dashboard:list_appraisal_review_request")
        )


class DistrictNameUpdateView(SuccessMessageMixin, UpdateView):
    model = District
    fields = ["name_eng", "name_np"]
    template_name = "core/dashboard/district_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    success_message = "District Name Updated Successfully."

    def form_valid(self, form):
        messages.success(self.request, self.success_message)
        form.save()
        return JsonResponse({}, status=200)

class FiscalYearUpdateView(SuccessMessageMixin, UpdateView):
    model = FiscalYear
    fields = ["name", "start_date_bs", "end_date_bs", "active_fy"]
    template_name = "core/dashboard/fiscalyear_update.html"
    success_url = reverse_lazy("dashboard:master_configuration")
    success_message = "Fiscal Year Updated Successfully."
    context_object_name = 'fiscal'


class SettingsView(LoginRequiredMixin, TemplateView):
    template_name = "core/dashboard/settings.html"