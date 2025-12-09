from django.db import models
from api.models import CustomUser

class Club(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    instagram_link = models.URLField(blank=True, null=True)
    telegram_link = models.URLField(blank=True, null=True)
    manager = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='managed_clubs')

    def __str__(self):
        return self.name
