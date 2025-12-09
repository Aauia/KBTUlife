from rest_framework import serializers
from .models import Ticket
from events.serializers import EventSerializer
from api.models import CustomUser
import qrcode
from io import BytesIO
from django.core.files.base import ContentFile
import base64

class TicketSerializer(serializers.ModelSerializer):
    # Включаем данные пользователя и события
    user_email = serializers.CharField(source='user.outlook', read_only=True)
    event = EventSerializer(read_only=True)
    
    # Можно вернуть QR код как Base64, чтобы фронт его отображал
    qr_code_image = serializers.SerializerMethodField()

    class Meta:
        model = Ticket
        fields = ['id', 'user', 'user_email', 'event', 'qrcode', 'paid', 'used', 'created_at', 'qr_code_image']
        read_only_fields = ['qrcode', 'created_at', 'qr_code_image']

    def get_qr_code_image(self, obj):
        # Генерация QR-кода в Base64
        qr = qrcode.make(str(obj.qrcode))
        buffer = BytesIO()
        qr.save(buffer)
        image_str = base64.b64encode(buffer.getvalue()).decode()
        return f"data:image/png;base64,{image_str}"

    def create(self, validated_data):
        # При создании автоматически генерируется UUID (в модели)
        ticket = Ticket.objects.create(**validated_data)
        return ticket
