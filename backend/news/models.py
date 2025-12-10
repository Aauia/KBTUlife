from django.db import models
import uuid

class News(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    media_url = models.URLField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.title