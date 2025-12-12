# clubs/models.py
from django.db import models
from api.models import CustomUser

class Club(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    instagram_link = models.URLField(blank=True, null=True)
    telegram_link = models.URLField(blank=True, null=True)
    manager = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, related_name='clubs_managed_directly')

    # Members via Membership model
    members = models.ManyToManyField(CustomUser, through='Membership', related_name='clubs')

    def __str__(self):
        return self.name


class Membership(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('declined', 'Declined'),
    ]

    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='memberships')
    club = models.ForeignKey(Club, on_delete=models.CASCADE, related_name='memberships')
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    requested_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('user', 'club')

    def __str__(self):
        return f"{self.user.outlook} -> {self.club.name} ({self.status})"
