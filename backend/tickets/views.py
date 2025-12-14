from rest_framework import viewsets, filters
from rest_framework.response import Response
from rest_framework.exceptions import PermissionDenied, ValidationError
from django.utils import timezone
import uuid
from rest_framework.decorators import action
from .models import *
from .serializers import *

class TicketViewSet(viewsets.ModelViewSet):
    serializer_class = TicketSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['user__outlook', 'event__name']  # для поиска

    def get_queryset(self):
        """
        - Если пользователь — админ → видит ВСЕ билеты
        - Если обычный пользователь → видит только свои
        """
        if self.request.user.is_staff or self.request.user.is_superuser:
            return Ticket.objects.all().select_related('user', 'event')

        # Обычный пользователь видит только свои билеты
        return Ticket.objects.filter(user=self.request.user).select_related('event')
    
    @action(detail=False, methods=['get'], url_path=r'user/(?P<user_id>[^/.]+)')
    def user_tickets(self, request, user_id=None):
        if not (request.user.is_staff or request.user.is_superuser):
            raise PermissionDenied("You do not have permission to view other users' tickets.")

        tickets = Ticket.objects.filter(user_id=user_id).select_related('event')
        serializer = self.get_serializer(tickets, many=True)
        return Response(serializer.data)
    
    def perform_create(self, serializer):
        event = serializer.validated_data['event']

        if event.tickets_available <= 0:
            raise serializers.ValidationError("No tickets available for this event.")

        ticket = serializer.save(user=self.request.user)

        # Уменьшаем количество билетов
        event.tickets_available -= 1
        event.save()

    @action(detail=True, methods=['post'], url_path='mark-as-pending')
    def mark_as_pending(self, request, pk=None):
        ticket = self.get_object()
        if ticket.user != request.user:
            raise PermissionDenied("Это не ваш билет")

        if ticket.payment_status != 'unpaid':
            raise ValidationError("Статус оплаты уже изменён")

        ticket.payment_status = 'pending'
        ticket.save()
        return Response({"detail": "Ожидаем проверки оплаты администратором"})
    
    @action(detail=True, methods=['post'], url_path='confirm-payment')
    def confirm_payment(self, request, pk=None):
        if not request.user.is_staff:
            raise PermissionDenied()

        ticket = self.get_object()
        status = request.data.get('status')  # 'paid' или 'rejected'

        if status not in ['paid', 'rejected']:
            raise ValidationError("Неверный статус")

        ticket.payment_status = status
        ticket.save()
        return Response({"detail": f"Статус изменён на {status}"})

    @action(detail=False, methods=['post'], url_path='validate-qr')
    def validate_qr(self, request):
        if not (request.user.is_staff or request.user.is_superuser):
            raise PermissionDenied("Только менеджеры могут проверять QR")

        qr_code_str = request.data.get('qr_code')
        if not qr_code_str:
            raise ValidationError("QR-код не предоставлен")

        try:
            uuid.UUID(qr_code_str)
        except ValueError:
            raise ValidationError("Неверный формат QR-кода")

        try:
            ticket = Ticket.objects.get(qrcode=qr_code_str)
        except Ticket.DoesNotExist:
            raise ValidationError("Билет не найден")

        if ticket.payment_status != 'paid':
            raise ValidationError("Билет не оплачен")
        if ticket.used:
            raise ValidationError("Билет уже использован")

        serializer = self.get_serializer(ticket)
        return Response({
            "status": "valid",
            "ticket": serializer.data,
            "message": "Билет валиден. Можно пропустить."
        })
    
    @action(detail=True, methods=['post'], url_path='mark-as-used')
    def mark_as_used(self, request, pk=None):
        if not (request.user.is_staff or request.user.is_superuser):
            raise PermissionDenied("Только менеджеры могут отмечать")

        ticket = self.get_object()

        if ticket.payment_status != 'paid':
            raise ValidationError("Билет не оплачен")
        if ticket.used:
            raise ValidationError("Билет уже использован")

        ticket.used = True
        ticket.used_at = timezone.now()
        ticket.notes = request.data.get('notes', ticket.notes)
        ticket.save()

        return Response({"detail": "Билет отмечен как использованный"})