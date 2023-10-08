from django.shortcuts import render

import os

from rest_framework.response import Response
from rest_framework.decorators import api_view

from django.conf import settings

from pathlib import Path

# Create your views here.

@api_view(['GET'])
def index(request):

    print(request.data)
        
    return Response({"results": [{"categories": "Java"}, {"categories": "Python"}]})

@api_view(['POST'])
def git(request):

    print(request.data)