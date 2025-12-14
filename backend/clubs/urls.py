# clubs/urls.py
from django.urls import path
from .views import (
    ApplyMembershipAPIView,
    UpdateMembershipStatusAPIView,
    PendingMembershipListAPIView,
    ClubListAPIView,
    ClubDetailAPIView,
    ClubCreateAPIView,
    ClubUpdateAPIView,
    ClubDeleteAPIView,
    ClubMembersListAPIView,
    UserClubsListAPIView
)

urlpatterns = [
    # Club endpoints
    path('', ClubListAPIView.as_view(), name='club_list'),          # List all clubs
    path('clubs/<int:pk>/', ClubDetailAPIView.as_view(), name='club_detail'),  # Retrieve a club
    path('clubs/create/', ClubCreateAPIView.as_view(), name='club_create'),     # Create a club
    path('clubs/<int:pk>/update/', ClubUpdateAPIView.as_view(), name='club_update'), # Update a club
    path('clubs/<int:pk>/delete/', ClubDeleteAPIView.as_view(), name='club_delete'), # Delete a club
    # Get members of a specific club
    path('clubs/<int:pk>/members/', ClubMembersListAPIView.as_view(), name='club_members'),


    # Membership endpoints
    path('membership/apply/', ApplyMembershipAPIView.as_view(), name='apply_membership'),  # User applies
    #path('membership/pending/', PendingMembershipListAPIView.as_view(), name='pending_memberships'), # Manager sees pending
    #path('membership/<int:pk>/update/', UpdateMembershipStatusAPIView.as_view(), name='update_membership'), # Manager updates status
    
    path('users/<uuid:user_id>/clubs/', UserClubsListAPIView.as_view(), name='user_clubs'),


]
