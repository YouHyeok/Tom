from django.shortcuts import render

import os
import json

from rest_framework.response import Response
from rest_framework.decorators import api_view

from Tom.models import SchedulingTasks
from Tom.serializers import SchedulingSerializer

from django.conf import settings

from pathlib import Path

from django.forms.models import model_to_dict
from django.core.exceptions import ObjectDoesNotExist
from django.core.exceptions import ValidationError

from django_celery_beat.models import PeriodicTask, IntervalSchedule

from django.db.models import F

# Create your views here.

users_repo = {"Jong": ["_tutorials", "_labs", "_enfycius"], "You": ["newblog"]}
schedule_time = {"1": 5, "2": 10, "3": 15, "4": 30, "5": 60, "6": 120}

@api_view(['GET'])
def index(request):
    if request.GET.get('user', None) != None:
        if request.GET.get('user', None) == 'You':
            repos = users_repo[request.GET.get('user', None)]
            categories = []

            for repo in repos:
                with open('/root/Repos/%s/package.json' % repo) as f:
                    json_object = json.load(f)

                    for key, values in json_object['scripts'].items():
                        if "--prefix" in values:
                            categories.append(repo + "-" + key)
                        
            return Response({"results": categories})
        
        elif request.GET.get('user', None) == 'Jong':
            repos = users_repo[request.GET.get('user', None)]
            categories = []

            for repo in repos:
                with open('/root/Repos/%s/package.json' % repo) as f:
                    json_object = json.load(f)

                    for key, values in json_object['scripts'].items():
                        if "--prefix" in values:
                            categories.append(repo + "-" + key)
                        
            return Response({"results": categories})

@api_view(['GET'])
def scheduled_tasks(request):
    if request.GET.get('user', None) != None:
        if request.GET.get('user', None) == 'You':
            scheduled_tasks = SchedulingTasks.objects.filter(user = 'You')
            scheduled_tasks = [model_to_dict(obj) for obj in scheduled_tasks]

            serializer = SchedulingSerializer(data = scheduled_tasks, many = True)

            if serializer.is_valid():
                return Response({"status": "success", "data": serializer.data})
            else:
                return Response({"status": "error", "data": serializer.errors})
            
        elif request.GET.get('user', None) == 'Jong':
            scheduled_tasks = SchedulingTasks.objects.filter(user = 'Jong')
            scheduled_tasks = [model_to_dict(obj) for obj in scheduled_tasks]

            serializer = SchedulingSerializer(data = scheduled_tasks, many = True)

            if serializer.is_valid():
                return Response({"status": "success", "data": serializer.data})
            else:
                return Response({"status": "error", "data": serializer.errors})

def register_periodic_task(scheduled_time, user, task):
    schedule, created = IntervalSchedule.objects.get_or_create(
        every=schedule_time[scheduled_time],  
        period=IntervalSchedule.MINUTES,  
    )

    try:
        task = PeriodicTask.objects.create(
            interval=schedule,
            name=user + ' ' + task,
            task="Tom.tasks.git_task",
            args = json.dumps([user, task]),
            enabled = True
        )

        task.save()
    except ValidationError:
        IntervalSchedule.objects.filter(pk = PeriodicTask.objects.get(name = user + ' ' + task).interval_id).delete()
        PeriodicTask.objects.filter(name = user + ' ' + task).delete()

        task = PeriodicTask.objects.create(
            interval=schedule,
            name=user + ' ' + task,
            task="Tom.tasks.git_task",
            args = json.dumps([user, task]),
            enabled = True
        )

        task.save()

    return task.id

@api_view(['POST'])
def register_schedule(request):
    try:
        try:
            record = SchedulingTasks.objects.get(user = request.data['user'], task = request.data['task'])

            if record.scheduled_id is not None:
                IntervalSchedule.objects.filter(pk = PeriodicTask.objects.get(name = request.data['user'] + ' ' + request.data['task']).interval_id).delete()
                PeriodicTask.objects.filter(name = request.data['user'] + ' ' + request.data['task']).delete()
                record.delete()

            if request.data["scheduled_time"] == 0:
                record = SchedulingTasks(user = request.data['user'], task = request.data['task'], \
                scheduled_id = None, scheduled_time = request.data['scheduled_time'])
            else:
                task_id = register_periodic_task(str(request.data['scheduled_time']), request.data['user'], request.data['task'])
            
                record = SchedulingTasks(user = request.data['user'], task = request.data['task'], \
                scheduled_id = task_id, scheduled_time = request.data['scheduled_time'])
            
            record.save()
        except SchedulingTasks.DoesNotExist:
           raise ObjectDoesNotExist
        except SchedulingTasks.MultipleObjectsReturned:
            SchedulingTasks.objects.filter(user = request.data['user'], task = request.data['task']).delete()
            
            IntervalSchedule.objects.filter(pk = PeriodicTask.objects.get(name = request.data['user'] + ' ' + request.data['task']).interval_id).delete()
            PeriodicTask.objects.filter(name = request.data['user'] + ' ' + request.data['task']).delete()
    except ObjectDoesNotExist:
        if request.data["scheduled_time"] == 0:
            record = SchedulingTasks(user = request.data['user'], task = request.data['task'], \
                scheduled_id = None, scheduled_time = request.data['scheduled_time'])
            record.save()
        else:
            task_id = register_periodic_task(str(request.data['scheduled_time']), request.data['user'], request.data['task'])

            record = SchedulingTasks(user = request.data['user'], task = request.data['task'], \
                scheduled_id = task_id, scheduled_time = request.data['scheduled_time'])
            record.save()
        
    return Response({"results": "success"})

@api_view(['POST'])
def git(request):
    print(request.data)

    user = request.data['user']
    repos = users_repo[user]
    category = request.data['category'].split('-')[1]
    repo = request.data['category'].split('-')[0]

    if repo in repos:
        print(repo)
        print(category)

        with open('/root/Repos/%s/package.json' % repo) as f:
            json_object = json.load(f)

            os.system("cd /root/Repos/%s/ && git config --local user.name \"%s\" && git config --local user.email \"%s\"" % (repo, json_object['scripts']['user_name'], json_object['scripts']['user_email']))
            os.system("cd /root/Repos/%s/ && npm run %s" % (repo, category))

        return Response({"results": "success"})
    else:
        return Response({"results": "failed"})