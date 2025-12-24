from user_mgmt.models import Level, LevelType
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Province Setup"

    def handle(self, *args, **options):

        level_types = [{"type": "P", "pk": 1}, {"type": "L", "pk": 2}]
        province_levels = [
            {"name": "१ नं. प्रदेश"},
            {"name": "२ नं. प्रदेश"},
            {"name": "बागमती प्रदेश"},
            {"name": "गण्डकी प्रदेश"},
            {"name": "लुम्बिनी प्रदेश"},
            {"name": "कर्णाली प्रदेश"},
            {"name": "सुदूर पश्चिम प्रदेश"},
        ]

        # local_levels = [
        #     {"name": "Local Level 1"},
        #     {"name": "Local Level 2"},
        #     {"name": "Local Level3"},
        #     {"name": "Local Level4"},
        #     {"name": "Local Level5"},
        # ]

        for type in level_types:
            LevelType.objects.get_or_create(**type)

        for level in province_levels:
            Level.objects.get_or_create(type_id=1, **level)

        # for level in local_levels:
        #     Level.objects.get_or_create(type_id=2, **level)

        print("Command Executed Successfully.")
