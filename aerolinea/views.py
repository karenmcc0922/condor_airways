from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.views import LoginView
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.http import JsonResponse
from django.contrib import messages
from django.urls import reverse
from django.utils import timezone
from django.core.mail import send_mail
from django.conf import settings
from aerolinea.models import Vuelo, Reserva, Usuario, Compra, CheckIn, Maleta, Rol, Departamento, Municipio, Tarjeta, Carrito, CarritoItem
from datetime import date, timedelta
from .forms import RegistroForm, CompletarAdminForm, RootPasswordForm, VueloAdminForm, TarjetaForm
import re
import random

class CustomLoginView(LoginView):
    template_name = "registration/login.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["vuelos"] = Vuelo.objects.all()
        return context

    """
        Hacemos login explícito y redirigimos según rol:
        - root (usuario con atributo es_root True) -> root_dashboard
        - admin (usuario con usuario.es_admin True) -> admin (Django)
        - cliente -> buscar_vuelos
    """
    def form_valid(self, form):
        user = form.get_user()
        login(self.request, user)

        # Root
        if hasattr(user, "usuario") and getattr(user.usuario, "es_root", False):
            return redirect("root_dashboard")

        # Administrador normal (usa panel de Django)
        if hasattr(user, "usuario") and getattr(user.usuario, "es_admin", False):
            if not user.usuario.registro_completo:
                return redirect("completar_registro_admin")
            return redirect("admin_dashboard")

        # Usuario cliente
        return redirect("buscar_vuelos")
    
@login_required
def crear_admin(request):
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_root:
        messages.error(request, "Solo el usuario root puede crear administradores.")
        return redirect("buscar_vuelos")

    if request.method == "POST":
        print("Datos recibidos del formulario:",request.POST)
        form = RegistroForm(request.POST, request.FILES)
        if form.is_valid():
            try:
                # Crear usuario Django con permisos administrativos
                user = User.objects.create_user(
                    username=form.cleaned_data["username"],
                    email=form.cleaned_data["email"],
                    password=form.cleaned_data["password"]
                )
                user.is_staff = True  # clave: da acceso al panel admin de Django
                user.save()

                rol_admin, _ = Rol.objects.get_or_create(nombre="Administrador")

                # Crear el perfil extendido
                Usuario.objects.create(
                    user=user,
                    rol=rol_admin,
                    email=form.cleaned_data["email"],
                    password=form.cleaned_data["password"],
                    nombres=form.cleaned_data["nombres"],
                    apellidos=form.cleaned_data["apellidos"],
                    dni=form.cleaned_data["dni"],
                    pais=form.cleaned_data["pais"],
                    departamento=form.cleaned_data["departamento"],
                    municipio=form.cleaned_data["municipio"],
                    fecha_nacimiento=form.cleaned_data["fecha_nacimiento"],
                    direccion_facturacion=form.cleaned_data["direccion_facturacion"],
                    genero=form.cleaned_data["genero"],
                    imagen_usuario=form.cleaned_data.get("imagen_usuario"),
                    es_admin=True,
                    registro_completo=True
                )

            except Exception as e:
                messages.error(request, f"Error al crear administrador: {e}")
                print("Error creando administrador:", e)

        else:
            messages.error(request, "Formulario inválido. Verifica los campos.")
            print("Errores del formulario:", form.errors)
    else:
        form = RegistroForm()

    return render(request, "root_dashboard.html", {"form": form})

@login_required
def eliminar_admin(request, admin_id):
    """Permite al root eliminar un administrador."""
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_root:
        messages.error(request, "No tienes permiso para realizar esta acción.")
        return redirect("buscar_vuelos")

    try:
        admin_usuario = Usuario.objects.get(id=admin_id, es_admin=True)
        nombre_admin = f"{admin_usuario.nombres} {admin_usuario.apellidos}"
        admin_usuario.user.delete()  # Esto elimina también el User base
        admin_usuario.delete()
        messages.success(request, f"El administrador '{nombre_admin}' fue eliminado correctamente.")
    except Usuario.DoesNotExist:
        messages.error(request, "El administrador no existe o ya fue eliminado.")
    except Exception as e:
        messages.error(request, f"Ocurrió un error al eliminar el administrador: {e}")

    return redirect("root_dashboard")

