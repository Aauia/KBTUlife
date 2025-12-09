from django.db import models
from api.models import CustomUser
from events.models import Event
import uuid

class Ticket(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='tickets')
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name='tickets')
    qrcode = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    paid = models.BooleanField(default=False)
    used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
