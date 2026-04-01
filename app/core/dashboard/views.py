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

    # ─────────────────────────────────────────────────────────────────
    # Per-level fill progress (admin: see each level's submission status)
    # ─────────────────────────────────────────────────────────────────

    def _build_per_level_progress(self, fiscal, level_type, province_filter=None):
        """
        For each level return how many questions they filled out of total.
        Uses bulk queries — no N+1 problem.
        Returns (list of dicts, total_questions)
        """
        surveys = Survey.objects.filter(fiscal_year=fiscal, level=level_type)
        questions = list(
            Question.objects.filter(survey__in=surveys, parent__isnull=True)
            .values_list('id', flat=True)
        )
        total_questions = len(questions)
        if not questions:
            return [], 0

        levels_qs = Level.objects.filter(type__type=level_type).order_by('name')
        if province_filter:
            levels_qs = levels_qs.filter(province_level=province_filter)        
        levels = list(levels_qs)
        if not levels:
            return [], 0

        child_rows = Question.objects.filter(
            parent_id__in=questions
        ).values_list('parent_id', 'id')
        child_map = {}
        for parent_id, child_id in child_rows:
            child_map.setdefault(parent_id, []).append(child_id)

        source_ids = []
        for q_id in questions:
            source_ids.extend(child_map.get(q_id, [q_id]))

        opt_rows = Option.objects.filter(
            question_id__in=source_ids
        ).values_list('id', 'question_id')
        src_to_opts = {}
        all_opt_ids = set() 
        for opt_id, q_id in opt_rows:
            src_to_opts.setdefault(q_id, set()).add(opt_id)
            all_opt_ids.add(opt_id)

        q_opt_ids = {}
        for q_id in questions:
            srcs = child_map.get(q_id, [q_id])
            opts = set()
            for src_id in srcs:
                opts.update(src_to_opts.get(src_id, set()))
            q_opt_ids[q_id] = opts

        level_id_set = {lv.id for lv in levels}
        filled_pairs = set(
            Answer.objects.filter(
                option_id__in=all_opt_ids,
                created_by_level_id__in=level_id_set,
            ).values_list('option_id', 'created_by_level_id')
        )

        results = []
        for lv in levels:
            filled = 0
            for q_id in questions:
                for opt_id in q_opt_ids.get(q_id, set()):
                    if (opt_id, lv.id) in filled_pairs:
                        filled += 1
                        break
            pct = round((filled / total_questions * 100), 1) if total_questions > 0 else 0
            results.append({
                'level': lv,
                'filled': filled,
                'remaining': total_questions - filled,
                'total': total_questions,
                'percentage': pct,
            })

        return results, total_questions

    # ─────────────────────────────────────────────────────────────────
    # OPTIMIZED CORE METHOD: Build question status using BULK queries
    # Old: 7 questions × 759 levels = 5,313 DB queries
    # New: ~5 DB queries total regardless of data size
    # ─────────────────────────────────────────────────────────────────

    def _build_question_status_all(self, fiscal, level_type, province_filter=None):
        """
        Get fill status for ALL questions across ALL surveys for a level type.
        Uses bulk queries — no N+1 problem.
        """
        # 1. Get all surveys and questions (1 query each)
        surveys = Survey.objects.filter(fiscal_year=fiscal, level=level_type)
        questions = list(
            Question.objects.filter(survey__in=surveys, parent__isnull=True)
            .select_related('survey', 'department')
            .order_by("survey__name", "sequence_id")
        )

        if not questions:
            return [], 0, surveys

        # 2. Get all levels (1 query)
        levels_qs = Level.objects.filter(type__type=level_type)
        if province_filter:
            levels_qs = levels_qs.filter(province_level=province_filter)
        total_levels = levels_qs.count()
        level_id_set = set(levels_qs.values_list('id', flat=True))

        if total_levels == 0:
            return [], 0, surveys

        question_ids = [q.id for q in questions]

        # 3. Get ALL child question IDs in one query
        child_rows = Question.objects.filter(
            parent_id__in=question_ids
        ).values_list('parent_id', 'id')

        child_map = {}
        for parent_id, child_id in child_rows:
            child_map.setdefault(parent_id, []).append(child_id)

        # 4. Get ALL option IDs grouped by question — collect which
        #    question IDs to query (children if exist, else self)
        query_question_ids = []
        q_to_source = {}  # question_id → list of source question_ids for options

        for q in questions:
            if q.id in child_map:
                source_ids = child_map[q.id]
            else:
                source_ids = [q.id]
            q_to_source[q.id] = source_ids
            query_question_ids.extend(source_ids)

        # One query: get all options for all relevant questions
        option_rows = Option.objects.filter(
            question_id__in=query_question_ids
        ).values_list('id', 'question_id')

        # Build: question_id → set of option_ids
        source_to_options = {}
        all_option_ids = set()
        for opt_id, q_id in option_rows:
            source_to_options.setdefault(q_id, set()).add(opt_id)
            all_option_ids.add(opt_id)

        # Map parent question → its option IDs
        q_option_map = {}
        for q in questions:
            opts = set()
            for src_id in q_to_source[q.id]:
                opts.update(source_to_options.get(src_id, set()))
            q_option_map[q.id] = opts

        # 5. ONE BIG QUERY: get all (option_id, level_id) answer pairs
        filled_pairs = set(
            Answer.objects.filter(
                option_id__in=all_option_ids,
                created_by_level_id__in=level_id_set,
            ).values_list('option_id', 'created_by_level_id')
        )

        # 6. Count in Python (instant — just set lookups)
        data = []
        for q in questions:
            opt_ids = q_option_map.get(q.id, set())
            # Find which levels answered at least one option of this question
            filled_level_ids = set()
            for level_id in level_id_set:
                for opt_id in opt_ids:
                    if (opt_id, level_id) in filled_pairs:
                        filled_level_ids.add(level_id)
                        break  # This level is filled, skip remaining options

            fc = len(filled_level_ids)
            data.append({
                "question": q,
                "survey_name": q.survey.name,
                "filled_count": fc,
                "not_filled_count": total_levels - fc,
                "total": total_levels,
                "percentage": round((fc / total_levels * 100), 1) if total_levels > 0 else 0,
            })

        return data, total_levels, surveys

    # ─────────────────────────────────────────────────────────────────
    # OPTIMIZED: Get my progress across ALL surveys
    # ─────────────────────────────────────────────────────────────────

    def _get_my_progress(self, user, fiscal):
        """
        Get fill progress for current user across ALL their surveys.
        Uses bulk queries.
        """
        try:
            level_type = user.level.type.type
            user_level_id = user.level.id
        except AttributeError:
            return 0, 0, 0

        surveys = Survey.objects.filter(fiscal_year=fiscal, level=level_type)

        # Get questions (filtered by department for province users)
        q_filter = {"survey__in": surveys, "parent__isnull": True}
        if user.department and level_type == "P":
            q_filter["department"] = user.department

        questions = list(Question.objects.filter(**q_filter).values_list('id', flat=True))
        total = len(questions)
        if total == 0:
            return 0, 0, 0

        # Get child map in one query
        child_map = {}
        for parent_id, child_id in Question.objects.filter(
            parent_id__in=questions
        ).values_list('parent_id', 'id'):
            child_map.setdefault(parent_id, []).append(child_id)

        # Get source question IDs for options
        source_ids = []
        q_to_source = {}
        for q_id in questions:
            srcs = child_map.get(q_id, [q_id])
            q_to_source[q_id] = srcs
            source_ids.extend(srcs)

        # Get all option IDs in one query
        opt_rows = Option.objects.filter(
            question_id__in=source_ids
        ).values_list('id', 'question_id')

        src_to_opts = {}
        all_opts = set()
        for opt_id, q_id in opt_rows:
            src_to_opts.setdefault(q_id, set()).add(opt_id)
            all_opts.add(opt_id)

        # Get all answered option IDs for this user's level in one query
        answered_opts = set(
            Answer.objects.filter(
                option_id__in=all_opts,
                created_by_level_id=user_level_id,
            ).values_list('option_id', flat=True)
        )

        # Count filled questions
        filled = 0
        for q_id in questions:
            opts = set()
            for src_id in q_to_source[q_id]:
                opts.update(src_to_opts.get(src_id, set()))
            if opts & answered_opts:  # Set intersection — any match = filled
                filled += 1

        pct = round((filled / total * 100), 1)
        return total, filled, pct

    def _build_level_question_completion(self, user, fiscal):
        """
        Build per-question completion status for the current user's level.
        """
        try:
            user_level = user.level
            level_type = user_level.type.type
        except AttributeError:
            return [], 0, 0

        q_filter = {
            "survey__fiscal_year": fiscal,
            "survey__level": level_type,
            "parent__isnull": True,
        }
        if user.department and level_type == "P":
            q_filter["department"] = user.department

        questions = list(
            Question.objects.filter(**q_filter)
            .select_related("survey", "department")
            .order_by("survey__name", "sequence_id")
        )
        if not questions:
            return [], 0, 0

        question_ids = [q.id for q in questions]
        child_map = {}
        for parent_id, child_id in Question.objects.filter(
            parent_id__in=question_ids
        ).values_list("parent_id", "id"):
            child_map.setdefault(parent_id, []).append(child_id)

        source_ids = []
        q_to_source = {}
        for q in questions:
            srcs = child_map.get(q.id, [q.id])
            q_to_source[q.id] = srcs
            source_ids.extend(srcs)

        source_to_opts = {}
        all_option_ids = set()
        for opt_id, q_id in Option.objects.filter(
            question_id__in=source_ids
        ).values_list("id", "question_id"):
            source_to_opts.setdefault(q_id, set()).add(opt_id)
            all_option_ids.add(opt_id)

        answered_opts = set()
        if all_option_ids:
            answered_opts = set(
                Answer.objects.filter(
                    option_id__in=all_option_ids,
                    created_by_level_id=user_level.id,
                ).values_list("option_id", flat=True)
            )

        rows = []
        filled_count = 0
        for q in questions:
            option_ids = set()
            for src_id in q_to_source[q.id]:
                option_ids.update(source_to_opts.get(src_id, set()))
            is_completed = bool(option_ids and option_ids & answered_opts)
            if is_completed:
                filled_count += 1
            rows.append(
                {
                    "question": q,
                    "survey_name": q.survey.name,
                    "is_completed": is_completed,
                }
            )

        return rows, len(rows), filled_count

    # ─────────────────────────────────────────────────────────────────
    # Helper: Get corrections with remarks
    # ─────────────────────────────────────────────────────────────────

    def _get_my_corrections_with_remarks(self, user_level):
        return SurveyCorrection.objects.filter(
            level=user_level
        ).select_related('question', 'user').order_by("-created_at")[:10]

    # ─────────────────────────────────────────────────────────────────
    # Helper: Get relevant surveys for user
    # ─────────────────────────────────────────────────────────────────

    def _get_relevant_surveys(self, fiscal, user):
        try:
            level_type = user.level.type.type
        except AttributeError:
            return Survey.objects.none()

        surveys = Survey.objects.filter(fiscal_year=fiscal, level=level_type)

        if user.department and level_type == "P":
            survey_ids = Question.objects.filter(
                department=user.department,
                survey__in=surveys,
                parent__isnull=True,
            ).values_list('survey_id', flat=True).distinct()
            surveys = surveys.filter(id__in=survey_ids)

        return surveys

    # ─────────────────────────────────────────────────────────────────
    # MAIN: get_context_data
    # ─────────────────────────────────────────────────────────────────

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user

        # Active fiscal year
        fiscal = FiscalYear.objects.filter(active_fy=True).first()
        if not fiscal:
            context["error"] = "कुनै सक्रिय आर्थिक वर्ष फेला परेन।"
            return context

        context["fiscal_year"] = fiscal

        # User level info
        try:
            user_level = user.level
            user_level_type = user_level.type.type if user_level else None
        except AttributeError:
            user_level = None
            user_level_type = None

        # User's surveys for quick actions
        context["my_surveys"] = self._get_relevant_surveys(fiscal, user)

        # ════════════════════════════════════════
        # ADMIN / SUPERUSER / OFFICE HEAD
        # ════════════════════════════════════════
        if user.is_superuser or getattr(user, "is_office_head", False):
            context["user_type"] = "admin"
            context["province_count"] = Level.objects.filter(type__type="P").count()
            context["local_count"] = Level.objects.filter(type__type="L").count()

            # All questions across all surveys — bulk optimized
            l_status, l_total, l_surveys = self._build_question_status_all(fiscal, "L")
            p_status, p_total, p_surveys = self._build_question_status_all(fiscal, "P")

            context["l_question_status"] = l_status
            context["l_total_levels"] = l_total
            context["p_question_status"] = p_status
            context["p_total_levels"] = p_total
            context["count"] = len(l_status) + len(p_status)
            context["province_question_count"] = len(p_status)
            context["local_question_count"] = len(l_status)

            context["recent_corrections"] = (
                SurveyCorrection.objects
                .select_related('level', 'user', 'question')
                .order_by("-created_at")[:5]
            )

            # Per-level fill progress for admin
            p_level_progress, _ = self._build_per_level_progress(fiscal, "P")
            l_level_progress, _ = self._build_per_level_progress(fiscal, "L")
            context["p_level_progress"] = p_level_progress
            context["l_level_progress"] = l_level_progress

            return context

        # ════════════════════════════════════════
        # PROVINCE USER
        # ════════════════════════════════════════
        if user_level_type == "P":
            context["user_type"] = "province"
            context["user_level"] = user_level
            context["province_name"] = user_level.name

            # My progress across all surveys — bulk optimized
            total, filled, pct = self._get_my_progress(user, fiscal)
            context["count"] = total
            context["my_filled"] = filled
            context["my_progress"] = pct
            context["my_remaining"] = total - filled  # NEW: remaining count

            # Department name for display
            if user.department:
                context["user_department_name"] = user.department.name  # NEW

            # Corrections with remarks
            context["my_corrections"] = self._get_my_corrections_with_remarks(user_level)

            # Complaints
            context["my_complaints"] = Complaint.objects.filter(
                level=user_level
            ).order_by("-created_at")[:5]

            # Province user's own suchak completion, filtered by department
            province_question_rows, province_total, province_filled = (
                self._build_level_question_completion(user, fiscal)
            )
            context["province_question_rows"] = province_question_rows
            context["count"] = province_total
            context["my_filled"] = province_filled
            context["my_remaining"] = province_total - province_filled

            # Department-specific suchak
            if user.department:
                context["my_suchak"] = (
                    Question.objects.filter(
                        department=user.department,
                        survey__fiscal_year=fiscal,
                        survey__level="P",
                        parent__isnull=True,
                    )
                    .select_related('survey', 'department')
                    .order_by("survey__name", "sequence_id")
                )

            # Local levels under this province — bulk optimized
            l_status, l_total, _ = self._build_question_status_all(
                fiscal, "L", province_filter=user_level
            )
            context["l_question_status"] = l_status
            context["l_total_levels"] = l_total

            # Questions for evaluation complaint (punarbalokan) dropdown
            province_eval_questions = Question.objects.filter(
                survey__fiscal_year=fiscal,
                survey__level="P",
                parent__isnull=True,
            )
            if user.department:
                province_eval_questions = province_eval_questions.filter(
                    department=user.department
                )
            context["eval_questions"] = province_eval_questions.order_by(
                "survey__name", "sequence_id"
            )

            return context

        # ════════════════════════════════════════
        # LOCAL LEVEL USER
        # ════════════════════════════════════════
        if user_level_type == "L":
            context["user_type"] = "local"
            context["user_level"] = user_level
            context["province_name"] = (
                user_level.province_level.name if user_level.province_level else ""
            )

            # My progress across all surveys — bulk optimized
            total, filled, pct = self._get_my_progress(user, fiscal)
            context["count"] = total
            context["my_filled"] = filled
            context["my_progress"] = pct
            context["my_remaining"] = total - filled

            # Corrections with remarks
            context["my_corrections"] = self._get_my_corrections_with_remarks(user_level)

            # Complaints
            context["my_complaints"] = Complaint.objects.filter(
                level=user_level
            ).order_by("-created_at")[:5]

            # All suchak for local level
            context["my_suchak"] = (
                Question.objects.filter(
                    survey__fiscal_year=fiscal,
                    survey__level="L",
                    parent__isnull=True,
                )
                .select_related('survey', 'department')
                .order_by("survey__name", "sequence_id")
            )
            local_question_rows, local_total, local_filled = self._build_level_question_completion(
                user, fiscal
            )
            context["local_question_rows"] = local_question_rows
            context["count"] = local_total
            context["my_filled"] = local_filled
            context["my_remaining"] = local_total - local_filled

            # Questions for evaluation complaint (punarbalokan) dropdown
            context["eval_questions"] = (
                Question.objects.filter(
                    survey__fiscal_year=fiscal,
                    survey__level="L",
                    parent__isnull=True,
                )
                .order_by("survey__name", "sequence_id")
            )

            return context

        # ════════════════════════════════════════
        # STAFF (no level, has roles)
        # ════════════════════════════════════════
        if user.is_staff:
            context["user_type"] = "staff"

            p_status, p_total, _ = self._build_question_status_all(fiscal, "P")
            context["p_question_status"] = p_status
            context["p_total_levels"] = p_total
            context["province_count"] = Level.objects.filter(type__type="P").count()
            context["count"] = len(p_status)
            return context

        # ════════════════════════════════════════
        # FALLBACK
        # ════════════════════════════════════════
        context["error"] = "तपाईंको खाता कुनै तहसँग जोडिएको छैन।"
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
        ques = form.save(commit=False)
        department_id = self.request.POST.get("department")
        full_marks = self.request.POST.get("full_marks")
        if department_id:
            ques.department_id = department_id
        if full_marks:
            ques.full_marks = full_marks
        ques.save()
        success_url = reverse("dashboard:index_option_create", args=[ques.id])
        messages.success(self.request, "Index Added Successfully.")
        return JsonResponse({"success": True, "url": success_url})


