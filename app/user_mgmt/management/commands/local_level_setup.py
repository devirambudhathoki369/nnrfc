import csv
import os

from django.conf import settings
from django.core.management.base import BaseCommand
from user_mgmt.models import Level, District, LevelType


class Command(BaseCommand):
    help = "create local level data from csv file"

    def handle(self, *args, **options):
        with open(os.path.join(settings.BASE_DIR, "../local_level.csv"), "r") as file:
            reader = csv.reader(file)
            next(reader)
            for row in reader:
                print("district", row)
                level_obj = Level.objects.get(id=row[0])
                district_obj = District.objects.get(name_np=row[3])
                type_obj = LevelType.objects.get(type="L")
                local_level, created = Level.objects.get_or_create(
                    province_level=level_obj,
                    level_code=row[1],
                    name=row[2],
                    type=type_obj,
                    district=district_obj,
                )
                print(local_level)
                print("Local levels loaded sucessfully!")
