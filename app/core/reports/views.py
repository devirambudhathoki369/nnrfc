import io

import xlsxwriter
from core.models import FillSurvey, FiscalYear, Question, Survey
from core.utils import get_answer
from django.http.response import HttpResponse, JsonResponse
from django.shortcuts import render
from user_mgmt.models import Level
from core.utils import MONTH_DATA

MONTH_ORDER_REPORT = [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3]


def filter_local_levels(request, p_id):
    province = Level.objects.get(id=p_id)
    local_levels = province.child_level.all().order_by("name")
    l_levels = list(local_levels.values("id", "name"))
    return JsonResponse({"l_levels": l_levels})


def reports_view(request):
    fiscal_yrs = FiscalYear.objects.all().order_by("-start_date_bs")
    provinces = Level.objects.filter(type__type="P")

    fy          = request.GET.get("fy", "")
    survey_param = request.GET.get("survey", "")   # pk OR "all"
    level       = request.GET.get("level", "")     # pk OR "all"
    local_level = request.GET.get("local_level", "")

    # ── Surveys dropdown: filter by fiscal year when one is chosen ──
    if fy:
        surveys = Survey.objects.filter(fiscal_year_id=fy)
    else:
        surveys = Survey.objects.all()

    # ── Effective level for export URLs ──
    effective_level_id = local_level if local_level else level
    level_type = "P"
    export_level_type = ""
    export_province_id = ""
    survey_label = ""
    level_label  = ""

    # ── Resolve level_type from the effective level ──
    if effective_level_id and effective_level_id not in ("", "all", "0", 0):
        try:
            eff_level_obj = Level.objects.get(id=effective_level_id)
            level_type = eff_level_obj.type.type
            level_label = eff_level_obj.name
        except Level.DoesNotExist:
            pass
    elif level == "all":
        level_type = "P"
        level_label = "सबै प्रदेश"

    # ── Build questions list ──
    questions = []

    if survey_param and level:
        if survey_param == "all":
            # Collect questions from every survey under selected fiscal year
            fy_filter = {"fiscal_year_id": fy} if fy else {}
            target_surveys = Survey.objects.filter(**fy_filter)
            survey_label = "सबै सर्वेक्षण"
        else:
            try:
                survey_obj = Survey.objects.get(id=survey_param)
                # If single survey has its own level, use that for level_type fallback
                if not effective_level_id or effective_level_id in ("", "0", 0):
                    level_type = survey_obj.level
                target_surveys = [survey_obj]
                survey_label = survey_obj.name or str(survey_obj)
                if (
                    survey_obj.level == "L"
                    and level
                    and level not in ("", "all", "0", 0)
                    and not local_level
                ):
                    export_level_type = "L"
                    export_province_id = level
                    level_label = "स्थानीय तहहरु"
            except Survey.DoesNotExist:
                target_surveys = []

        for s in target_surveys:
            qs = (
                s.questions
                .filter(parent=None)
                .order_by("sequence_id")
                .distinct()
            )
            questions.extend(list(qs))

    context = {
        "fiscal_yrs":       fiscal_yrs,
        "surveys":          surveys,
        "provinces":        provinces,
        "questions":        questions,
        # preserve selections for template
        "yr_id":            fy,
        "survey_id":        survey_param,
        "level_id":         level,
        "local_level_id":   local_level,
        "level_type":       level_type,
        "survey_label":     survey_label,
        "level_label":      level_label,
        "effective_level_id": effective_level_id,
        "export_level_type": export_level_type,
        "export_province_id": export_province_id,
    }
    return render(request, "core/reports/report.html", context)


# ── xlsx helpers ──────────────────────────────────────────────────────────────

def keep_only_child_question(all_data):
    prev_q = ""
    for lst in all_data:
        if prev_q == lst[0]:
            lst[0] = ""
        else:
            prev_q = lst[0]
    return all_data


def write_to_xlsx(ws, header_data, header_format, row_data):
    for i, j in enumerate(header_data):
        ws.write(1, i, j, header_format)
    for row_num, columns in enumerate(row_data):
        for col_num, cell_data in enumerate(columns):
            ws.write(row_num + 2, col_num, cell_data)


# ── Single-level export ───────────────────────────────────────────────────────

