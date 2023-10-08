from django.contrib import admin
from django.urls import path

from django.conf import settings
from django.conf.urls.static import static

import Tom.views

urlpatterns = [
    path("get/categories", Tom.views.index, name='Categories'),
    path("trigger/upload/git", Tom.views.git, name="Trigger Uploading to GIT")
] 
