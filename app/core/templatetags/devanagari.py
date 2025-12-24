from django import template
from django.template.defaultfilters import stringfilter

NUMBER_MAP = {
    "0": "०",
    "1": "१",
    "2": "२",
    "3": "३",
    "4": "४",
    "5": "५",
    "6": "६",
    "7": "७",
    "8": "८",
    "9": "९",
}


register = template.Library()


@register.filter()
@stringfilter
def translate_nepal_numeral(value):
    try:
        return "".join([NUMBER_MAP[char] for char in value])
    except KeyError:
        return value
