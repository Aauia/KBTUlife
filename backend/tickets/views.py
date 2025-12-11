import qrcode
from io import BytesIO
from django.core.files.base import ContentFile
from rest_framework import viewsets
from .models import Ticket
from .serializers import TicketSerializer

class TicketViewSet(viewsets.ModelViewSet):
    queryset = Ticket.objects.all()
    serializer_class = TicketSerializer

    def perform_create(self, serializer):
        ticket = serializer.save()
        qr = qrcode.make(str(ticket.qrcode))
        buffer = BytesIO()
        qr.save(buffer)
        ticket.save()
        ticket.qr_image.save(f'{ticket.qrcode}.png', ContentFile(buffer.getvalue()), save=True)
