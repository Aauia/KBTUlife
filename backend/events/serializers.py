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
        lang = translation.get_language()
        value = getattr(obj, f"name_{lang}", None)
        if not value:
            value = getattr(obj, f"name_ru", obj.name)  # fallback на русский
        return value

    def get_description(self, obj):
        lang = translation.get_language()
        value = getattr(obj, f"description_{lang}", None)
        if not value:
            value = getattr(obj, f"description_ru", obj.description)
        return value

    def get_location(self, obj):
        lang = translation.get_language()
        value = getattr(obj, f"location_{lang}", None)
        if not value:
            value = getattr(obj, f"location_ru", obj.location)
        return value
