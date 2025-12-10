# clubs/serializers.py
from rest_framework import serializers
from .models import Membership, Club

class ClubSerializer(serializers.ModelSerializer):
    members = serializers.SerializerMethodField()  # <-- add this

    class Meta:
        model = Club
        fields = ['id', 'name', 'description', 'instagram_link', 'telegram_link', 'manager', 'members']  # <-- include members

    def get_members(self, obj):
        memberships = obj.memberships.filter(status='accepted')  # only accepted members
        return [
            {
                "id": m.user.id,
                "outlook": m.user.outlook,
                "first_name": m.user.first_name,
                "last_name": m.user.last_name,
                "avatar_url": m.user.avatar_url
            } 
            for m in memberships
        ]


class MembershipSerializer(serializers.ModelSerializer):
    class Meta:
        model = Membership
        fields = ['id', 'user', 'club', 'status', 'requested_at', 'updated_at']
        read_only_fields = ['status', 'requested_at', 'updated_at', 'user']


class MembershipActionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Membership
        fields = ['status']