def export_reports(request, q_id, level_id):
    output = io.BytesIO()
    workbook = xlsxwriter.Workbook(output)
    worksheet = workbook.add_worksheet()
    data = []
    question = Question.objects.get(id=q_id)
    level = Level.objects.get(id=level_id)
    childs = question.children_questions.all()
    merge_format = workbook.add_format(
        {"bold": 1, "border": 1, "align": "center", "valign": "vcenter", "fg_color": "yellow"}
    )
    header_format = workbook.add_format({"bold": True})
    worksheet.set_column("A:A", 60)
    worksheet.set_column("B:B", 40)

    if question.month_requires:
        options = question.options.exclude(field_type="F").order_by("sequence_id")
        for i in MONTH_ORDER_REPORT:
            month_option_data = []
            for option in options:
                opt_ans = get_answer(option.id, level_id, i)
                month_option_data.append(opt_ans.value if opt_ans else None)
            data.append([MONTH_DATA[i]] + month_option_data)
        header_data = ["महिना"] + [o.title for o in options]
        write_to_xlsx(worksheet, header_data, header_format, data)
        worksheet.merge_range("A1:B1", f"{question.title}, {level.name}", merge_format)

    else:
        if not childs:
            options = question.options.exclude(field_type="F")
            for option in options:
                opt_ans = get_answer(option.id, level_id)
                data.append([option.title, opt_ans.value if opt_ans else None])
            write_to_xlsx(worksheet, ["Option", "Value"], header_format, data)
            worksheet.merge_range("A1:B1", f"{question.title}, {level.name}", merge_format)
        else:
            for q in childs:
                options = q.options.exclude(field_type="F")
                for option in options:
                    opt_ans = get_answer(option.id, level_id)
                    data.append([q.title, option.title, opt_ans.value if opt_ans else None])
            worksheet.set_column("A:A", 65)
            worksheet.set_column("C:C", 30)
            data = keep_only_child_question(data)
            write_to_xlsx(worksheet, ["सूचक", "Option", "Value"], header_format, data)
            worksheet.merge_range("A1:C1", f"{question.title}, {level.name}", merge_format)

    workbook.close()
    output.seek(0)
    filename = f"{question.title} reports.xlsx"
    response = HttpResponse(
        output,
        content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )
    response["Content-Disposition"] = f"attachment; filename={filename}"
    return response


# ── All-levels export ─────────────────────────────────────────────────────────

def export_reports_all_levels(request, q_id, level_type):
    output = io.BytesIO()
    workbook = xlsxwriter.Workbook(output)
    worksheet = workbook.add_worksheet()
    data = []
    question = Question.objects.get(id=q_id)
    childs = question.children_questions.all()
    merge_format = workbook.add_format(
        {"bold": 1, "border": 1, "align": "center", "valign": "vcenter", "fg_color": "yellow"}
    )
    header_format = workbook.add_format({"bold": True})
    worksheet.set_column("A:H", 20)

    options = question.options.exclude(field_type="F").order_by("sequence_id")
    levels = Level.objects.filter(type__type__contains=level_type)
    is_local = level_type == "L"
    province_id = request.GET.get("province_id")

    if is_local and province_id:
        levels = levels.filter(province_level_id=province_id)

    if question.month_requires:
        for i in MONTH_ORDER_REPORT:
            for level in levels:
                month_option_data = [
                    get_answer(o.id, level.id, i).value
                    if get_answer(o.id, level.id, i) else None
                    for o in options
                ]
                base = [MONTH_DATA[i], level.name]
                if is_local:
                    base = [
                        MONTH_DATA[i],
                        level.province_level.name if level.province_level else "",
                        level.name,
                        level.level_code,
                        level.district.name_np if level.district else "",
                    ]
                data.append(base + month_option_data)

        header_data = (
            ["महिना", "प्रदेश", "स्थानीय तहको नाम", "स्थानीय तहको कोड", "जिल्ला"]
            if is_local else ["महिना", "प्रदेश/स्थानीय तह"]
        )
        header_data += [o.title for o in options]
        write_to_xlsx(worksheet, header_data, header_format, data)
        worksheet.merge_range("A1:B1", question.title, merge_format)

    else:
        for level in levels:
            level_option_data = [
                get_answer(o.id, level.id).value if get_answer(o.id, level.id) else None
                for o in options
            ]
            base = [level.name]
            if is_local:
                base = [
                    level.province_level.name if level.province_level else "",
                    level.name,
                    level.level_code,
                    level.district.name_np if level.district else "",
                ]
            data.append(base + level_option_data)

        header_data = (
            ["प्रदेश", "स्थानीय तह", "स्थानीय तहको कोड", "जिल्ला"]
            if is_local else ["प्रदेश/स्थानीय तह"]
        )
        header_data += [o.title for o in options]
        write_to_xlsx(worksheet, header_data, header_format, data)
        worksheet.merge_range("A1:B1", question.title, merge_format)

    workbook.close()
    output.seek(0)
    filename = f"{question.title} reports.xlsx"
    response = HttpResponse(
        output,
        content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )
    response["Content-Disposition"] = f"attachment; filename={filename}"
    return response
