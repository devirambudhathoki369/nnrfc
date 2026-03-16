from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0047_add_active_fy'),
    ]

    operations = [
        migrations.AddField(
            model_name='question',
            name='full_marks',
            field=models.PositiveIntegerField(
                blank=True,
                null=True,
                verbose_name='Full Marks',
            ),
        ),
    ]