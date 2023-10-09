from django.shortcuts import render

import os
import json

from rest_framework.response import Response
from rest_framework.decorators import api_view

from django.conf import settings

from pathlib import Path

# Create your views here.

users_repo = {"Jong": ["_tutorials", "_labs"], "You": ["newblog"]}

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


    
    