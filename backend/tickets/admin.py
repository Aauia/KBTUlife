from django.contrib import admin
from .models import Ticket

@admin.register(Ticket)
class TicketAdmin(admin.ModelAdmin):
    list_display = (
        'id',
        'user_email_display',
        'event',
        'payment_status_display',  
        'used',
        'used_at',
        'created_at',
        'qrcode_link', 
    )
    
    list_filter = (
        'payment_status',
        'used',
        'event',
        'created_at',
        'event__date',       
    )
    
    search_fields = (
        'user__outlook',          
        'user__first_name',
        'user__last_name',
        'event__name',
        'qrcode__str',            
    )
    
    readonly_fields = (
        'qrcode',
        'qr_code_preview',        
        'created_at',
        'used_at',
        'user_email_display',
    )
    
    autocomplete_fields = ('user', 'event')
    
    fields = (
        'user',
        'user_email_display',            
        'event',
        'payment_status',
        'used',
        'used_at',
        'notes',
        'qrcode',
        'qr_code_preview',
        'created_at',
    )
    
    def user_email_display(self, obj):
        return obj.user.outlook if obj.user else '-'
    user_email_display.short_description = 'Email пользователя'
    user_email_display.admin_order_field = 'user__outlook'

    def payment_status_display(self, obj):
        status_colors = {
            'unpaid': '🔴',
            'pending': '🟡',
            'paid': '🟢',
            'rejected': '❌',
        }
        emoji = status_colors.get(obj.payment_status, '⚪')
        return f"{emoji} {obj.get_payment_status_display()}"
    payment_status_display.short_description = 'Статус оплаты'

    def qrcode_link(self, obj):
        if obj.id:
            url = f"/admin/tickets/ticket/{obj.id}/change/"
            return f"<a href='{url}' target='_blank'>{obj.qrcode}</a>"
        return "-"
    qrcode_link.short_description = 'QR-код'
    qrcode_link.allow_tags = True

    def qr_code_preview(self, obj):
        if obj.qrcode:
            import qrcode
            from io import BytesIO
            import base64
            
            qr = qrcode.QRCode(box_size=10, border=4)
            qr.add_data(str(obj.qrcode))
            qr.make(fit=True)
            img = qr.make_image(fill_color="black", back_color="white")
            
            buffer = BytesIO()
            img.save(buffer, format='PNG')
            image_base64 = base64.b64encode(buffer.getvalue()).decode()
            
            return f'<img src="data:image/png;base64,{image_base64}" width="200"/>'
        return "Нет QR-кода"
    qr_code_preview.short_description = 'Превью QR-кода'
    qr_code_preview.allow_tags = True