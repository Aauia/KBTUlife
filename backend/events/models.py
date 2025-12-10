from django.db import models
from django.utils.translation import gettext_lazy as _
from clubs.models import Club

class EventCategory(models.TextChoices):
    FAIRS = 'fairs', _('Ярмарки / Жәрмеңке / Fairs')
    SEMINARS = 'seminars', _('Семинары / Семинарлар / Seminars')
    LECTURES = 'lectures', _('Guest lectures / Қонақ дәрістері / Guest lectures')
    PSYCHOLOGIST = 'psychologist', _('Психолог / Психолог / Psychologist')
    OFFSITE = 'offsite', _('Выездное / Сырттағы іс-шара / Offsite')
    PARTIES = 'parties', _('Вечеринки / Вечеринкалар / Parties')
    GAMES = 'games', _('Игры / Ойындар / Games')
    HACKATHONS = 'Hackathons', _('Хакатоны / Хакатондар / Hackathons')
    WORKSHOPS = 'Workshops', _('Воркшопы / Воркшоптар / Workshops')


class Event(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    club = models.ForeignKey(Club, on_delete=models.SET_NULL, null=True, blank=True, related_name='events')
    location = models.CharField(max_length=200)
    date = models.DateTimeField()
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    category = models.CharField(max_length=50, choices=EventCategory.choices)
    is_free = models.BooleanField(default=True)
    media_urls = models.JSONField(default=list, blank=True)  # хранит список фото/видео
    tickets_available = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name