from rest_framework import generics, permissions
from rest_framework.exceptions import ValidationError
from .models import ClubManager
from .serializers import ClubManagerSerializer
from .permissions import IsClubManager

# Импортируем реальные view/serializers из других apps
# Пример: предполагается, что в apps есть такие view-классы.
# Если в твоем проекте названия другие — подставь свои.
from clubs.models import Membership, Club
from clubs.serializers import MembershipSerializer, MembershipActionSerializer, ClubSerializer


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
        if getattr(self, 'swagger_fake_view', False):
            return Membership.objects.none()
        club_id = self.kwargs['club_id']
        return Membership.objects.filter(club_id=club_id, status='pending')

class UpdateMembershipStatusProxy(generics.UpdateAPIView):
    serializer_class = MembershipActionSerializer
    permission_classes = [permissions.IsAuthenticated, IsClubManager]

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return Membership.objects.none()
        club_id = self.kwargs['club_id']
        return Membership.objects.filter(club_id=club_id)

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


