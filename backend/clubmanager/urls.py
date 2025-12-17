from django.urls import path
from .views import (
    ClubManagersListAPIView, AddClubManagerAPIView,
    PendingMembershipListProxy, UpdateMembershipStatusProxy,
    ClubUpdateProxy, ClubDeleteProxy , ClubManagerStatusAPIView,  
)

urlpatterns = [
    # club management (managers)
    path('clubs/<int:club_id>/managers/', ClubManagersListAPIView.as_view(), name='clubmanager_managers_list'),
    path('clubs/<int:club_id>/managers/add/', AddClubManagerAPIView.as_view(), name='clubmanager_managers_add'),

    # membership management
    path('clubs/<int:club_id>/membership/pending/', PendingMembershipListProxy.as_view(), name='clubmanager_membership_pending'),
    path('clubs/<int:club_id>/membership/<int:pk>/update/', UpdateMembershipStatusProxy.as_view(), name='clubmanager_membership_update'),

    # clubs CRUD proxies
    #path('clubs/<int:pk>/update/', ClubUpdateProxy.as_view(), name='clubmanager_club_update'),
    path('clubs/<int:pk>/delete/', ClubDeleteProxy.as_view(), name='clubmanager_club_delete'),
    path('status/', ClubManagerStatusAPIView.as_view(), name='clubmanager_status'),

]
