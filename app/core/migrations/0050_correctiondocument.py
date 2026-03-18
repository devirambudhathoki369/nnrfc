from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0049_auto_20260318_0527'),
    ]

    operations = [
        migrations.CreateModel(
            name='CorrectionDocument',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('document', models.FileField(upload_to='correction-files/')),
                ('correction', models.ForeignKey(
                    on_delete=django.db.models.deletion.CASCADE,
                    related_name='documents',
                    to='core.surveycorrection',
                )),
            ],
            options={
                'abstract': False,
            },
        ),
    ]