from celery import shared_task
from django.core.mail import EmailMessage
from django.conf import settings


@shared_task
def send_email(body, *emails):
    email = EmailMessage("User Invitation", body, settings.EMAIL_HOST_USER, *emails)
    email.content_subtype = "html"
    email.send()


@shared_task
def send_html_email(body, *emails):
    try:
        email = EmailMessage("Reset Your Password", body, settings.EMAIL_HOST_USER, *emails)
        email.content_subtype = 'html'
        email.send()
    except:
        pass