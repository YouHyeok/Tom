import os
import json

from django.conf import settings
from celery import shared_task

from celery.exceptions import Ignore

@shared_task()
def git_task(user, task):
    repos = os.listdir("/root/Repos" + '/' + user)
    category = task.split('-')[1]
    repo = task.split('-')[0]

    try:
        if repo in repos:
            with open('/root/Repos/%s/%s/package.json' % (user, repo)) as f:
                json_object = json.load(f)

                os.system("cd /root/Repos/%s/%s/ && git config --local user.name \"%s\" && git config --local user.email \"%s\"" % (user, repo, json_object['scripts']['user_name'], json_object['scripts']['user_email']))
                os.system("cd /root/Repos/%s/%s/ && npm run %s" % (user, repo, category))

        raise Ignore
    
    except Ignore:
        pass

    