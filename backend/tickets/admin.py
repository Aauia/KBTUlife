from django.contrib import admin
from .models import Ticket

@admin.register(Ticket)
class TicketAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'event', 'paid', 'used', 'created_at', 'qrcode')
    list_filter = ('paid', 'used', 'created_at', 'event')
    search_fields = ('user__first_name', 'user__last_name', 'event__name')
    readonly_fields = ('qrcode', 'created_at')
