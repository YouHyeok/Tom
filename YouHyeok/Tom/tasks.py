import os
import json

from django.conf import settings
from celery import shared_task

from celery.exceptions import Ignore

users_repo = {"Jong": ["_tutorials", "_labs", "_enfycius"], "You": ["newblog"]}

@shared_task()
def git_task(user, task):
    repos = users_repo[user]
    category = task.split('-')[1]
    repo = task.split('-')[0]

    try:
        if repo in repos:
            with open('/root/Repos/%s/package.json' % repo) as f:
                json_object = json.load(f)

                os.system("cd /root/Repos/%s/ && git config --local user.name \"%s\" && git config --local user.email \"%s\"" % (repo, json_object['scripts']['user_name'], json_object['scripts']['user_email']))
                os.system("cd /root/Repos/%s/ && npm run %s" % (repo, category))

        raise Ignore
    
    except Ignore:
        pass

    