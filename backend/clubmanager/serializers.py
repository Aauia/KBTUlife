from rest_framework import serializers
from .models import ClubManager


class ClubManagerSerializer(serializers.ModelSerializer):
    user_outlook = serializers.CharField(source='user.outlook', read_only=True)
    user_name = serializers.SerializerMethodField()

    class Meta:
        model = ClubManager
        fields = ['id', 'club', 'user', 'user_outlook', 'user_name', 'role']

    def get_user_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    
    
