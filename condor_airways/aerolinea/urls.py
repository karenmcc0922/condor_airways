from django.urls import path
from . import views
from django.contrib.auth.views import LogoutView

urlpatterns = [
    path('panel-admin/', views.panel_admin, name='panel_admin'),
    path('buscar-vuelos/', views.buscar_vuelos, name='buscar_vuelos'),
    path('reservar-vuelo/<int:vuelo_id>/', views.reservar_vuelo, name='reservar_vuelo'),
    path('comprar-vuelo/<int:reserva_id>/', views.comprar_vuelo, name='comprar_vuelo'),
    path('checkin-vuelo/<int:compra_id>/', views.checkin_vuelo, name='checkin_vuelo'),
    path('registro/', views.registro, name='registro'),
    path('login/', views.iniciar_sesion, name='login'),
    path('logout/', LogoutView.as_view(next_page='buscar_vuelos'), name='cerrar_sesion'),
]
