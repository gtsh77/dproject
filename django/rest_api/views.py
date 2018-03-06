from django.shortcuts import render
from django.http import HttpResponse
from rest_framework import viewsets
from .models import EchoReply
from .serializers import EchoReplySerializer

# Create your views here.
def index(req):
	# return HttpResponse("PONG")
    context = {'some': 10}
    return render(req, 'index.html')

class EchoReplyViewSet(viewsets.ModelViewSet):
	queryset = EchoReply.objects.all()
	serializer_class = EchoReplySerializer