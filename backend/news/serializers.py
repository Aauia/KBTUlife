from rest_framework import serializers
from .models import News
from django.utils import translation

class NewsSerializer(serializers.ModelSerializer):
    title = serializers.SerializerMethodField()
    content = serializers.SerializerMethodField()

    class Meta:
        model = News
        fields = '__all__'

    def get_title(self, obj):
        lang = self.context.get('request').LANGUAGE_CODE
        return getattr(obj, f"title_{lang}", obj.title)

    def get_content(self, obj):
        lang = self.context.get('request').LANGUAGE_CODE
        return getattr(obj, f"content_{lang}", obj.content)
