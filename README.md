# NNRFC
## Project Setup Guide
### For development environment
#### Project configuration with docker
- Install **[docker](https://docs.docker.com/engine/install/)** and **[docker-compose](https://docs.docker.com/compose/install/)** on your machine
- **git clone** the project and switch to **dev** branch
- Add **.env.dev** file in project root with following content
    ```
    ENVIRONMENT=development
    DEBUG=1
    SECRET_KEY=foo
    DJANGO_ALLOWED_HOSTS=*
    SQL_ENGINE=django.db.backends.postgresql
    SQL_DATABASE=nnrfc
    SQL_USER=admin
    SQL_PASSWORD=admin
    SQL_HOST=db
    SQL_PORT=5432
    DATABASE=postgres
    EMAIL_BACKEND = django.core.mail.backends.smtp.EmailBackend
    EMAIL_USE_TLS = True
    EMAIL_HOST=smtp.gmail.com
    EMAIL_HOST_USER = noreply@infodev.com.np
    EMAIL_HOST_PASSWORD = Nepal999
    EMAIL_PORT=587
    RABBITMQ_DEFAULT_USER=guest
    RABBITMQ_DEFAULT_PASS=guest
    CELERY_BROKER_URL=amqp://guest:guest@rabbit:5672
    CELERY_SETTINGS_MODULE=nnrfc.settings.base
    ```
- Run ```docker-compose up --build``` in project root to build the project
- ```--build ``` has to be used when you are building the project for the first time or if there is change in requirements file or if some changes has been made in docker configuration
- To run the project with debugger, use 
```docker-compose run --service-ports web```
