from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.views import LoginView
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.contrib.auth.views import LoginView
from django.http import JsonResponse
from django.contrib import messages
from django.urls import reverse
from aerolinea.models import Vuelo, Reserva, Usuario, Compra, CheckIn, Maleta, Rol
from datetime import date
from .forms import RegistroForm
import re

class CustomLoginView(LoginView):
    template_name = "registration/login.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["vuelos"] = Vuelo.objects.all()
        return context

def buscar_vuelos(request):
    origen = request.GET.get("origen")
    destino = request.GET.get("destino")
    vuelos = Vuelo.objects.all()

    if origen and destino:
        vuelos = vuelos.filter(origen__icontains=origen, destino__icontains=destino)

    return render(request, "buscar_vuelos.html", {"vuelos": vuelos})

@login_required(login_url="/accounts/login/")
def reservar_vuelo(request, vuelo_id):
    vuelo = get_object_or_404(Vuelo, id=vuelo_id)

    if request.method == "POST":
        usuario = Usuario.objects.get(user=request.user)
        num_tiquetes = request.POST.get("num_tiquetes", 1)
        reserva = Reserva.objects.create(
            usuario=usuario, vuelo=vuelo, estado="activa", num_tiquetes=num_tiquetes
        )

        return render(request, "reserva_confirmada.html", {"reserva": reserva})

    return render(request, "reservar_vuelo.html", {"vuelo": vuelo})

@login_required
def comprar_vuelo(request, reserva_id):
    reserva = get_object_or_404(Reserva, id=reserva_id)
    usuario = get_object_or_404(Usuario, user=request.user)

    if request.method == "POST":
        codigo_reserva = f"RES{reserva.id}"
        metodo_pago = request.POST.get("metodo_pago")
        compra = Compra.objects.create(
            usuario=usuario,
            vuelo=reserva.vuelo,
            codigo_reserva=codigo_reserva,
            metodo_pago=metodo_pago,
            estado="activa",
        )

        reserva.estado = "confirmada"
        reserva.save()

        return render(request, "compra_confirmada.html", {"compra": compra})

    return render(request, "comprar_vuelo.html", {"reserva": reserva})

@login_required
def checkin_vuelo(request, compra_id):
    compra = get_object_or_404(Compra, id=compra_id)
    usuario = get_object_or_404(Usuario, user=request.user)

    # (opcional) Validar que el usuario actual sea el dueño de la compra
    if compra.usuario != usuario:
        messages.error(
            request, "No puedes hacer check-in de una compra que no es tuya."
        )
        return redirect("buscar_vuelos")

    if request.method == "POST":
        asiento = request.POST.get("asiento")
        peso_maleta = request.POST.get("peso_maleta")

        if not asiento:  # Validación adicional
            messages.error(request, "Debes ingresar el asiento.")
            return redirect("checkin_vuelo", compra_id=compra.id)

        checkin = CheckIn.objects.create(compra=compra, asiento=asiento)

        if peso_maleta:
            Maleta.objects.create(
                checkin=checkin,
                peso=float(peso_maleta),
                costo=20000 if float(peso_maleta) <= 20 else 50000,
            )

        return render(request, "checkin_confirmado.html", {"checkin": checkin})

    return render(request, "checkin_vuelo.html", {"compra": compra})

def registro(request):
    if request.method == "POST":
        form = RegistroForm(request.POST, request.FILES)
        if form.is_valid():
            # Crear usuario base de Django
            user = User.objects.create_user(
                username=form.cleaned_data["username"],
                email=form.cleaned_data["email"],
                password=form.cleaned_data["password"]
            )

            # Obtener o crear rol
            rol_cliente, _ = Rol.objects.get_or_create(nombre="Cliente")

            # Crear usuario extendido
            Usuario.objects.create(
                user=user,
                rol=rol_cliente,
                email=form.cleaned_data["email"],
                password=form.cleaned_data["password"],
                nombres=form.cleaned_data["nombres"],
                apellidos=form.cleaned_data["apellidos"],
                dni=form.cleaned_data["dni"],
                lugar_nacimiento=form.cleaned_data["lugar_nacimiento"],
                fecha_nacimiento=form.cleaned_data["fecha_nacimiento"],
                direccion_facturacion=form.cleaned_data["direccion_facturacion"],
                genero=form.cleaned_data["genero"],
                imagen_usuario=form.cleaned_data.get("imagen_usuario")
            )

            messages.success(request, "Usuario registrado correctamente.")
            return redirect("login")
        else:
            # Aquí Django mantiene los datos y errores en el formulario
            return render(request, "registro.html", {"form": form})

    else:
        form = RegistroForm()

    return render(request, "registro.html", {"form": form})

def iniciar_sesion(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            # Redirección según tipo de usuario
            if hasattr(user, "usuario") and user.usuario.rol.nombre == "Administrador":
                return redirect("admin_dashboard")
            else:
                return redirect("buscar_vuelos")
    return render(request, "registration/login.html")

def cerrar_sesion(request):
    if request.user.is_authenticated:
        # Guardamos si era admin antes de hacer logout
        es_admin = (
            request.user.is_staff
            or request.user.is_superuser
            or (hasattr(request.user, "usuario") and request.user.usuario.es_admin)
        )
        logout(request)

        if es_admin:
            # Redirigir al login del admin (Django admin)
            return redirect("/admin/login/")
        else:
            # Redirigir al login normal de clientes
            return redirect("/accounts/login")
    else:
        return redirect("/accounts/login/")

def es_admin(user):
    return hasattr(user, "usuario") and user.usuario.rol.nombre == "Administrador"


@login_required
@user_passes_test(es_admin)
def admin_dashboard(request):
    return render(request, "admin/dashboard.html")

@login_required
@user_passes_test(es_admin)
def admin_vuelos(request):
    return render(request, "admin_vuelos.html")

@login_required
@user_passes_test(es_admin)
def admin_usuarios(request):
    return render(request, "admin_usuarios.html")

@login_required
@user_passes_test(es_admin)
def admin_roles(request):
    return render(request, "admin_roles.html")

def next_codigo_vuelo(request):
    """Vista para generar el siguiente código de vuelo"""
    tipo = request.GET.get("tipo")
    if tipo == "NACIONAL":
        prefix = "VN"
    else:
        prefix = "VI"

    last = (
        Vuelo.objects.filter(tipo=tipo, codigo__startswith=prefix)
        .order_by("-codigo")
        .first()
    )
    if last and last.codigo[2:].isdigit():
        next_num = int(last.codigo[2:]) + 1
    else:
        next_num = 1
    codigo = f"{prefix}{next_num:04d}"
    return JsonResponse({"codigo": codigo})

def get_options_vuelo(request):
    """Vista para obtener las opciones de origen y destino según el tipo de vuelo"""
    tipo = request.GET.get("tipo")
    
    if tipo == "NACIONAL":
        origen_options = Vuelo.VUELOS_NACIONALES
        destino_options = Vuelo.VUELOS_NACIONALES
    elif tipo == "INTERNACIONAL":
        origen_options = Vuelo.ORIGEN_INTERNACIONAL
        destino_options = Vuelo.DESTINO_INTERNACIONAL
    else:
        origen_options = []
        destino_options = []
    
    return JsonResponse({
        "origen_options": origen_options,
        "destino_options": destino_options
    })