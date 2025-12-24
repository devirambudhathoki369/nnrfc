import csv
import os

from django.conf import settings
from django.core.management.base import BaseCommand
from user_mgmt.models import District


class Command(BaseCommand):
    help = "create district name to the database table from csv file"

    def handle(self, *args, **options):
        with open(os.path.join(settings.BASE_DIR, "../district_name.csv"), "r") as file:
            reader = csv.reader(file)
            next(reader)
            for row in reader:
                print("district", row)
                district, created = District.objects.get_or_create(
                    name_eng=row[0],
                    name_np=row[1],
                )
                print(district)
                print("Districts loaded successfully!")
