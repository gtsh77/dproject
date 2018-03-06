from django.db import models

# Create your models here.
class EchoReply(models.Model):
	msg = models.CharField(max_length=256)
	def __str__(self):
		return self.msg