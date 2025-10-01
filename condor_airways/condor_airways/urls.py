from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect
from aerolinea.views import CustomLoginView
from aerolinea import views

urlpatterns = [
    path('admin/logout/', views.cerrar_sesion, name='admin_logout'),
    path('admin/', admin.site.urls),
    path('', lambda request: redirect('buscar_vuelos')),
    path('django-admin/',admin.site.urls),
    path('', include("aerolinea.urls")), 
    path('accounts/login/', CustomLoginView.as_view(), name='login'),    
]