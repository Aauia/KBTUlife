from django.urls import path, include
from .views import TicketViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'', TicketViewSet, basename='ticket')

urlpatterns = router.urls
