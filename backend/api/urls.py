from django.urls import path
from .views import RegisterAPIView, login_view, logout_view, UserListAPIView

urlpatterns = [
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),
    path('users/', UserListAPIView.as_view(), name='user_list'),
]
