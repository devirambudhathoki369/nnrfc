from core.models import (
    AnswerDocument,
    CorrectionActivityLog,
    Answer,
    FillSurvey,
    FiscalYear,
    Option,
    Question,
    Survey,
)
from django.template.defaulttags import register
from django.db.models import Q

MONTH_DATA = {
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

OPTION_FIELD_INPUT_TYPE = {
    "C": "text",
    "De": "number",
    "P": "percentage",
    "D": "date",
    "B": "checkbox",
    "R": "radio",
    "F": "file",
    "FY": "fiscal_year",
}

OPTION_FIELD_INDICATOR = {
    "De": "रु.",
    "P": "%",
}

def get_all_months():
    return Answer._meta.get_field("month").choices


def get_field_type_choices():
    return Option._meta.get_field("field_type").choices


def get_option_type_choices():
    return Option._meta.get_field("option_type").choices


@register.filter
def get_item(dictionary, key):
    return dictionary.get(key)


def options_bulk_create(ques, option_titles, field_types):
    option_params = zip(option_titles, field_types)
    options = [
        Option(question=ques, title=param[0], field_type=param[1])
        for param in option_params
    ]
    options = Option.objects.bulk_create(options)
    for option in options:
        if option.field_type == "P":
            option.is_calc_field = True
            option.option_type = "Per"
            option.save()

    return options


def options_calculation_conifg(options, numerator, denominator):
    for option in options:
        if option.title == numerator:
            option.option_type = "Num"
            option.save()
        if option.title == denominator:
            option.option_type = "Deno"
            option.save()


def option_bulk_update(option_ids, option_titles, field_types, n_ids, d_ids):
    option_params = zip(option_ids, option_titles, field_types, n_ids, d_ids)
    for o, t, f, n, d in option_params:
        opt = Option.objects.get(id=o)
        opt.title = t
        opt.field_type = f
        if opt.field_type == "P":
            opt.is_calc_field = True
            opt.option_type = "Per"
        if o == n:
            opt.option_type = "Num"
        if o == d:
            opt.option_type = "Deno"
        opt.save()


def new_options_bulk_create(q_ids, new_option_titles, new_field_types):
    """create new options in bulk update form"""
    option_params = zip(q_ids, new_option_titles, new_field_types)
    options = [
        Option(question_id=param[0], title=param[1], field_type=param[2])
        for param in option_params
    ]
    Option.objects.bulk_create(options)


def question_bulk_update(ques, documents, titles):
    ques_params = zip(ques, documents, titles)
    for q, d, t in ques_params:
        ques = Question.objects.get(id=q)
        ques.is_document_required = d
        ques.title = t
        ques.save()


def get_activity_log_data(user, level=None):
    data = {
        "user_name": user.full_name if user.full_name else "SuperAdmin",
        "user_email": user.email,
        "user_level": user.level,
        "action_level": level.name if level else None,
        "action_level_type": level.type.type if level else None,
        "activity": "activity",
    }

    return data


def create_activity_log(log_data):
    CorrectionActivityLog.objects.create(**log_data)


def surveys_by_user_level(user):
    qs = Survey.objects.all()
    # if not user.is_superuser:
    if False:
        level = user.level
        child_levels = level.child_level.all()
        qs = qs.filter(
            Q(fill_surveys__level_id=level)
            | Q(fill_surveys__level_id__in=child_levels)
        )
    return qs


def filled_question_list_by_level(survey, level_id):
    question_qs = Question.objects.filter(parent=None, survey=survey).order_by(
        "sequence_id"
    )
    qs = question_qs.filter(
        Q(options__answers__fill_survey__level_id=level_id)
        | Q(children_questions__options__answers__fill_survey__level_id=level_id)
    ).distinct()
    return qs


def get_options_with_field_types(options, level):
    options_data = []
    for option in options:
        answer = Answer.objects.filter(
            option=option.id,
            created_by_level=level.id,
        ).first()
        option_data = {
            "option": option,
            "input_type": OPTION_FIELD_INPUT_TYPE[option.field_type],
            "answer": answer,
        }
        if option.field_type == "FY":
            fiscal_years = FiscalYear.objects.all()
            fy_data = [{"id": yr.id, "name": yr.name} for yr in fiscal_years]
            option_data["fy_data"] = fy_data
        if option.field_type == "F":
            file = AnswerDocument.objects.filter(answer=answer).first()
            option_data["document"] = file
        options_data.append(option_data)
    return options_data


def get_answer(option_id, level_id, month_id=None):
    """get answer of option by level"""
    option = Option.objects.get(id=option_id)
    if month_id:
        answer = option.answers.filter(fill_survey__level_id=level_id, month=month_id).first()
    else:
        answer = option.answers.filter(fill_survey__level_id=level_id).first()
    return answer


def get_file_option_field(question_id):
    """
    returns option object of the given question
    """
    option_field_file = Option.objects.filter(
            question=question_id, field_type="F"
        )[0]
    return option_field_file