@login_required
def completar_registro_admin(request):
    """Permite al administrador completar su información personal."""
    # Verificar que el usuario sea admin
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_admin:
        messages.error(request, "No tienes permiso para acceder a esta sección.")
        return redirect("buscar_vuelos")

    usuario = request.user.usuario

    # Si ya completó el registro, redirigir al panel admin
    if usuario.registro_completo:
        return redirect("admin_dashboard")

    if request.method == "POST":
        form = CompletarAdminForm(request.POST, request.FILES, instance=usuario)
        print("Datos recibidos:",request.POST)
        if form.is_valid():
            print("Formulario válido")
            usuario = form.save(commit=False)
            usuario.registro_completo = True
            usuario.save()
            print("Usuario actualizado:",usuario.id)
            messages.success(request, "Registro completado correctamente. Ahora puedes acceder al panel de administración.")
            return redirect("admin_dashboard")
        else:
            print("Errores del formulario:",form.errors)
    else:
        form = CompletarAdminForm(instance=usuario)

    return render(request, "completar_registro_admin.html", {"form": form})
    
@login_required
def admin_dashboard(request):
    # Verifica que sea admin
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_admin:
        messages.error(request, "No tienes permisos para acceder a esta página.")
        return redirect("buscar_vuelos")
    
    print("Entrando a admin_dashboard...")

    if request.method == "POST":
        print("POST recibido:", request.POST)
        form = VueloAdminForm(request.POST, request.FILES)
        if form.is_valid():
            vuelo = form.save()
            vuelo.refresh_from_db()
            messages.success(request, f"Vuelo {vuelo.codigo} creado correctamente.")
            return redirect("admin_dashboard")
        else:
            print("Errores del formulario:", form.errors)
            messages.error(request, "Por favor corrige los errores del formulario.")
    else:
        form = VueloAdminForm()
        print("Formulario creado correctamente")

    # Listar vuelos creados
    vuelos = Vuelo.objects.all().order_by("-fecha_salida")
    print(f"Vuelos cargados: {vuelos.count()}")

    return render(request, "admin_dashboard.html", {"form":form,"vuelos":vuelos})

@login_required
def root_dashboard(request):
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_root:
        messages.error(request, "No tienes permiso para acceder a esta sección.")
        return redirect("buscar_vuelos")

    # Crear admin desde el panel del root
    if request.method == "POST":
        username = request.POST.get("username")
        email = request.POST.get("email")
        password = request.POST.get("password")

        if not username or not password:
            messages.error(request, "Debes ingresar usuario y contraseña.")
            return redirect("root_dashboard")

        # Verificar si ya existe el usuario
        if User.objects.filter(username=username).exists():
            messages.error(request, "Ese nombre de usuario ya existe.")
            return redirect("root_dashboard")

        rol_admin, _ = Rol.objects.get_or_create(nombre="Administrador")

        # Crear usuario base de Django
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password
        )

        # Crear perfil de Usuario
        Usuario.objects.create(
            user=user,
            rol=rol_admin,
            email=email,
            password=password,
            nombres="Pendiente",
            apellidos="Pendiente",
            fecha_nacimiento=date(2000,1,1), #Valor temporal
            dni=f"TEMP{user.id}",
            direccion_facturacion="Sin definir",
            genero="O",
            es_admin=True,
            registro_completo=False
        )
        messages.success(request, f"Administrador '{username}' creado correctamente.")
        return redirect("root_dashboard")

    # Mostrar lista de administradores existentes
    administradores = Usuario.objects.filter(es_admin=True)
    return render(request, "root_dashboard.html", {"administradores": administradores})

