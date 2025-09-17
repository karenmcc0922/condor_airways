from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect
from aerolinea.views import CustomLoginView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', lambda request: redirect('buscar_vuelos')),
    path('', include("aerolinea.urls")), 
    path('accounts/login/', CustomLoginView.as_view(), name='login'),
]