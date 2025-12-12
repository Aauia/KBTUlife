from django.db import models
from api.models import CustomUser
from events.models import Event
import uuid
from django.utils import timezone

class Ticket(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='tickets')
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name='tickets')
    qrcode = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)

    PAYMENT_CHOICES = [
        ('unpaid', 'Не оплачен'),
        ('pending', 'Ожидает проверки'),   # пользователь сказал, что перевёл
        ('paid', 'Оплачен'),               # админ подтвердил перевод
        ('rejected', 'Отклонён'),          # админ увидел, что перевода нет
    ]
    payment_status = models.CharField(
        max_length=20,
        choices=PAYMENT_CHOICES,
        default='unpaid'
    )
    used = models.BooleanField(default=False)
    used_at = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True, default='')

    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Ticket {self.id} - {self.user.outlook} - {self.event.name}"
    