@login_required
def root_cambiar_password(request):
    # Validar que sea el root real
    if not hasattr(request.user, "usuario") or not request.user.usuario.es_root:
        messages.error(request, "No tienes permiso para acceder a esta sección.")
        return redirect("buscar_vuelos")

    if request.method == "POST":
        form = RootPasswordForm(user=request.user, data=request.POST)
        if form.is_valid():
            user = form.save()
            #update_session_auth_hash(request, user)  # Mantiene la sesión activa tras cambiar la contraseña
            messages.success(request, "Tu contraseña se ha actualizado correctamente.")
            return redirect("root_dashboard")
        else:
            messages.error(request, "Corrige los errores del formulario.")
    else:
        form = RootPasswordForm(user=request.user)

    return render(request, "root_cambiar_password.html", {"form": form})

def buscar_vuelos(request):
    origen = request.GET.get("origen")
    destino = request.GET.get("destino")
    vuelos = Vuelo.objects.all()

    if origen:
        vuelos = vuelos.filter(origen__icontains=origen)
    if destino:
        vuelos = vuelos.filter(destino__icontains=destino)

    return render(request, "buscar_vuelos.html", {"vuelos": vuelos})

def obtener_departamentos(request, pais_id):
    departamentos = Departamento.objects.filter(pais_id=pais_id).values("id", "nombre")
    return JsonResponse(list(departamentos), safe=False)

def obtener_municipios(request, departamento_id):
    municipios = Municipio.objects.filter(departamento_id=departamento_id).values("id", "nombre")
    return JsonResponse(list(municipios), safe=False)

@login_required(login_url="/accounts/login/")
def reservar_vuelo(request, vuelo_id):
    vuelo = get_object_or_404(Vuelo, id=vuelo_id)
    usuario = get_object_or_404(Usuario, user=request.user)

    reserva_existente = Reserva.objects.filter(usuario=usuario, vuelo=vuelo, estado='activa').exists()
    if reserva_existente:
        messages.warning(request, "Ya tienes una reserva activa para este vuelo.")
        return redirect("ver_carrito")

    if request.method == "POST":
        clase = request.POST.get("clase", "economica")
        num_tiquetes = int(request.POST.get("num_tiquetes", 1))

        reserva = Reserva.objects.create(
            usuario=usuario, 
            vuelo=vuelo, 
            clase=clase,
            estado="activa", 
            num_tiquetes=num_tiquetes
        )

        carrito, _ = Carrito.objects.get_or_create(usuario=usuario)
        CarritoItem.objects.create(
            carrito=carrito, 
            vuelo=vuelo, 
            reserva=reserva,
            cantidad=num_tiquetes
        )

        messages.success(request, f"Reserva creada y añadida al carrito para el vuelo {vuelo.codigo}.")
        return render(request, "reserva_confirmada.html", {"reserva": reserva})

    return render(request, "reservar_vuelo.html", {"vuelo": vuelo})

