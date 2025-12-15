from rest_framework import serializers
from .models import News

class NewsSerializer(serializers.ModelSerializer):
    media_urls = serializers.SerializerMethodField()

    class Meta:
        model = News
        fields = ['id', 'title', 'content', 'media_url', 'created_at', 'media_urls'] 

    def get_media_urls(self, obj):
        if obj.media_url:  
            return [obj.media_url]  
        return [] 