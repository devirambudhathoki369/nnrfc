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
    fiscal_yrs = FiscalYear.objects.all()
    surveys = Survey.objects.all()
    provinces = Level.objects.filter(type__type="P")
    fy = request.GET.get("fy", 0)
    survey = request.GET.get("survey", None)
    level = request.GET.get("level", 0)
    local_level = request.GET.get("local_level", 0)
    level_type = "P"
    if survey:
        survey_obj = Survey.objects.get(id=survey)
        level_type = survey_obj.level
    if local_level != 0:
        level = local_level

    questions = Question.objects.filter(
        survey_id=survey,
        survey__fiscal_year_id=fy,
        parent=None,
        # options__answers__fill_survey__level_id_id=level,
    ).order_by("sequence_id").distinct()
    context = {
        "fiscal_yrs": fiscal_yrs,
        "surveys": surveys,
        "provinces": provinces,
        "questions": questions,
        "yr_id": int(fy),
        "survey_id": survey,
        "level_id": level,
        "level_type": level_type,
    }

    return render(request, "core/reports/report.html", context)


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


def export_reports(request, q_id, level_id):
    # to be optimized
    output = io.BytesIO()
    workbook = xlsxwriter.Workbook(output)
    worksheet = workbook.add_worksheet()
    data = []
    question = Question.objects.get(id=q_id)
    level = Level.objects.get(id=level_id)
    childs = question.children_questions.all()
    merge_format = workbook.add_format(
        {
            "bold": 1,
            "border": 1,
            "align": "center",
            "valign": "vcenter",
            "fg_color": "yellow",
        }
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
                if opt_ans:
                    value = opt_ans.value
                else:
                    value = None
                month_option_data.append(value)
            opt_value = [MONTH_DATA[i]]
            opt_value = opt_value + month_option_data

            data.append(opt_value)

        option_header = [option.title for option in options]
        header_data = ["महिना"]
        header_data = header_data + option_header
        write_to_xlsx(worksheet, header_data, header_format, data)
        question_level = f"{question.title}, {level.name}"
        worksheet.merge_range("A1:B1", f"{question_level}", merge_format)
    else:
        if not childs:
            options = question.options.exclude(field_type="F")
            for option in options:
                title = option.title
                opt_ans = get_answer(option.id, level_id)
                if opt_ans:
                    value = opt_ans.value
                else:
                    value = None
                opt_value = [f"{title}", f"{value}"]
                data.append(opt_value)

            header_data = ["Option", "Value"]
            write_to_xlsx(worksheet, header_data, header_format, data)
            question_level = f"{question.title}, {level.name}"
            worksheet.merge_range("A1:B1", f"{question_level}", merge_format)

        else:
            for q in childs:
                options = q.options.exclude(field_type="F")
                for option in options:
                    opt_ans = get_answer(option.id, level_id)
                    if opt_ans:
                        value = f"{opt_ans.value}"
                    else:
                        value = None
                    opt_value = [f"{q.title}", f"{option.title}", value]
                    data.append(opt_value)

            worksheet.set_column("A:A", 65)
            worksheet.set_column("C:C", 30)
            header_data = ["सूचक", "Option", "Value"]

            header_format = workbook.add_format({"bold": True})

            data = keep_only_child_question(data)
            write_to_xlsx(worksheet, header_data, header_format, data)
            question_level = f"{question.title}, {level.name}"
            worksheet.merge_range("A1:C1", f"{question_level}", merge_format)

    # Close the workbook before sending the data.
    workbook.close()

    # Rewind the buffer.
    output.seek(0)

    # Set up the Http response.
    filename = f"{question.title} reports.xlsx"
    response = HttpResponse(
        output,
        content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )
    response["Content-Disposition"] = "attachment; filename=%s" % filename

    return response


def export_reports_all_levels(request, q_id, level_type):
    # to be optimized
    output = io.BytesIO()
    workbook = xlsxwriter.Workbook(output)
    worksheet = workbook.add_worksheet()
    data = []
    question = Question.objects.get(id=q_id)
    childs = question.children_questions.all()
    merge_format = workbook.add_format(
        {
            "bold": 1,
            "border": 1,
            "align": "center",
            "valign": "vcenter",
            "fg_color": "yellow",
        }
    )
    header_format = workbook.add_format({"bold": True})
    worksheet.set_column("A:H", 20)

    options = question.options.exclude(field_type="F").order_by("sequence_id")
    levels = Level.objects.filter(
            type__type__contains=level_type
        )

    if question.month_requires:
        for i in MONTH_ORDER_REPORT:
            for level in levels:
                month_option_data = []
                for option in options:
                    opt_ans = get_answer(option.id, level.id, i)
                    if opt_ans:
                        value = opt_ans.value
                    else:
                        value = None
                    month_option_data.append(value)
                opt_value = [MONTH_DATA[i], level.name]
                if level_type == "L":
                    opt_value = [MONTH_DATA[i], level.name, level.level_code, level.district.name_np]
                # opt_value = [level.name]
                opt_value = opt_value + month_option_data

                data.append(opt_value)
        option_header = [option.title for option in options]
        header_data = ["महिना", "प्रदेश/स्थानीय तह"]
        if level_type == "L":
            header_data = ["महिना", "प्रदेश/स्थानीय तहको नाम", "स्थानीय तहको कोड", "जिल्ला"]

        # header_data = ["Level"]
        header_data = header_data + option_header
        write_to_xlsx(worksheet, header_data, header_format, data)
        worksheet.merge_range("A1:B1", f"{question.title}", merge_format)
    else:
        for level in levels:
            level_option_data = []
            for option in options:
                # title = option.title
                opt_ans = get_answer(option.id, level.id)
                if opt_ans:
                    value = opt_ans.value
                else:
                    value = None
                level_option_data.append(value)
            # opt_value = [f"{title}", f"{value}"]
            opt_value = [level.name]
            if level_type == "L":
                opt_value = [level.name, level.level_code, level.district.name_np]
            opt_value = opt_value + level_option_data
            data.append(opt_value)

        option_header = [option.title for option in options]
        header_data = ["प्रदेश/स्थानीय तह"]
        if level_type == "L":
            header_data = ["प्रदेश/स्थानीय तह", "स्थानीय तहको कोड", "जिल्ला"]
        header_data = header_data + option_header
        write_to_xlsx(worksheet, header_data, header_format, data)
        worksheet.merge_range("A1:B1", f"{question.title}", merge_format)

    # Close the workbook before sending the data.
    workbook.close()

    # Rewind the buffer.
    output.seek(0)

    # Set up the Http response.
    filename = f"{question.title} reports.xlsx"
    response = HttpResponse(
        output,
        content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )
    response["Content-Disposition"] = "attachment; filename=%s" % filename

    return response
