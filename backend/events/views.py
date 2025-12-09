from rest_framework import generics
from .models import Event
from .serializers import EventSerializer

class EventListView(generics.ListAPIView):
    """
    Список событий с фильтрацией по категории и цене (free/paid)
    """
    serializer_class = EventSerializer

    def get_queryset(self):
        queryset = Event.objects.all().order_by('date')
        category = self.request.query_params.get('category')
        free = self.request.query_params.get('free')

        if category:
            queryset = queryset.filter(category=category)
        if free == 'true':
            queryset = queryset.filter(price__isnull=True)
        elif free == 'false':
            queryset = queryset.filter(price__isnull=False)

        return queryset

class EventDetailView(generics.RetrieveAPIView):
    """
    Детали конкретного события
    """
    queryset = Event.objects.all()
    serializer_class = EventSerializer
