from django.contrib import admin
from django.urls import path

from django.conf import settings
from django.conf.urls.static import static

import Tom.views

urlpatterns = [
    path("get/categories", Tom.views.index, name='Get Categories'),
    path("get/scheduled_tasks", Tom.views.scheduled_tasks, name="Get Scheduled Tasks"),
    path("trigger/upload/git", Tom.views.git, name="Trigger Uploading to GIT"),
    path("trigger/deploy/blogs", Tom.views.deploy_blogs, name="Deploying blogs on a server"),
    path("register/schedule", Tom.views.register_schedule, name="Registering the requested schedule")
] 
