from rest_framework import generics, permissions
from rest_framework.exceptions import PermissionDenied, ValidationError
from .models import Club, Membership
from .serializers import ClubSerializer, MembershipSerializer, MembershipActionSerializer , MembershipApplySerializer 

# List all clubs
class ClubListAPIView(generics.ListAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.AllowAny]

# Retrieve a single club
class ClubDetailAPIView(generics.RetrieveAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.AllowAny]

# Create a club (manager/admin only)
class ClubCreateAPIView(generics.CreateAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(manager=self.request.user)

# Update a club (only manager can update)
class ClubUpdateAPIView(generics.UpdateAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        club = super().get_object()
        if club.manager != self.request.user:
            raise PermissionDenied("You are not the manager of this club.")
        return club

# Delete a club (manager/admin only)
class ClubDeleteAPIView(generics.DestroyAPIView):
    queryset = Club.objects.all()
    serializer_class = ClubSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        club = super().get_object()
        if club.manager != self.request.user and not self.request.user.is_superuser:
            raise PermissionDenied("You are not allowed to delete this club.")
        return club


# Membership 
# Membership 
class MembershipApplyView(generics.CreateAPIView):
    """
    Apply to a club (authenticated users only)
    """
    queryset = Membership.objects.all()
    serializer_class = MembershipApplySerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        club = serializer.validated_data['club']
        # Prevent duplicate applications
        if Membership.objects.filter(user=self.request.user, club=club).exists():
            raise ValidationError("You have already applied to this club.")
        serializer.save(user=self.request.user, status='pending')


class ApplyMembershipAPIView(generics.CreateAPIView):
    queryset = Membership.objects.all()
    serializer_class = MembershipSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def perform_create(self, serializer):
    # Prevent duplicate applications
        club = serializer.validated_data['club']
        if Membership.objects.filter(user=self.request.user, club=club).exists():
            raise ValidationError("You have already applied to this club.")
        serializer.save(user=self.request.user, status='pending')



# 2. Manager updates membership status
class UpdateMembershipStatusAPIView(generics.UpdateAPIView):
    queryset = Membership.objects.all()
    serializer_class = MembershipActionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        membership = super().get_object()
        # Only club manager can update membership
        if membership.club.manager != self.request.user:
            raise PermissionDenied("You are not the manager of this club.")
        return membership


# 3. Manager views pending memberships for their clubs
class PendingMembershipListAPIView(generics.ListAPIView):
    serializer_class = MembershipSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Only memberships for clubs managed by the current user
        return Membership.objects.filter(
            club__manager=self.request.user,
            status='pending'
        )
class ClubMembersListAPIView(generics.ListAPIView):
    serializer_class = MembershipSerializer
    permission_classes = [permissions.AllowAny]  # anyone can see members

class ClubMembersListAPIView(generics.ListAPIView):
    serializer_class = MembershipSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return Membership.objects.none()  # prevents error during schema generation

        club_id = self.kwargs['pk']
        return Membership.objects.filter(club_id=club_id, status='accepted')
    
    
class UserClubsListAPIView(generics.ListAPIView):
    serializer_class = ClubSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        return Club.objects.filter(
            memberships__user_id=user_id,
            memberships__status='accepted'
        ).distinct() 
