# api/views.py

from rest_framework import generics, permissions, status
from rest_framework.response import Response
from django.contrib.auth import login, logout
from rest_framework.views import APIView
from .models import CustomUser
from .serializers import RegisterSerializer, LoginSerializer, UserSerializer
from drf_yasg.utils import swagger_auto_schema

class MeAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)

class RegisterAPIView(generics.CreateAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

class LoginAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    @swagger_auto_schema(
        request_body=LoginSerializer,
        operation_description="Log in a user via email and password.",
        responses={
            200: "Logged in successfully",
            400: "Invalid credentials"
        }
    )
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        login(request, user)
        return Response({
            "message": "Logged in successfully",
            "user": UserSerializer(user).data
        })

class LogoutAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    
    @swagger_auto_schema(
        operation_description="Log out the current user",
        responses={200: "Logged out successfully"}
    )
    def post(self, request):
        logout(request)
        return Response({"message": "Logged out successfully"})

class UserListAPIView(generics.ListAPIView):
    serializer_class = UserSerializer
    queryset = CustomUser.objects.all()
    permission_classes = [permissions.IsAuthenticated]