from rest_framework import serializers
from .models import Ticket, Event
from events.serializers import EventSerializer
from api.models import CustomUser
import qrcode
from io import BytesIO
from django.core.files.base import ContentFile
import base64

class TicketSerializer(serializers.ModelSerializer):
    user_email = serializers.CharField(source='user.outlook', read_only=True)
    event = EventSerializer(read_only=True)  
    event_id = serializers.PrimaryKeyRelatedField(
        queryset=Event.objects.all(),
        write_only=True,
        source='event'  
    )
    qr_code_image = serializers.SerializerMethodField()

    class Meta:
        model = Ticket
        fields = ['id', 'user', 'user_email', 'event', 'event_id', 'qrcode', 
                'paid', 'used', 'created_at', 'qr_code_image']
        read_only_fields = ['qrcode', 'created_at', 'qr_code_image']

    def get_qr_code_image(self, obj):
        if not obj.qrcode:
            return None
        qr = qrcode.make(str(obj.qrcode))
        buffer = BytesIO()
        qr.save(buffer, format='PNG')
        image_str = base64.b64encode(buffer.getvalue()).decode()
        return f"data:image/png;base64,{image_str}"