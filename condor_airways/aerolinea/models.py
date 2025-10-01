from django import forms
from django.db import models
from django.core.exceptions import ValidationError
from django.core.validators import EmailValidator, MinValueValidator
from django.utils import timezone
from django.contrib.auth.models import User
import re
import math
from datetime import datetime, timedelta
import pytz

# Zonas horarias de los destinos internacionales
ZONAS_HORARIAS_DESTINOS = {
    "MADRID": "Europe/Madrid",      # UTC+1 (UTC+2 en verano)
    "LONDRES": "Europe/London",     # UTC+0 (UTC+1 en verano)
    "NUEVA_YORK": "America/New_York",  # UTC-5 (UTC-4 en verano)
    "BUENOS_AIRES": "America/Argentina/Buenos_Aires",  # UTC-3
    "MIAMI": "America/New_York",    # UTC-5 (UTC-4 en verano)
}

# Zona horaria de Colombia (origen)
ZONA_HORARIA_COLOMBIA = "America/Bogota"  # UTC-5

# Capitales principales de Colombia
class Capital(models.Model):
    nombre = models.CharField(max_length=100, unique=True)
    lat = models.FloatField()
    lon = models.FloatField()

    class Meta:
        ordering = ['nombre']
        verbose_name = 'Capital'
        verbose_name_plural = 'Capitales'

    def __str__(self):
        return self.nombre

