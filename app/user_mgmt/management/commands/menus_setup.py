from user_mgmt.models import Menu
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Menus Setup"

    def handle(self, *args, **options):

        menus = [
            {
                "name": "ड्यासबोर्ड",
                "code": "dashboard",
                "url": "dashboard:dashboard",
            },
            {
                "name": "कार्य सम्पादन सूचक",
                "code": "survey_setup",
                "url": "dashboard:home",
            },
            {
                "name": "विभाग/संस्था/मन्त्रालय सेटअप",
                "code": "departments",
                "url": "user_mgmt:depart_list",
            },
            {
                "name": "सुधार अनुमति सूचक",
                
                "code": "correction_req",
                "url": "dashboard:correction_req",
            },
            {
                "name": "प्रयोगकर्ता सेटअप",
                "code": "users",
                "url": "user_mgmt:user_list",
            },
            {
                "name": "भूमिका सेटअप",
                "code": "roles",
                "url": "user_mgmt:role_list",
            },
            {
                "name": "मास्टर कन्फिगरेसन",
                "code": "master",
                "url": "dashboard:master_configuration",
            },
            {
                "name": "गतिविधि लग",
                "code": "activity_log",
                "url": "dashboard:activity_log",
            },
            {
                "name": "गुनासोहरु",
                "code": "complaints",
                "url": "dashboard:list_complaints",
            },
            {
                "name": "भरिएको कार्य सम्पादन सूचकहरु",
                "code": "survey_list",
                "url": "dashboard:survey_list",
            },
            {
                "name": "प्रतिवेदनहरु",
                "code": "reports",
                "url": "report:reports",
            },
            {
                "name": "मूल्याङ्कन पुनरावलोकन सम्बन्धी गुनासो",
                "code": "appraisal_review_request",
                "url": "dashboard:appraisal_review_request",
            },
            {
                "name": "सेटिङ",
                "code": "settings",
                "url": "dashboard:settings",
            },
        ]
        for menu in menus:
            Menu.objects.update_or_create(
                code=menu["code"],
                defaults={
                    "name": menu["name"],
                    "url": menu["url"],
                }
            )

        print("Command Executed Successfully.")
