from django.contrib import admin
from .models import ClubManager

@admin.register(ClubManager)
class ClubManagerAdmin(admin.ModelAdmin):
    list_display = ('club', 'user', 'role')
    list_filter = ('club', 'role')
    search_fields = ('user__outlook', 'club__name')
