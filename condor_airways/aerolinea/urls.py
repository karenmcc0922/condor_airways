from django.urls import path
from . import views
from django.contrib.auth.views import LogoutView
from .views import CustomLoginView, admin_dashboard, admin_roles, admin_usuarios, admin_vuelos

urlpatterns = [
    path('buscar-vuelos/', views.buscar_vuelos, name='buscar_vuelos'),
    path('reservar-vuelo/<int:vuelo_id>/', views.reservar_vuelo, name='reservar_vuelo'),
    path('comprar-vuelo/<int:reserva_id>/', views.comprar_vuelo, name='comprar_vuelo'),
    path('checkin-vuelo/<int:compra_id>/', views.checkin_vuelo, name='checkin_vuelo'),
    path('registro/', views.registro, name='registro'),
    path('login/', views.iniciar_sesion, name='login'),
    path('logout/', LogoutView.as_view(next_page='buscar_vuelos'), name='cerrar_sesion'),
    path('admin/login/',CustomLoginView.as_view(),name='admin_login'),
    path('admin-dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('admin/vuelos/', views.admin_vuelos, name='admin_vuelos'),
    path('admin/usuarios/', views.admin_usuarios, name='admin_usuarios'),
    path('admin/roles/', views.admin_roles, name='roles'),
]