@login_required
def comprar_vuelo(request, reserva_id):
    reserva = get_object_or_404(Reserva, id=reserva_id)
    usuario = get_object_or_404(Usuario, user=request.user)
    vuelo = reserva.vuelo

    # --- Restricción: los admins/root no pueden comprar ---
    if usuario.es_admin or usuario.es_root:
        messages.error(request, "Los administradores no pueden realizar compras.")
        return redirect("buscar_vuelos")

    tarjetas = Tarjeta.objects.filter(usuario=request.user)

    if request.method == "POST":
        tarjeta_id = request.POST.get("tarjeta")

        if not tarjeta_id:
            messages.error(request, "Debes seleccionar una tarjeta para realizar el pago.")
            return redirect("comprar_vuelo", reserva_id=reserva.id)

        tarjeta = get_object_or_404(Tarjeta, id=tarjeta_id, usuario=request.user)

        # --- Verificación de saldo ---
        total = vuelo.precio * reserva.num_tiquetes
        if tarjeta.saldo < total:
            messages.error(request, "Saldo insuficiente en la tarjeta seleccionada.")
            return redirect("comprar_vuelo", reserva_id=reserva.id)

        # --- Descontar saldo ---
        tarjeta.saldo -= total
        tarjeta.save()

        # --- Generar código de reserva único ---
        codigo_reserva = f"R-{timezone.now().strftime('%Y%m%d%H%M%S')}-{random.randint(100,999)}"

        # --- Asignar asiento aleatorio ---
        filas = range(1, 31)
        letras = ['A', 'B', 'C', 'D', 'E', 'F']
        asiento = f"{random.choice(filas)}{random.choice(letras)}"

        # --- Crear compra ---
        compra = Compra.objects.create(
            usuario=usuario,
            vuelo=vuelo,
            codigo_reserva=codigo_reserva,
            metodo_pago=f"Tarjeta {tarjeta.tipo}",
            estado="activa",
        )

        # --- Asignar asiento (opcional: crea modelo Silla) ---
        # Si tienes un modelo Silla relacionado:
        # Silla.objects.create(compra=compra, numero=asiento)

        # --- Actualizar estado de reserva ---
        reserva.estado = "confirmada"
        reserva.save()

        # --- Enviar correo con código y asiento ---
        try:
            send_mail(
                subject="Confirmación de tu reserva - Cóndor Airways",
                message=(
                    f"¡Gracias por tu compra, {usuario.nombres}!\n\n"
                    f"Tu código de reserva es: {codigo_reserva}\n"
                    f"Vuelo: {vuelo.origen} → {vuelo.destino}\n"
                    f"Fecha: {vuelo.fecha_salida} {vuelo.hora_salida}\n"
                    f"Asiento asignado: {asiento}\n\n"
                    f"Por favor, conserva este código para tu check-in.\n\n"
                    f"Atentamente,\nEl equipo de Cóndor Airways 🕊️"
                ),
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[usuario.email],
                fail_silently=True,
            )
        except Exception as e:
            print("Error enviando correo:", e)

        messages.success(
            request,
            f"Compra realizada con éxito. Se descontaron ${total} de tu tarjeta. "
            f"Código de reserva: {codigo_reserva}"
        )

        return redirect("checkin_vuelo", compra_id=compra.id)

    # --- Renderizar vista de compra ---
    return render(
        request,
        "comprar_vuelo.html",
        {
            "reserva": reserva,
            "vuelo": vuelo,
            "tarjetas": tarjetas,
        },
    )

    CarritoItem.objects.filter(carrito__usuario=usuario,vuelo=vuelo).delete()

@login_required
def checkin_vuelo(request, compra_id):
    compra = get_object_or_404(Compra, id=compra_id)
    usuario = get_object_or_404(Usuario, user=request.user)

    # Validar que el usuario actual sea el dueño de la compra
    if compra.usuario != usuario:
        messages.error(request, "No puedes hacer check-in de una compra que no es tuya.")
        return redirect("buscar_vuelos")

    if request.method == "POST":
        codigo_reserva = request.POST.get("codigo_reserva", "").strip()
        asiento = request.POST.get("asiento")
        peso_maleta = request.POST.get("peso_maleta")

        try:
            # Verificamos que la compra y la reserva existan
            compra_validada = Compra.objects.get(codigo_reserva=codigo_reserva, usuario=usuario)
            reserva = Reserva.objects.filter(usuario=usuario, vuelo=compra_validada.vuelo, estado__in=["activa", "confirmada"]).first()

            # Asignar silla aleatoria si aún no tiene
            if not reserva.asiento_asignado:
                reserva.asiento_asignado = asignar_asiento_random(reserva.clase)
                reserva.save()

        except Compra.DoesNotExist:
            messages.error(request, "El código de reserva no existe o no pertenece a tu cuenta.")
            return redirect("checkin_vuelo", compra_id=compra.id)

        except Reserva.DoesNotExist:
            messages.error(request, "No tienes una reserva activa asociada a ese vuelo.")
            return redirect("checkin_vuelo", compra_id=compra.id)

        # Validación de asiento
        if not asiento:
            messages.error(request, "Debes ingresar el número de asiento.")
            return redirect("checkin_vuelo", compra_id=compra.id)

        # Crear el check-in
        checkin = CheckIn.objects.create(compra=compra, asiento=asiento)

        # Registrar maleta si existe
        if peso_maleta:
            Maleta.objects.create(
                checkin=checkin,
                peso=float(peso_maleta),
                costo=20000 if float(peso_maleta) <= 20 else 50000,
            )

        # Confirmación
        messages.success(request, "✅ Check-in realizado exitosamente.")
        return render(request, "checkin_confirmado.html", {"checkin": checkin})

    # GET: Mostrar formulario inicial
    return render(request, "checkin_vuelo.html", {"compra": compra})

