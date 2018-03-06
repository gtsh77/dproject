from .models import EchoReply
from rest_framework import serializers

class EchoReplySerializer(serializers.HyperlinkedModelSerializer):
	class Meta:
		model = EchoReply
		fields = '__all__'