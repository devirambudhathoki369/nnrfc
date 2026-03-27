from .base import *

# ── Dev: louder logging so email failures are obvious in the terminal ──
LOGGING["loggers"]["user_mgmt"] = {
    "handlers": ["console"],
    "level": "DEBUG",
    "propagate": False,
}