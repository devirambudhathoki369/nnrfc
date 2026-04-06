from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0047_add_active_fy"),
    ]

    operations = [
        migrations.AlterField(
            model_name="option",
            name="field_type",
            field=models.CharField(
                choices=[
                    ("C", "Character"),
                    ("B", "Checkbox"),
                    ("R", "Radio"),
                    ("D", "Date"),
                    ("De", "Amount"),
                    ("F", "File"),
                    ("P", "Percentage Field"),
                    ("FY", "Fiscal Year"),
                ],
                max_length=2,
                verbose_name="Field Type",
            ),
        ),
    ]
