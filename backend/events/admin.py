from django.contrib import admin
from .models import Event, EventCategory

@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ('name', 'date', 'location', 'club', 'category', 'is_free', 'tickets_available')
    list_filter = ('date', 'location', 'category', 'is_free')
    search_fields = ('name', 'description', 'location', 'club__name')
