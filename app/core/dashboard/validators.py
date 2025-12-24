from django.core.exceptions import ValidationError
from os import path
from django.http import JsonResponse


ALLOWED_EXTENSIONS = [
    ".pdf",
    ".docs",
    ".docx",
    ".jpeg",
    ".jpg",
    ".png",
    ".svg",
    ".xlsx",
    ".xls",
]


def validate_file(value):
    import os
    value = str(value)
    try:
        extension = os.path.splitext(value)[1]
        if extension in ALLOWED_EXTENSIONS:
            return True
        else:
            return False
    except:
        return False
