from rest_framework import serializers
from .models import Event
from django.utils import translation

class EventSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()
    description = serializers.SerializerMethodField()
    location = serializers.SerializerMethodField()

    class Meta:
        model = Event
        fields = [
            'id',
            'name',
            'description',
            'location',
            'club',
            'date',
            'price',
            'category',
            'is_free',
            'media_urls',
            'tickets_available',
            'created_at'
        ]

    def get_name(self, obj):
        lang = self.context.get('request').LANGUAGE_CODE
        return getattr(obj, f"name_{lang}", obj.name)

    def get_description(self, obj):
        lang = self.context.get('request').LANGUAGE_CODE
        return getattr(obj, f"description_{lang}", obj.description)

    def get_location(self, obj):
        lang = self.context.get('request').LANGUAGE_CODE
        return getattr(obj, f"location_{lang}", obj.location)
