from django import forms
from django.db import models
from django.core.exceptions import ValidationError
from django.core.validators import EmailValidator
from django.utils import timezone
from django.contrib.auth.models import User
import re

# --- Tabla Rol ---
class Rol(models.Model):
    nombre = models.CharField(max_length=50)

    def __str__(self):
        return self.nombre


# --- Tabla Usuario ---
class Usuario(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    rol = models.ForeignKey(Rol, on_delete=models.SET_NULL, null=True)
    email = models.EmailField(unique=True, validators=[EmailValidator(message="Por favor ingresa un correo válido")])
    password = models.CharField(max_length=255)
    nombre = models.CharField(max_length=150)
    nombre_completo = models.CharField(max_length=300)
    direccion_facturacion = models.CharField(max_length=255, null=True, blank=True)
    fecha_nacimiento = models.DateField(null=True, blank=True)
    lugar_nacimiento = models.CharField(max_length=100)
    dni = models.CharField(max_length=20, unique=True)
    direccion_facturacion = models.CharField(max_length=200)
    genero = models.CharField(max_length=20, choices=[("M", "Masculino"),("F", "Femenino"), ("O", "Otro"),])
    imagen_usuario = models.ImageField(upload_to="usuarios/", blank=True, null=True)
    es_admin = models.BooleanField(default=False) 

    def __str__(self):
        return self.user.username

    def clean (self):
        """Validaciones personalizadas"""
        # No permitir vuelos con fecha de salida en el pasado
        if self.fecha_salida < timezone.now ():
            raise ValidationError ("La fecha de salida no puede estar en el pasado.")
        
        #La fecha de llegada debe ser posterior a la salida
        if self.fecha_llegada <= self.fecha_salida:
            raise ValidationError ("La fecha de llegada debe ser posterior a la fecha de salida.")


# --- Tabla Vuelo ---
class Vuelo(models.Model):
    TIPO_VUELO = [
        ("NACIONAL", "Nacional"),
        ("INTERNACIONAL", "Internacional"),
    ]

    codigo = models.CharField(max_length=20, unique=True)
    origen = models.CharField(max_length=50)
    destino = models.CharField(max_length=50)
    fecha_salida = models.DateTimeField()
    fecha_llegada = models.DateTimeField()
    capacidad = models.IntegerField()
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    tipo = models.CharField(max_length=20, choices=TIPO_VUELO, default="NACIONAL")

    def __str__(self):
        return f"{self.codigo} - {self.origen} → {self.destino} ({self.tipo})"


# --- Tabla Reserva ---
class Reserva(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    vuelo = models.ForeignKey(Vuelo, on_delete=models.CASCADE)
    fecha_reserva = models.DateTimeField(auto_now_add=True)
    estado = models.CharField(
        max_length=20,
        choices=[
            ('activa', 'Activa'),
            ('cancelada', 'Cancelada'),
            ('vencida', 'Vencida')
        ],
        default='activa'
    )
    num_tiquetes = models.IntegerField()

    def __str__(self):
        return f"Reserva {self.id} - {self.usuario.nombre}"


# --- Tabla Compra ---
class Compra(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    vuelo = models.ForeignKey(Vuelo, on_delete=models.CASCADE)
    fecha_compra = models.DateTimeField(auto_now_add=True)
    estado = models.CharField(
        max_length=20,
        choices=[
            ('activa', 'Activa'),
            ('cancelada', 'Cancelada')
        ],
        default='activa'
    )
    codigo_reserva = models.CharField(max_length=50, unique=True)
    metodo_pago = models.CharField(max_length=50)

    def __str__(self):
        return f"Compra {self.codigo_reserva} - {self.usuario.nombre}"


# --- Tabla CheckIn ---
class CheckIn(models.Model):
    compra = models.ForeignKey(Compra, on_delete=models.CASCADE)
    asiento = models.CharField(max_length=5)
    pase_abordar = models.FileField(upload_to='pasabordos/', blank=True, null=True)

    def __str__(self):
        return f"CheckIn {self.id} - {self.compra.usuario.nombre}"


# --- Tabla Maleta ---
class Maleta(models.Model):
    checkin = models.ForeignKey(CheckIn, on_delete=models.CASCADE)
    peso = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    costo = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    def __str__(self):
        return f"Maleta {self.id} - {self.checkin.compra.usuario.nombre}"


# --- Historial de operaciones ---
class HistorialOperacion(models.Model):
    usuario = models.ForeignKey("Usuario", on_delete=models.CASCADE)
    tipo = models.CharField(
        max_length=30,
        choices=[
            ("reserva", "Reserva"),
            ("compra", "Compra"),
            ("cancelacion", "Cancelación"),
            ("checkin", "Check-In")
        ]
    )
    descripcion = models.TextField()
    fecha = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.tipo} - {self.usuario.nombre} ({self.fecha.date()})"


# --- Foro: Publicaciones ---
class Publicacion(models.Model):
    usuario = models.ForeignKey("Usuario", on_delete=models.CASCADE)
    titulo = models.CharField(max_length=200)
    contenido = models.TextField()
    fecha = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"{self.titulo} - {self.usuario.nombre}"


# --- Foro: Comentarios ---
class Comentario(models.Model):
    publicacion = models.ForeignKey(Publicacion, on_delete=models.CASCADE, related_name="comentarios")
    usuario = models.ForeignKey("Usuario", on_delete=models.CASCADE)
    contenido = models.TextField()
    fecha = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"Comentario de {self.usuario.nombre}"


# --- Notificaciones ---
class Notificacion(models.Model):
    usuario = models.ForeignKey("Usuario", on_delete=models.CASCADE)
    mensaje = models.TextField()
    enviada = models.BooleanField(default=False)
    fecha = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f"Notificación a {self.usuario.nombre} ({'Enviada' if self.enviada else 'Pendiente'})"
    

# --- Validaciones ---
class RegsitroForm(forms.ModelForm):
    password=forms.CharField(widget=forms.PasswordInput)

    class Meta:
        model = User
        fields = ['username', 'email', 'password']

        def clean_username(self):
            username=self.cleaned_data['username'].strip()
            if not re.match(r'^[a-zA-Z0-9_]{3,20}$',username):
                raise forms.ValidationError("El nombre de usuario solo puede contener letras, números y guiones bajos (3,20 caracteres).")
                return username
            
        def clean_email(self):
            email=self.cleaned_data['email'].strip()    
            if User.objects.filter(email=email).exists():
                raise forms.ValidationError("Este correo ya está en uso.")
                return email

        def clean_password(self):
            password=self.cleaned_data['password'].strip()
            if len(password) <6 or not re.search(r'[A-Za-z]',password) or not re.search(r'\d', password):
                raise forms.ValidationError("La contraseña debe tener al menos 6 caracteres, una letra y un número.")
                return password