import uuid
from django.db import models
from django.conf import settings

class Review(models.Model):
    event = models.ForeignKey(
        'events.Event',
        related_name='reviews',
        on_delete=models.CASCADE
    )

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        related_name='reviews',
        on_delete=models.CASCADE
    )

    rating = models.PositiveSmallIntegerField()  # 1–5
    text = models.TextField(blank=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.event} — {self.rating}/5'
