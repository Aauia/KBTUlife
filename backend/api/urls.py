from django.urls import path
from .views import LoginAPIView, LogoutAPIView, RegisterAPIView, UserListAPIView, MeAPIView

urlpatterns = [
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('login/', LoginAPIView.as_view(), name='login'),
    path('logout/', LogoutAPIView.as_view(), name='logout'),
    path('users/', UserListAPIView.as_view(), name='user_list'),
    path('me/', MeAPIView.as_view(), name='me'),  # вот твой endpoint для проверки себя
]
