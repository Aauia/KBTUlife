from django.db import models
from api.models import CustomUser
from clubs.models import Club

class ClubManager(models.Model):
    club = models.ForeignKey(Club, on_delete=models.CASCADE, related_name='clubmanager_entries')
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='clubmanager_roles')
    role = models.CharField(max_length=50, default='manager')

    class Meta:
        unique_together = ('club', 'user')

    def __str__(self):
        return f"{self.user.outlook} manages {self.club.name}"
