from rest_framework import generics, permissions
from rest_framework.views import APIView
from rest_framework.exceptions import ValidationError
from .models import ClubManager
from .serializers import ClubManagerSerializer
from .permissions import IsClubManager
from rest_framework.response import Response
# Импортируем реальные view/serializers из других apps
# Пример: предполагается, что в apps есть такие view-классы.
# Если в твоем проекте названия другие — подставь свои.
from clubs.models import Membership, Club
from clubs.serializers import MembershipSerializer, MembershipActionSerializer, ClubSerializer
from rest_framework.permissions import IsAuthenticated  


# ---------- Club manager endpoints (managers list / add) ----------
class ClubManagersListAPIView(generics.ListAPIView):
    serializer_class = ClubManagerSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return ClubManager.objects.none()
        club_id = self.kwargs['club_id']
        return ClubManager.objects.filter(club_id=club_id)


class AddClubManagerAPIView(generics.CreateAPIView):
    serializer_class = ClubManagerSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def perform_create(self, serializer):
        if getattr(self, 'swagger_fake_view', False):
            return None
        club_id = self.kwargs['club_id']
        new_user = serializer.validated_data['user']
        if ClubManager.objects.filter(user=new_user, club_id=club_id).exists():
            raise ValidationError("User is already a manager.")
        serializer.save(club_id=club_id)

# ---------- Membership manager endpoints (use clubs serializers/models) ----------
class PendingMembershipListProxy(generics.ListAPIView):
    serializer_class = MembershipSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def get_queryset(self):
        # This detects if Swagger is generating schema
        if getattr(self, 'swagger_fake_view', False):
            return Membership.objects.none()

        club_id = self.kwargs['club_id']
        self.club_id = club_id  # for permission check
        return Membership.objects.filter(club_id=club_id, status='pending')
    
    
class UpdateMembershipStatusProxy(generics.UpdateAPIView):
    permission_classes = [permissions.IsAuthenticated, IsClubManager]
    serializer_class = MembershipActionSerializer

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return Membership.objects.none()

        club_id = self.kwargs['club_id']
        self.club_id = club_id  # Important for IsClubManager permission
        return Membership.objects.filter(club_id=club_id)

    def partial_update(self, request, *args, **kwargs):
        membership = self.get_object()
        serializer = self.get_serializer(membership, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        # Return full details after update
        response_serializer = MembershipSerializer(membership)
        return Response(response_serializer.data)


# ---------- Clubs proxies (update/delete) ----------
class ClubUpdateProxy(generics.UpdateAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def get_object(self):
        if getattr(self, 'swagger_fake_view', False):
            return None
        obj = super().get_object()
        # IsClubManager already checks; returning obj is fine
        return obj

class ClubDeleteProxy(generics.DestroyAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def get_object(self):
        if getattr(self, 'swagger_fake_view', False):
            return None
        return super().get_object()



class ClubManagerStatusAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        qs = ClubManager.objects.filter(user=request.user).select_related('club')

        return Response({
            "is_manager": qs.exists(),
            "managed_clubs": [
                {
                    "id": cm.club.id,
                    "name": cm.club.name,
                    "description": cm.club.description,
                }
                for cm in qs
            ]
        })