def calcular_distancia_haversine(lat1, lon1, lat2, lon2):
    """
    Calcula la distancia entre dos puntos usando la fórmula de Haversine
    Retorna la distancia en kilómetros
    """
    # Radio de la Tierra en kilómetros
    R = 6371.0
    
    # Convertir grados a radianes
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)
    
    # Diferencias
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    
    # Fórmula de Haversine
    a = math.sin(dlat/2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon/2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1- a))
    
    # Distancia en kilómetros
    distancia = R * c
    return distancia

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

    ORIGEN_INTERNACIONAL = [
        ("PEREIRA", "Pereira"),
        ("BOGOTA", "Bogotá"),
        ("MEDELLIN", "Medellín"),
        ("CALI", "Cali"),
        ("CARTAGENA", "Cartagena"),
    ]

    DESTINO_INTERNACIONAL = [
        ("MADRID", "Madrid"),
        ("LONDRES", "Londres"),
        ("NUEVA_YORK", "Nueva York"),
        ("BUENOS_AIRES", "Buenos Aires"),
        ("MIAMI", "Miami"),
    ]
    
    VUELOS_NACIONALES = [
        ("ARAUCA", "Arauca"),
        ("ARMENIA", "Armenia"),
        ("BARRANQUILLA", "Barranquilla"),
        ("BOGOTA", "Bogotá"),
        ("BUCARAMANGA", "Bucaramanga"),
        ("CALI", "Cali"),
        ("CARTAGENA", "Cartagena"),
        ("CUCUTA", "Cucuta"),
        ("FLORENCIA", "Florencia"),
        ("IBAGUE", "Ibagué"),
        ("INIRIDA", "Inirida"),
        ("LETICIA", "Leticia"),
        ("MANIZALES", "Manizales"),
        ("MEDELLIN", "Medellín"),
        ("MITU", "Mitú"),
        ("MOCOA", "Mocoa"),
        ("MONTERIA", "Montería"),
        ("NEIVA", "Neiva"),
        ("PASTO", "Pasto"),
        ("PEREIRA", "Pereira"),
        ("POPAYAN", "Popayán"),
        ("PUERTO_CARREÑO", "Puerto Carreño"),
        ("QUIBDO", "Quibdó"),
        ("RIOHACHA", "Riohacha"),
        ("SAN_ANDRES", "San Andrés"),
        ("SAN_JOSE_DEL_GUAVIARE", "San José del Guaviare"),
        ("SANTA_MARTA", "Santa Marta"),
        ("SINCELEJO", "Sincelejo"),
        ("TUNJA", "Tunja"),
        ("VALLEDUPAR", "Valledupar"),
        ("VILLAVICENCIO", "Villavicencio"),
        ("YOPAL", "Yopal")
    ]

    codigo = models.CharField(max_length=20, unique=True, editable=False)
    origen = models.CharField(max_length=50)
    destino = models.CharField(max_length=50)
    fecha_salida = models.DateField(null=True, blank=True)
    hora_salida = models.TimeField(null=True, blank=True)
    fecha_llegada = models.DateField(blank=True, null=True)
    hora_llegada = models.TimeField(blank=True, null=True)
    tiempo_vuelo = models.DurationField(blank=True, null=True, help_text="Tiempo de vuelo calculado automáticamente")
    capacidad = models.IntegerField()
    precio = models.DecimalField(
        max_digits=10, 
        decimal_places=2,
        validators=[MinValueValidator(0, message="El precio no puede ser negativo")]
    )
    tipo = models.CharField(max_length=20, choices=TIPO_VUELO)

    def __str__(self):
        return f"{self.codigo} - {self.origen} → {self.destino} ({self.tipo})"

    def establecer_capacidad_automatica(self):
        """
        Establece la capacidad automáticamente según el tipo de vuelo
        Nacional: 150 pasajeros
        Internacional: 250 pasajeros
        """
        if self.tipo == "NACIONAL":
            self.capacidad = 150
        elif self.tipo == "INTERNACIONAL":
            self.capacidad = 250

    def calcular_tiempo_vuelo(self):
        """
        Calcula el tiempo de vuelo basado en la distancia y velocidad del avión
        """
        try:
            # Obtener coordenadas del origen
            origen_capital = Capital.objects.get(nombre__iexact=self.origen)
            
            # Obtener coordenadas del destino
            destino_capital = Capital.objects.get(nombre__iexact=self.destino)
            
            # Calcular distancia usando Haversine
            distancia = calcular_distancia_haversine(
                origen_capital.lat, origen_capital.lon,
                destino_capital.lat, destino_capital.lon
            )
            
            # Velocidad según tipo de vuelo
            if self.tipo == "NACIONAL":
                velocidad = 700  # Airbus A320 km/h
            else:  # INTERNACIONAL
                velocidad = 850  # Airbus A321neo km/h
            
            # Calcular tiempo en horas
            tiempo_horas = (distancia / velocidad) + 0.4
            
            # Convertir a timedelta
            horas = int(tiempo_horas)
            minutos = int((tiempo_horas - horas) * 60)
            
            return timedelta(hours=horas, minutes=minutos)
            
        except Capital.DoesNotExist as e:
            print(f"Error: Capital no encontrada - {e}")
            return None
        except Exception as e:
            print(f"Error calculando tiempo de vuelo: {e}")
            return None

    def calcular_hora_local_destino(self, datetime_utc):
        """
        Convierte un datetime UTC a la hora local del destino
        """
        if self.tipo != "INTERNACIONAL" or self.destino not in ZONAS_HORARIAS_DESTINOS:
            return datetime_utc
        
        try:
            # Obtener la zona horaria del destino
            zona_destino = pytz.timezone(ZONAS_HORARIAS_DESTINOS[self.destino])
            
            # Convertir UTC a hora local del destino
            datetime_local = datetime_utc.astimezone(zona_destino)
            
            return datetime_local
        except Exception as e:
            print(f"Error calculando hora local del destino: {e}")
            return datetime_utc

    def calcular_fecha_llegada(self):
        """
        Calcula la fecha y hora de llegada basada en la salida y tiempo de vuelo
        Considera las zonas horarias para vuelos internacionales
        """
        if not self.fecha_salida or not self.hora_salida:
            return None, None
            
        tiempo_vuelo = self.calcular_tiempo_vuelo()
        if not tiempo_vuelo:
            return None, None
            
        # Crear datetime de salida en zona horaria de Colombia
        zona_colombia = pytz.timezone(ZONA_HORARIA_COLOMBIA)
        datetime_salida_local = datetime.combine(self.fecha_salida, self.hora_salida)
        datetime_salida_local = zona_colombia.localize(datetime_salida_local)
        
        # Convertir a UTC para cálculos
        datetime_salida_utc = datetime_salida_local.astimezone(pytz.UTC)
        
        # Calcular datetime de llegada en UTC
        datetime_llegada_utc = datetime_salida_utc + tiempo_vuelo
        
        # Para vuelos internacionales, convertir a hora local del destino
        if self.tipo == "INTERNACIONAL":
            datetime_llegada_local = self.calcular_hora_local_destino(datetime_llegada_utc)
        else:
            # Para vuelos nacionales, mantener en hora de Colombia
            datetime_llegada_local = datetime_llegada_utc.astimezone(zona_colombia)
        
        return datetime_llegada_local.date(), datetime_llegada_local.time()

    def save(self, *args, **kwargs):
        if not self.codigo:
            prefix = "VN" if self.tipo == "NACIONAL" else "VI"
            last = Vuelo.objects.filter(tipo=self.tipo, codigo__startswith=prefix).order_by('-codigo').first()
            if last and last.codigo[2:].isdigit():
                next_num = int(last.codigo[2:]) + 1
            else:
                next_num = 1
            self.codigo = f"{prefix}{next_num:04d}"
        
        # Establecer capacidad automáticamente según el tipo de vuelo
        self.establecer_capacidad_automatica()
        
        # Calcular tiempo de vuelo y fecha de llegada si no están establecidos
        if self.fecha_salida and self.hora_salida and not self.tiempo_vuelo:
            self.tiempo_vuelo = self.calcular_tiempo_vuelo()
            
        if self.fecha_salida and self.hora_salida and (not self.fecha_llegada or not self.hora_llegada):
            fecha_llegada, hora_llegada = self.calcular_fecha_llegada()
            if fecha_llegada and hora_llegada:
                self.fecha_llegada = fecha_llegada
                self.hora_llegada = hora_llegada
            
        super().save(*args, **kwargs)


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