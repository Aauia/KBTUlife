# clubs/admin.py
from django.contrib import admin
from .models import Club, Membership

@admin.register(Club)
class ClubAdmin(admin.ModelAdmin):
    list_display = ('name', 'instagram_link', 'manager')
    search_fields = ('name',)
    def get_members(self, obj):
        memberships = obj.memberships.filter(status='accepted')
        return ", ".join([m.user.outlook for m in memberships])

    get_members.short_description = "Members"
@admin.register(Membership)
class MembershipAdmin(admin.ModelAdmin):
    list_display = ('user', 'club', 'status', 'requested_at', 'updated_at')
    list_filter = ('status', 'club')
    search_fields = ('user__outlook', 'club__name')