@login_required
def tarjetas_usuario(request):
    tarjetas = Tarjeta.objects.filter(usuario=request.user)
    return render(request, 'tarjetas_usuario.html', {'tarjetas': tarjetas})

@login_required
def agregar_tarjeta(request):
    if request.method == "POST":
        tipo = request.POST.get("tipo")
        numero = request.POST.get("numero")
        fecha_vencimiento = request.POST.get("fecha_vencimiento")
        saldo = request.POST.get("saldo")

        if not (tipo and numero and fecha_vencimiento and saldo):
            messages.error(request, "Por favor completa todos los campos.")
            return redirect("agregar_tarjeta")

        # Validar que el número no esté repetido
        if Tarjeta.objects.filter(numero=numero).exists():
            messages.error(request, "Ya existe una tarjeta con ese número.")
            return redirect("agregar_tarjeta")

        Tarjeta.objects.create(
            usuario=request.user,
            tipo=tipo,
            numero=numero,
            fecha_vencimiento=fecha_vencimiento,
            saldo=saldo
        )

        messages.success(request, "✅ Tarjeta agregada exitosamente.")
        return redirect("gestionar_tarjetas")

    return render(request, "agregar_tarjeta.html")

@login_required
def eliminar_tarjeta(request, tarjeta_id):
    tarjeta = get_object_or_404(Tarjeta, id=tarjeta_id, usuario=request.user)
    tarjeta.delete()
    return redirect('tarjetas_usuario')

@login_required
def gestionar_tarjetas(request):
    tarjetas = Tarjeta.objects.filter(usuario=request.user)

    if request.method == "POST":
        tipo = request.POST.get("tipo")
        numero = request.POST.get("numero")
        saldo = request.POST.get("saldo")
        fecha_vencimiento = request.POST.get("fecha_vencimiento")

        if not (tipo and numero and saldo and fecha_vencimiento):
            messages.error(request, "Todos los campos son obligatorios.")
            return redirect("gestionar_tarjetas")

        Tarjeta.objects.create(
            usuario=request.user,
            tipo=tipo,
            numero=numero,
            saldo=saldo,
            fecha_vencimiento=fecha_vencimiento,
        )
        messages.success(request, "Tarjeta agregada correctamente.")
        return redirect("gestionar_tarjetas")

    return render(request, "gestionar_tarjetas.html", {"tarjetas": tarjetas})


