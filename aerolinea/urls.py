from django.urls import path
from . import views
from django.contrib.auth.views import LogoutView
from django.contrib.auth import views as auth_views

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
    path('admin/vuelos/', views.admin_vuelos, name='admin_vuelos'),
    path('admin/usuarios/', views.admin_usuarios, name='admin_usuarios'),
    path('admin/roles/', views.admin_roles, name='roles'),
    path('api/next-codigo/', views.next_codigo_vuelo, name='next_codigo_vuelo'),
    path('api/get_options/', views.get_options_vuelo, name='get_options_vuelo'),
    path('api/calcular_tiempo_vuelo/', views.calcular_tiempo_vuelo, name='calcular_tiempo_vuelo'),
    path("api/departamentos/<int:pais_id>/", views.obtener_departamentos, name="obtener_departamentos"),
    path("api/municipios/<int:departamento_id>/", views.obtener_municipios, name="obtener_municipios"),
    path("crear_admin/", views.crear_admin, name="crear_admin"),
    path("root/eliminar_admin/<int:admin_id>/", views.eliminar_admin, name="eliminar_admin"),
    path("root/dashboard/", views.root_dashboard, name="root_dashboard"),
    path("completar_registro_admin/", views.completar_registro_admin, name="completar_registro_admin"),
    path("root/cambiar_password/", views.root_cambiar_password, name="root_cambiar_password"),
    path("admin_dashboard/", views.admin_dashboard, name="admin_dashboard"),
    path("finanzas/tarjetas/", views.tarjetas_usuario, name="tarjetas_usuario"),
    path("finanzas/tarjetas/agregar/", views.agregar_tarjeta, name="agregar_tarjeta"),
    path("finanzas/tarjetas/eliminar/<int:tarjeta_id>/", views.eliminar_tarjeta, name="eliminar_tarjeta"),
    path("finanzas/tarjetas/", views.gestionar_tarjetas, name="gestionar_tarjetas"),
    path("carrito/", views.ver_carrito, name='ver_carrito'),
    path('carrito/agregar/<int:vuelo_id>', views.agregar_al_carrito, name='agregar_al_carrito'),
    path('carrito/eliminar/<int:item_id>', views.eliminar_del_carrito, name='eliminar_del_carrito'),
]

