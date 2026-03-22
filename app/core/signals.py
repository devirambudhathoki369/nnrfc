from core.get_username import current_request
from core.utils import create_activity_log, get_activity_log_data
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from core.models import Answer, FillSurvey, Notification, Question, SurveyCorrection


@receiver(pre_save, sender=Answer)
def create_log_on_answer_update(sender, instance, **kwargs):
    try:
        ans = sender.objects.get(pk=instance.pk)
    except sender.DoesNotExist:
        pass
    else:
        if ans.value != instance.value:
            user = current_request().user
            level = instance.created_by_level
            log_data = get_activity_log_data(user, level)
            log_data["old_value"] = ans.value
            log_data["changed_value"] = instance.value
            log_data["activity"] = "सुधार अनुमति सूचक चेक गरियो।"
            log_data["option"] = instance.option.title
            log_data["option_id"] = instance.option.id
            log_data["question_id"] = instance.option.question_id
            log_data["question_title"] = instance.option.question.title
            create_activity_log(log_data)


@receiver(post_save, sender=SurveyCorrection)
def create_correction_notification(sender, instance, created, **kwargs):
    if created:
        user = instance.user
        msg = f"नयाँ सुधार अनुमति सूचक प्रयोगकर्ता {user} द्वारा पठाइएको छ।"
        level = instance.level
        Notification.objects.get_or_create(
            question=instance.question,
            level=level,
            correction_checked=False,
            defaults={
                "user": user,
                "msg": msg,
                "correction": instance,
                "is_viewed": False,
            },
        )
