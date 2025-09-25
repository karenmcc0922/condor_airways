from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.views import LoginView
from django.contrib import messages
from datetime import date

from .models import Vuelo, Reserva, Usuario, Compra, CheckIn, Maleta, Rol
from django.contrib.auth.views import LoginView
from .models import Vuelo

class CustomLoginView(LoginView):
    template_name = 'registration/login.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['vuelos'] = Vuelo.objects.all()
        return context

def buscar_vuelos(request):
    origen = request.GET.get('origen')
    destino = request.GET.get('destino')
    vuelos = Vuelo.objects.all()

    if origen and destino:
        vuelos = vuelos.filter(origen__nombre__icontains=origen, destino__nombre__icontains=destino)

    return render(request, 'buscar_vuelos.html', {'vuelos': vuelos})

@login_required(login_url='/accounts/login/')
def reservar_vuelo(request, vuelo_id):
    vuelo = get_object_or_404(Vuelo, id=vuelo_id)

    if request.method == "POST":
        usuario = Usuario.objects.get(user=request.user)
        num_tiquetes = request.POST.get("num_tiquetes",1)
        reserva = Reserva.objects.create(
            usuario=usuario,
            vuelo=vuelo,
            estado="activa",
            num_tiquetes=num_tiquetes
        )

        return render(request, "reserva_confirmada.html", {"reserva": reserva})

    return render(request, "reservar_vuelo.html", {"vuelo": vuelo})

@login_required
def comprar_vuelo(request, reserva_id):
    reserva = get_object_or_404(Reserva, id=reserva_id)
    usuario = get_object_or_404(Usuario, user=request.user)

    if request.method == "POST":
        codigo_reserva=f"RES{reserva.id}"
        metodo_pago=request.POST.get("metodo_pago")
        compra=Compra.objects.create(
            usuario=usuario,
            vuelo=reserva.vuelo,
            codigo_reserva=codigo_reserva,
            metodo_pago=metodo_pago,
            estado="activa"
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
        messages.error(request, "No puedes hacer check-in de una compra que no es tuya.")
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
                costo=20000 if float(peso_maleta) <= 20 else 50000
            )

        return render(request, "checkin_confirmado.html", {"checkin": checkin})

    return render(request, "checkin_vuelo.html", {"compra": compra})

def registro(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')
        fecha_nacimiento = request.POST.get('fecha_nacimiento')

        # Validaciones
        if not email:
            messages.error(request, "El correo electrónico es obligatorio.")
            return redirect('registro')

        if User.objects.filter(username=username).exists():
            messages.error(request, "El usuario ya existe.")
            return redirect('registro')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Ya existe un usuario con este correo.")
            return redirect('registro')
        
         # Validar edad realista
        try:
            fecha = date.fromisoformat(fecha_nacimiento)
            edad = (date.today() - fecha).days // 365
            if edad < 0 or edad > 120:
                messages.error(request, "Fecha de nacimiento inválida.")
                return redirect('registro')
        except:
            messages.error(request, "Fecha de nacimiento inválida.")
            return redirect('registro')

        # Crear usuario base de Django
        user = User.objects.create_user(username=username, email=email, password=password)

        # Obtener o crear rol
        rol_cliente, _ = Rol.objects.get_or_create(nombre="Cliente")

        # Crear usuario en aerolinea_usuario
        Usuario.objects.create(
            user=user,
            rol=rol_cliente,
            email=email,
            # Esto puede borrarse si no queremos la contraseña en texto plano
            password=password,
            nombre=username
        )

        messages.success(request, "Usuario registrado correctamente.")
        return redirect('login')

    return render(request, 'registro.html')

def iniciar_sesion(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            # Redirección según tipo de usuario
            if hasattr(user, 'usuario') and user.usuario.rol.nombre == "Administrador":
                return redirect('admin_dashboard')
            else:
                return redirect('buscar_vuelos')
    return render(request, 'registration/login.html')

def cerrar_sesion(request):
    logout(request)
    return redirect('login')

def es_admin(user):
    return hasattr(user,"usuario") and user.usuario.rol.nombre == "Administrador"

@login_required
@user_passes_test(es_admin)
def admin_dashboard(request):
    return render(request,"admin/dashboard.html")

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