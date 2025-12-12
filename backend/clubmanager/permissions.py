from rest_framework import permissions
from .models import ClubManager
from clubs.models import Club

class IsClubManager(permissions.BasePermission):
    """
    Разрешает доступ, если request.user — менеджер данного клуба (через ClubManager),
    либо (опционально) если он совпадает с club.manager (если у тебя поле есть и ты хочешь допускать).
    """

    def has_permission(self, request, view):
        club_id = view.kwargs.get('club_id') or view.kwargs.get('id')  # поддержка разных kwarg имен
        if not club_id:
            return False
        # проверяем clubmanager table
        if ClubManager.objects.filter(user=request.user, club_id=club_id).exists():
            return True
        # при желании также разрешить основной manager в Club (если есть поле manager)
        try:
            if Club.objects.filter(id=club_id, manager=request.user).exists():
                return True
        except Exception:
            pass
        return False
