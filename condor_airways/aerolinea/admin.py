from django.contrib import admin
from .models import (
    Rol, Usuario, Vuelo, Reserva, Compra, CheckIn, Maleta,
    HistorialOperacion, Publicacion, Comentario, Notificacion
)

# Mostrar columnas clave en el admin
@admin.register(Rol)
class RolAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre')
    search_fields = ('nombre',)

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre', 'email', 'rol')
    list_filter = ('rol',)
    search_fields = ('nombre', 'email')

@admin.register(Vuelo)
class VueloAdmin(admin.ModelAdmin):
    list_display = ('id', 'codigo', 'origen', 'destino', 'fecha_salida', 'fecha_llegada', 'precio')
    list_filter = ('origen', 'destino')
    search_fields = ('codigo',)


@admin.register(Reserva)
class ReservaAdmin(admin.ModelAdmin):
    list_display = ('id', 'usuario', 'vuelo', 'fecha_reserva', 'estado', 'num_tiquetes')
    list_filter = ('estado', 'fecha_reserva')
    search_fields = ('usuario__nombre',)


@admin.register(Compra)
class CompraAdmin(admin.ModelAdmin):
    list_display = ('id', 'usuario', 'vuelo', 'codigo_reserva', 'metodo_pago', 'estado')
    list_filter = ('estado', 'metodo_pago')
    search_fields = ('codigo_reserva', 'usuario__nombre')

@admin.register(CheckIn)
class CheckInAdmin(admin.ModelAdmin):
    list_display = ('id', 'compra', 'asiento')
    search_fields = ('asiento', 'compra__codigo_reserva')

@admin.register(Maleta)
class MaletaAdmin(admin.ModelAdmin):
    list_display = ('id', 'checkin', 'peso', 'costo')
    search_fields = ('checkin__id',)

admin.site.register(HistorialOperacion)
admin.site.register(Publicacion)
admin.site.register(Comentario)
admin.site.register(Notificacion)