from django import template
from core.models import Answer, AnswerDocument, Option, Question
from core.utils import get_answer

register = template.Library()


@register.simple_tag
def get_option_answer(option_id, level_id):
    answer = get_answer(option_id, level_id)
    return answer.value


@register.simple_tag
def get_answer_documents(q_id, level_id):
    ques = Question.objects.get(id=q_id)
    options = ques.options.all()
    documents = AnswerDocument.objects.filter(
        answer__option__in=options, answer__fill_survey__level_id=level_id
    ).distinct()
    return documents
