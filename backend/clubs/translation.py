from modeltranslation.translator import register, TranslationOptions
from .models import Club

@register(Club)
class ClubTranslationOptions(TranslationOptions):
    fields = ('name', 'description')
