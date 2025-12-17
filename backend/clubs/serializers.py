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
    user_name = serializers.CharField(source='user.first_name', read_only=True)
    user_surname = serializers.CharField(source='user.last_name', read_only=True)
    user_outlook = serializers.CharField(source='user.outlook', read_only=True)
    club_name = serializers.CharField(source='club.name', read_only=True)

    class Meta:
        model = Membership
        fields = [
            'id',
            'status',
            'user_name',
            'user_surname',
            'user_outlook',
            'club_name',
        ]
class MembershipActionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Membership
        fields = ['status']
        
class MembershipApplySerializer(serializers.ModelSerializer):
    club = serializers.PrimaryKeyRelatedField(queryset=Club.objects.all())
    user_name = serializers.CharField(source='user.first_name', read_only=True)
    user_surname = serializers.CharField(source='user.last_name', read_only=True)
    user_outlook = serializers.CharField(source='user.outlook', read_only=True)
    club_name = serializers.CharField(source='club.name', read_only=True)

    class Meta:
        model = Membership
        fields = ['id', 'status', 'user_name', 'user_surname', 'user_outlook', 'club_name', 'club']