class SurveyDetailView(DetailView):
    model = Survey
    template_name = "core/dashboard/survey_detail.html"
    context_object_name = "survey"
    pk_url_kwarg = "survey_id"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["departments"] = Department.objects.all()
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
    fields = ["title", "month_requires", "sequence_id", "department", "full_marks"]

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


class SurveyUpdateView(UpdateView):
    model = Survey
    template_name = "core/dashboard/survey_update.html"
    fields = ["name", "fiscal_year"]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["f_years"] = FiscalYear.objects.all().order_by("start_date")
        return context

    def form_valid(self, form):
        survey = form.save()
        messages.success(self.request, "Saved Successfully.")
        return JsonResponse({"success": True, "url": reverse("dashboard:home")})

    def form_invalid(self, form):
        return JsonResponse(form.errors, status=400)


class SurveyDeleteView(DeleteView):
    model = Survey

    def post(self, request, **kwargs):
        survey = self.get_object()
        survey.delete()
        messages.success(self.request, "Deleted Successfully.")
        return redirect("dashboard:home")


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
    """
    View for admin/staff to fix a correction request.
    - Shows correction details with all attached files
    - Filters answers by the correction's month (not just any month)
    - Sends exactly one notification per correction
    """
    question   = get_object_or_404(Question, id=ques_id)
    correction = get_object_or_404(SurveyCorrection, id=correction_id)
    level      = correction.level
 
    # ── Get the correct month from the correction ────────────────
    correction_month = correction.month  # Could be None for non-monthly questions
 
    # ── Get options with answers filtered by CORRECT month ───────
    options = question.options.all().order_by("sequence_id")
 
    # We need to rebuild options_data with month filtering
    # instead of using get_options_with_field_types which doesn't filter by month
    from core.utils import OPTION_FIELD_INPUT_TYPE, OPTION_FIELD_INDICATOR
    from core.models import CorrectionDocument
 
    options_data = []
    fill_survey = FillSurvey.objects.filter(
        survey=question.survey, level_id=level
    ).first()
 
    for option in options:
        option_dict = {
            "option": option,
            "input_type": OPTION_FIELD_INPUT_TYPE.get(option.field_type, "text"),
            "field_indicator": OPTION_FIELD_INDICATOR.get(option.field_type, ""),
            "field_type": option.field_type,
        }
 
        # Get answer filtered by month
        answer = None
        document = None
        if fill_survey:
            if correction_month:
                answer = Answer.objects.filter(
                    option=option, fill_survey=fill_survey, month=correction_month
                ).first()
            else:
                answer = Answer.objects.filter(
                    option=option, fill_survey=fill_survey
                ).first()
 
        option_dict["answer"] = answer
 
        # Get document for file-type options
        if option.field_type == "F" and answer:
            document = AnswerDocument.objects.filter(answer=answer).first()
 
        option_dict["document"] = document
 
        # Fiscal year data for FY-type options
        if option.field_type == "FY":
            option_dict["fy_data"] = [
                {"id": fy.id, "name": fy.name}
                for fy in FiscalYear.objects.all()
            ]
 
        options_data.append(option_dict)
 
    # ── Get correction documents (new model) ─────────────────────
    correction_documents = CorrectionDocument.objects.filter(
        correction=correction
    ).order_by("-created_at")
 
    context = {
        "ques": question,
        "correction": correction,
        "options_data": options_data,
        "correction_documents": correction_documents,
    }
 
    if request.method == "POST":
        answer_ids = request.POST.getlist("ans_id")
        ans_values = request.POST.getlist("ans")
 
        with transaction.atomic():
            # Mark correction as checked
            correction.status = "C"
            remarks = request.POST.get("remarks", "")
            if remarks:
                correction.remarks = remarks
            correction.save()
 
            # Update answer values (only non-empty IDs)
            for a_id, v in zip(answer_ids, ans_values):
                if a_id:
                    Answer.objects.filter(id=a_id).update(value=v)
 
            # Update file if a new one was uploaded
            file_ans = request.POST.get("anss")
            file = request.FILES.get("new_file")
            if file_ans and file:
                AnswerDocument.objects.filter(answer_id=file_ans).update(document=file)
                Answer.objects.filter(id=file_ans).update(value=file.name)
 
            # Update activity logs
            q_options = correction.question.options.all().values_list("id", flat=True)
            CorrectionActivityLog.objects.filter(option_id__in=q_options).update(
                action_level=correction.level.name,
                action_level_type=correction.level.type.type,
            )
 
            # Send notification — EXACTLY ONCE
            Notification.objects.get_or_create(
                correction=correction,
                correction_checked=True,
                defaults={
                    "user": correction.user,
                    "msg": "तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।",
                    "level": level,
                    "is_viewed": False,
                },
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
    month_name_map = {
        1: "वैशाख",
        2: "ज्येष्ठ",
        3: "असार",
        4: "श्रावण",
        5: "भदौ",
        6: "असोज",
        7: "कार्तिक",
        8: "मंसिर",
        9: "पौष",
        10: "माघ",
        11: "फागुन",
        12: "चैत्र",
    }
    fiscal_month_order = {4: 1, 5: 2, 6: 3, 7: 4, 8: 5, 9: 6, 10: 7, 11: 8, 12: 9, 1: 10, 2: 11, 3: 12}

    def answer_display(answer):
        if not answer:
            return ""
        if answer.fiscal_year:
            return answer.fiscal_year.name
        return answer.value

    def build_option_rows(target_question, month_id=None):
        option_rows = []
        for option in target_question.options.exclude(field_type="F").order_by("sequence_id"):
            answer = (
                Answer.objects.filter(
                    option=option,
                    fill_survey__level_id=level_id,
                    month=month_id,
                ).order_by("-created_at").first()
                if month_id is not None
                else Answer.objects.filter(
                    option=option,
                    fill_survey__level_id=level_id,
                ).order_by("-created_at").first()
            )
            option_rows.append({
                "title": option.title,
                "value": answer_display(answer),
            })
        return option_rows

    def build_documents(target_question, month_id=None):
        doc_filter = {
            "answer__option__question": target_question,
            "answer__fill_survey__level_id": level_id,
        }
        if month_id is not None:
            doc_filter["answer__month"] = month_id
        return AnswerDocument.objects.filter(**doc_filter).distinct()

    month_sections = []
    if question.month_requires:
        relevant_questions = list(child_questions) if child_questions.exists() else [question]
        month_ids = list(
            Answer.objects.filter(
                option__question__in=relevant_questions,
                fill_survey__level_id=level_id,
                month__isnull=False,
            )
            .values_list("month", flat=True)
            .distinct()
        )
        month_ids = sorted(month_ids, key=lambda m: fiscal_month_order.get(m, 99))

        for month_id in month_ids:
            if child_questions.exists():
                child_sections = []
                for child in child_questions:
                    child_sections.append({
                        "title": child.title,
                        "option_rows": build_option_rows(child, month_id=month_id),
                        "documents": build_documents(child, month_id=month_id),
                    })
                month_sections.append({
                    "month": month_id,
                    "month_name": month_name_map.get(month_id, month_id),
                    "child_sections": child_sections,
                })
            else:
                month_sections.append({
                    "month": month_id,
                    "month_name": month_name_map.get(month_id, month_id),
                    "option_rows": build_option_rows(question, month_id=month_id),
                    "documents": build_documents(question, month_id=month_id),
                })

    context = {
        "q": question,
        "child_ques": child_questions,
        "level_id": level_id,
        "month_sections": month_sections,
        "option_rows": build_option_rows(question) if not child_questions.exists() else [],
        "documents": build_documents(question) if not child_questions.exists() else [],
        "child_sections": [
            {
                "title": child.title,
                "option_rows": build_option_rows(child),
                "documents": build_documents(child),
            }
            for child in child_questions
        ] if child_questions.exists() else [],
    }
    return render(
        request,
        "core/dashboard/filled_answers.html",
        context,
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



class QuestionWiseStatusView(LoginRequiredMixin, TemplateView):
    """
    Dashboard page showing question-wise fill status.
    For each question: how many levels filled it, how many didn't.
    Separate sections for Province (P) and Local (L) level surveys.
    """
    template_name = "core/dashboard/question_wise_status.html"
 
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
 
        # Get active fiscal year
        fiscal = FiscalYear.objects.filter(active_fy=True).first()
        if not fiscal:
            context["error"] = "कुनै सक्रिय आर्थिक वर्ष फेला परेन।"
            return context
 
        context["fiscal_year"] = fiscal
 
        # ── Province Level Survey ────────────────────────────────────
        p_survey = Survey.objects.filter(fiscal_year=fiscal, level="P").first()
        p_data = []
        if p_survey:
            p_questions = p_survey.questions.filter(parent__isnull=True).order_by("sequence_id")
            p_levels = Level.objects.filter(type__type="P")
            p_total = p_levels.count()
 
            for question in p_questions:
                filled_level_ids = self._get_filled_levels(question, p_levels)
                filled_count = len(filled_level_ids)
                not_filled_count = p_total - filled_count
 
                p_data.append({
                    "question": question,
                    "filled_count": filled_count,
                    "not_filled_count": not_filled_count,
                    "total": p_total,
                    "percentage": round((filled_count / p_total * 100), 1) if p_total > 0 else 0,
                })
 
        context["p_survey"] = p_survey
        context["p_data"] = p_data
        context["p_total_levels"] = Level.objects.filter(type__type="P").count()
 
        # ── Local Level Survey ───────────────────────────────────────
        l_survey = Survey.objects.filter(fiscal_year=fiscal, level="L").first()
        l_data = []
        if l_survey:
            l_questions = l_survey.questions.filter(parent__isnull=True).order_by("sequence_id")
            l_levels = Level.objects.filter(type__type="L")
            l_total = l_levels.count()
 
            for question in l_questions:
                filled_level_ids = self._get_filled_levels(question, l_levels)
                filled_count = len(filled_level_ids)
                not_filled_count = l_total - filled_count
 
                l_data.append({
                    "question": question,
                    "filled_count": filled_count,
                    "not_filled_count": not_filled_count,
                    "total": l_total,
                    "percentage": round((filled_count / l_total * 100), 1) if l_total > 0 else 0,
                })
 
        context["l_survey"] = l_survey
        context["l_data"] = l_data
        context["l_total_levels"] = Level.objects.filter(type__type="L").count()
 
        return context
 
    def _get_filled_levels(self, question, levels):
        """
        Returns set of level IDs that have filled this question.
        Checks child questions if they exist.
        """
        filled_ids = set()
        children = Question.objects.filter(parent=question.id)
 
        if children.exists():
            # Has child questions — check child options
            child_options = Option.objects.filter(question__in=children)
        else:
            # No children — check own options
            child_options = question.options.all()
 
        for level in levels:
            if Answer.objects.filter(
                option__in=child_options,
                created_by_level=level.id
            ).exists():
                filled_ids.add(level.id)
 
        return filled_ids
 
 
class QuestionFillDetailView(LoginRequiredMixin, TemplateView):
    """
    Shows which levels filled / didn't fill a specific question.
    URL: /dashboard/question-fill-detail/<question_id>/<status>/
    status = "filled" or "not_filled"
    """
    template_name = "core/dashboard/question_fill_detail.html"
 
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("question_id")
        status = self.kwargs.get("status")  # "filled" or "not_filled"
 
        question = get_object_or_404(Question, pk=question_id)
        context["question"] = question
        context["status"] = status
 
        # Determine which level type this question's survey targets
        survey_level = question.survey.level  # "P" or "L"
        all_levels = Level.objects.filter(type__type=survey_level)
 
        # Find which levels have filled this question
        children = Question.objects.filter(parent=question.id)
        if children.exists():
            child_options = Option.objects.filter(question__in=children)
        else:
            child_options = question.options.all()
 
        filled_level_ids = set()
        for level in all_levels:
            if Answer.objects.filter(
                option__in=child_options,
                created_by_level=level.id
            ).exists():
                filled_level_ids.add(level.id)
 
        if status == "filled":
            context["levels"] = all_levels.filter(id__in=filled_level_ids)
            context["title"] = "भरेका कार्यालयहरु"
        else:
            context["levels"] = all_levels.exclude(id__in=filled_level_ids)
            context["title"] = "नभरेका कार्यालयहरु"
 
        context["filled_count"] = len(filled_level_ids)
        context["not_filled_count"] = all_levels.count() - len(filled_level_ids)
 
        return context
 
 
class LevelQuestionAnswerView(LoginRequiredMixin, TemplateView):
    """
    Shows actual answers submitted by a specific level for a specific question.
    URL: /dashboard/level-answer/<question_id>/<level_id>/
    """
    template_name = "core/dashboard/level_question_answer.html"
 
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        question_id = self.kwargs.get("question_id")
        level_id = self.kwargs.get("level_id")
 
        question = get_object_or_404(Question, pk=question_id)
        level = get_object_or_404(Level, pk=level_id)
 
        context["question"] = question
        context["level"] = level
 
        # Get fill survey for this level
        fill_survey = FillSurvey.objects.filter(
            survey=question.survey, level_id=level
        ).first()
 
        if not fill_survey:
            context["answers"] = []
            context["child_answers"] = []
            return context
 
        children = Question.objects.filter(parent=question.id).order_by("sequence_id")
 
        if children.exists():
            # Has child questions
            child_answers = []
            for child in children:
                options = child.options.all().exclude(field_type="F").order_by("sequence_id")
                option_answers = []
                for option in options:
                    answer = Answer.objects.filter(
                        option=option, fill_survey=fill_survey
                    ).first()
                    option_answers.append({
                        "option_title": option.title,
                        "field_type": option.get_field_type_display(),
                        "value": answer.value if answer else "—",
                    })
 
                # Get files
                file_options = child.options.filter(field_type="F")
                files = []
                for fo in file_options:
                    ans = Answer.objects.filter(option=fo, fill_survey=fill_survey).first()
                    if ans:
                        docs = AnswerDocument.objects.filter(answer=ans)
                        files.extend(docs)
 
                child_answers.append({
                    "child_question": child,
                    "option_answers": option_answers,
                    "files": files,
                })
            context["child_answers"] = child_answers
            context["has_child"] = True
        else:
            # No children — show parent's answers
            options = question.options.all().exclude(field_type="F").order_by("sequence_id")
            answers = []
            for option in options:
                answer = Answer.objects.filter(
                    option=option, fill_survey=fill_survey
                ).first()
                answers.append({
                    "option_title": option.title,
                    "field_type": option.get_field_type_display(),
                    "value": answer.value if answer else "—",
                })
 
            # Get files
            file_options = question.options.filter(field_type="F")
            files = []
            for fo in file_options:
                ans = Answer.objects.filter(option=fo, fill_survey=fill_survey).first()
                if ans:
                    docs = AnswerDocument.objects.filter(answer=ans)
                    files.extend(docs)
 
            context["answers"] = answers
            context["files"] = files
            context["has_child"] = False
 
        return context
