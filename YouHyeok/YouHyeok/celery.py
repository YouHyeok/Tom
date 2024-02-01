import sys

import os
from celery import Celery

CURRENT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, CURRENT_DIR)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'YouHyeok.settings')

app = Celery('YouHyeok', include=['Tom.tasks'])
app.config_from_object('django.conf:settings', namespace='CELERY')

app.conf.update(
    CELERY_BROKER_URL = 'pyamqp://guest@localhost//',
    CELERY_RESULT_BACKEND = "redis://youhyeok.com:6379",
    CELERY_BEAT_SCHEDULER = 'django_celery_beat.schedulers:DatabaseScheduler',
)

app.autodiscover_tasks([])