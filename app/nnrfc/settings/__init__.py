# from decouple import config
import os 

environment = os.environ.get("ENVIRONMENT")

if environment == "production":
    from .production import *
else:
    from .development import *
