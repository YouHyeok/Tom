from django.db import models

# Create your models here.
class SchedulingTasks(models.Model):
    task = models.CharField(max_length = 20, null=True)
    scheduled_id = models.IntegerField(null=True)
    scheduled_time = models.IntegerField(null=True)
    created_date = models.DateField(auto_now_add=True)
    modified_date = models.DateField(auto_now=True)