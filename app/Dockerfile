FROM python:3.9-bullseye

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies (WeasyPrint + Pillow)
RUN apt-get update && apt-get install -y \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    shared-mime-info \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install Python dependencies
RUN pip install \
    Django==3.2.13 \
    psycopg2-binary==2.9.3 \
    python-dotenv==0.19.2 \
    celery==5.2.7 \
    redis==4.3.3 \
    django-axes==5.31.0 \
    gunicorn==20.1.0 \
    weasyprint==52.5 \
    Pillow==9.1.1 \
    XlsxWriter==3.0.3 \
    openpyxl==3.0.10 \
    pandas==1.4.2 \
    numpy==1.22.3 \
    xlrd==2.0.1 \
    reportlab==3.6.9

# Copy project
COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