def registro(request):
    if request.method == "POST":
        form = RegistroForm(request.POST, request.FILES)
        print("POST recibido")
        if form.is_valid():
            print("formulario valido")
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
                pais = form.cleaned_data["pais"],
                departamento = form.cleaned_data["departamento"],
                municipio = form.cleaned_data["municipio"],
                fecha_nacimiento=form.cleaned_data["fecha_nacimiento"],
                direccion_facturacion=form.cleaned_data["direccion_facturacion"],
                genero=form.cleaned_data["genero"],
                imagen_usuario=form.cleaned_data.get("imagen_usuario")
            )

            messages.success(request, "Usuario registrado correctamente.")
            return redirect("login")
        else:
            # Aquí Django mantiene los datos y errores en el formulario
            print("formulario invalido:",form.errors)
            return render(request, "registro.html", {"form": form})

    else:
        form = RegistroForm()

    return render(request, "registro.html", {"form": form})

def iniciar_sesion(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        user = authenticate(request, username=username, password=password)

        if user is not None:
            # Si el usuario autenticado es el root
            if user.is_superuser and hasattr(user, "usuario") and getattr(user.usuario, "es_root", False):
                login(request, user)
                return redirect("root_dashboard")

            # Si es un administrador normal
            elif hasattr(user, "usuario") and getattr(user.usuario, "es_admin", False):
                login(request, user)
                # Si el admin no ha completado su registro, lo enviamos al formulario
                return redirect("completar_registro_admin")
                messages.success(request, "Tu registro se completó correctamente. Ya puedes inciar sesión.")
                return redirect("login")

            # Si es cliente
            elif hasattr(user, "usuario"):
                login(request, user)
                return redirect("buscar_vuelos")

            else:
                # Caso raro: no tiene perfil extendido
                login(request, user)
                return redirect("buscar_vuelos")

        else:
            messages.error(request, "Usuario o contraseña incorrectos.")

    return render(request, "registration/login.html")

def cerrar_sesion(request):
    if request.user.is_authenticated:
        # Determinamos el rol antes del logout
        es_admin = (
            request.user.is_staff
            or request.user.is_superuser
            or (hasattr(request.user, "usuario") and request.user.usuario.es_admin)
        )
        logout(request)

        # Redirigimos según rol
        if es_admin:
            return redirect("/accounts/login/") # Panel de Django
        else:
            return redirect("/accounts/login") # Cliente normal
    else:
        return redirect("/accounts/login/")

def es_admin(user):
    return hasattr(user, "usuario") and user.usuario.rol.nombre == "Administrador"


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

def calcular_tiempo_vuelo(request):
    from datetime import datetime, timedelta
    from django.http import JsonResponse

    tipo = request.GET.get("tipo")
    origen = request.GET.get("origen")
    destino = request.GET.get("destino")
    fecha_salida = request.GET.get("fecha_salida")
    hora_salida = request.GET.get("hora_salida")

    # Validar campos
    if not all([tipo, origen, destino, fecha_salida, hora_salida]):
        return JsonResponse({"error": "Faltan datos para calcular el tiempo de vuelo."}, status=400)

    try:
        # Combinar fecha y hora
        salida = datetime.strptime(f"{fecha_salida} {hora_salida}", "%Y-%m-%d %H:%M")

        # Duraciones estándar según tipo
        if tipo == "NACIONAL":
            duracion = timedelta(hours=1, minutes=30)
        elif tipo == "INTERNACIONAL":
            duracion = timedelta(hours=8)
        else:
            duracion = timedelta(hours=2)

        # Calcular hora de llegada
        llegada = salida + duracion

        return JsonResponse({
            "tiempo_vuelo": str(duracion),
            "fecha_llegada": llegada.date().isoformat(),
            "hora_llegada": llegada.time().strftime("%H:%M")
        })
    except Exception as e:
        # 👀 Si algo falla, mostramos el error en consola y devolvemos mensaje
        print("Error en calcular_tiempo_vuelo:", e)
        return JsonResponse({"error": str(e)}, status=500)

@login_required
def agregar_al_carrito(request, vuelo_id):
    usuario = request.user.usuarios
    vuelo = get_object_or_404(Vuelo, id=vuelo_id)

    carrito,_ = Carrito.objects.get_or_create(usuario=usuario)

    item, creado = CarritoItem.objects.get_or_create(carrito=carrito, vuelo=vuelo)
    if not creado_item:
        item.cantidad += 1
        item.save()

    messages.success(request, f"Vuelo {vuelo.codigo} agregado al carrito.")
    return redirect('carrito')

@login_required
def ver_carrito(request):
    usuario = request.user.usuario
    carrito, _ = Carrito.objects.get_or_create(usuario=usuario)
    items = carrito.items.select_related("vuelo")
    total = sum(item.vuelo.precio * item.cantidad for item in carrito.items.all())
    return render(request, "carrito.html", {"carrito": carrito, "items":items, "total":total})

@login_required
def pagar_carrito(request):
    usuario = request.user.usuarios
    carrito = get_object_or_404(Carrito, usuario=usuario)
    tarjetas = Tarjeta.objects.filter(usuario=request.user)

    if request.method == "POST":
        tarjeta_id = request.POST.get("tarjeta")
        if not tarjeta_id:
            messages.error(request, "Debes seleccionar una tarjeta para pagar.")
            return redirect("carrito")

        tarjeta = get_object_or_404(Tarjeta, id=tarjeta_id, usuario=request.user)

        total = carrito.total()

        if tarjeta.saldo < total:
            messages.error(request, "Saldo insuficiente.")
            return redirect("carrito")

        # Descontar saldo total
        tarjeta.saldo -= total
        tarjeta.save()

        # Crear reservas y compras
        for item in carrito.items.all():
            reserva = Reserva.objects.create(
                usuario=usuario,
                vuelo=item.vuelo,
                num_tiquetes=item.cantidad,
                estado="activa"
            )

            codigo_reserva = f"RES{timezone.now().strftime('%Y%m%d')}{reserva.id}"
            Compra.objects.create(
                usuario=usuario,
                vuelo=item.vuelo,
                codigo_reserva=codigo_reserva,
                metodo_pago=f"Tarjeta {tarjeta.tipo}",
                estado="activa"
            )

            # Asignar asiento aleatorio
            fila = random.randint(1, 30)
            letra = random.choice(['A', 'B', 'C', 'D', 'E', 'F'])
            reserva.asiento_asignado = f"{fila}{letra}"
            reserva.save()

        # Vaciar el carrito
        carrito.items.all().delete()

        # Enviar correo
        send_mail(
            "Confirmación de compra",
            f"Tu compra fue realizada con éxito. Total: ${total}",
            settings.DEFAULT_FROM_EMAIL,
            [usuario.user.email],
        )

        messages.success(request, f"Compra completada. Total descontado: ${total}")
        return redirect("checkin_vuelo_lista")  # o donde quieras llevarlos después

    return render(request, "pagar_carrito.html", {"carrito": carrito, "tarjetas": tarjetas})

@login_required
def eliminar_del_carrito(request, item_id):
    usuario = get_object_or_404(Usuario, user=request.user)
    carrito_item = get_object_or_404(CarritoItem, id=item_id, carrito__usuario=usuario)

    # Si el item tiene una reserva asociada, marcarla como cancelada
    if hasattr(carrito_item, "reserva") and carrito_item.reserva:
        reserva = carrito_item.reserva
        reserva.estado = "cancelada"
        reserva.save(update_fields=["estado"])  # ✅ Se guarda en la base de datos

    else:
        # Buscar si hay una reserva del mismo vuelo y usuario activa (por si se perdió la relación)
        reserva = Reserva.objects.filter(
            usuario=usuario,
            vuelo=carrito_item.vuelo,
            estado="activa"
        ).first()
        if reserva:
            reserva.estado = "cancelada"
            reserva.save(update_fields=["estado"])  # ✅ Se guarda

    # Eliminar el ítem del carrito
    carrito_item.delete()

    messages.success(request, "La reserva fue eliminada y marcada como cancelada correctamente.")
    return redirect("ver_carrito")


