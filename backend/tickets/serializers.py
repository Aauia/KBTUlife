from rest_framework import serializers
from .models import Ticket, Event
from events.serializers import EventSerializer
import qrcode
from io import BytesIO
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
                 'payment_status', 'used', 'used_at', 'notes', 'created_at', 'qr_code_image']
        read_only_fields = ['payment_status','qrcode', 'created_at', 'qr_code_image', 'used', 'used_at', 'notes',]

    def get_qr_code_image(self, obj):
        if not obj.qrcode:
            return None
        qr = qrcode.make(str(obj.qrcode))
        buffer = BytesIO()
        qr.save(buffer, format='PNG')
        image_str = base64.b64encode(buffer.getvalue()).decode()
        return f"data:image/png;base64,{image_str}"