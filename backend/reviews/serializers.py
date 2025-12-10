from rest_framework import serializers
from .models import Review

class ReviewSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.first_name', read_only=True)

    class Meta:
        model = Review
        fields = (
            'id',
            'event',
            'user',
            'user_name',
            'rating',
            'text',
            'created_at',
            'updated_at'
        )
        read_only_fields = ('user', 'event')