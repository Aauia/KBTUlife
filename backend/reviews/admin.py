from django.contrib import admin
from .models import Review

@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'event', 'rating', 'created_at')
    list_filter = ('rating', 'created_at', 'event')
    search_fields = ('user__first_name', 'user__last_name', 'event__name', 'comment')
    readonly_fields = ('created_at',)
