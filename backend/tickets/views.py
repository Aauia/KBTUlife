from rest_framework import viewsets, serializers
from .models import Ticket
from .serializers import TicketSerializer
from events.models import Event
import qrcode
from io import BytesIO
from django.core.files.base import ContentFile

class TicketViewSet(viewsets.ModelViewSet):
    serializer_class = TicketSerializer

    def get_queryset(self):
        user = self.request.user
        return Ticket.objects.filter(user=user)

    def perform_create(self, serializer):
        event = serializer.validated_data['event']

        if event.tickets_available <= 0:
            raise serializers.ValidationError("No tickets available for this event.")

        ticket = serializer.save(user=self.request.user)

        # Уменьшаем количество билетов
        event.tickets_available -= 1
        event.save()