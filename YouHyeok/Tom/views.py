from django.shortcuts import render

import os
import json

from rest_framework.response import Response
from rest_framework.decorators import api_view

from django.conf import settings

from pathlib import Path

# Create your views here.

@api_view(['GET'])
def index(request):
    users_repo = {"Jong": "_tutorials", "You": "newblog"}

    if request.GET.get('user', None) != None:
        if request.GET.get('user', None) == 'You':
            repo = users_repo[request.GET.get('user', None)]
            categories = []
            
            with open('/root/Repos/%s/package.json' % repo) as f:
                json_object = json.load(f)

                for key, values in json_object['scripts'].items():
                    if "--prefix" in values:
                        categories.append(key)
                        
            return Response({"results": categories})
        elif request.GET.get('user', None) == 'Jong':
            repo = users_repo[request.GET.get('user', None)]
            categories = []
            
            with open('/root/Repos/%s/package.json' % repo) as f:
                json_object = json.load(f)

                for key, values in json_object['scripts'].items():
                    if "--prefix" in values:
                        categories.append(key)
                        
            return Response({"results": categories})

@api_view(['POST'])
def git(request):

    print(request.data)