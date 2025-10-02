from django import forms
from django.core.exceptions import ValidationError
from django.core.validators import RegexValidator, EmailValidator
from django.contrib.auth.models import User
from .models import Vuelo, Usuario
from datetime import date
import re

class VueloAdminForm(forms.ModelForm):
    class Meta:
        model = Vuelo
        fields = [
            "tipo",
            "origen",
            "destino",
            "fecha_salida",
            "hora_salida",
            "fecha_llegada",
            "hora_llegada",
            "tiempo_vuelo",
            "capacidad",
            "precio",
        ]
        widgets = {
            "fecha_salida": forms.DateInput(attrs={"type": "date"}),
            "hora_salida": forms.TimeInput(attrs={"type": "time"}),
            "fecha_llegada": forms.DateInput(attrs={"type": "date", "readonly": True}),
            "hora_llegada": forms.TimeInput(attrs={"type": "time", "readonly": True}),
            "tiempo_vuelo": forms.TextInput(attrs={"readonly": True}),
            "tipo": forms.Select(attrs={"id": "id_tipo"}),
            "origen": forms.Select(attrs={"id": "id_origen"}),
            "destino": forms.Select(attrs={"id": "id_destino"}),
            "precio": forms.NumberInput(attrs={
                "min": "0", 
                "step": "0.01",
                "placeholder": "0.00"
            }),
            "capacidad": forms.NumberInput(attrs={
                "readonly": True,
                "id": "id_capacidad"
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Configurar opciones iniciales para origen y destino
        self.fields['origen'].choices = [('', 'Seleccione el tipo de vuelo')]
        self.fields['destino'].choices = [('', 'Seleccione el tipo de vuelo')]
        
        # Hacer campos de llegada y tiempo de vuelo de solo lectura
        self.fields['fecha_llegada'].widget.attrs['readonly'] = True
        self.fields['hora_llegada'].widget.attrs['readonly'] = True
        self.fields['tiempo_vuelo'].widget.attrs['readonly'] = True
        
        # Si es una edición, establecer las opciones correctas
        if self.instance and self.instance.pk:
            tipo = self.instance.tipo
            if tipo == "NACIONAL":
                self.fields['origen'].choices = [('', 'Seleccione origen')] + Vuelo.VUELOS_NACIONALES
                self.fields['destino'].choices = [('', 'Seleccione destino')] + Vuelo.VUELOS_NACIONALES
            elif tipo == "INTERNACIONAL":
                self.fields['origen'].choices = [('', 'Seleccione origen')] + Vuelo.ORIGEN_INTERNACIONAL
                self.fields['destino'].choices = [('', 'Seleccione destino')] + Vuelo.DESTINO_INTERNACIONAL

    def clean_precio(self):
        precio = self.cleaned_data.get('precio')
        if precio is not None:
            # Validar que el precio no sea negativo
            if precio < 0:
                raise ValidationError("El precio no puede ser negativo.")
            
            # Validar que el precio sea numérico (el DecimalField ya hace esto, pero agregamos validación adicional)
            try:
                float(precio)
            except (ValueError, TypeError):
                raise ValidationError("El precio debe ser un número válido.")
        
        return precio

    def clean(self):
        cleaned_data = super().clean()
        origen = cleaned_data.get("origen")
        destino = cleaned_data.get("destino")
        if origen and destino and origen == destino:
            raise forms.ValidationError("El origen y el destino no pueden ser iguales.")

class RegistroForm(forms.ModelForm):
    nombres = forms.CharField(
        max_length=150, 
        validators=[RegexValidator(r'^(?! )[A-Za-zÁÉÍÓÚáéíóúÑñ]+(?: [A-Za-zÁÉÍÓÚáéíóúÑñ]+)*(?<! )$',"Solo letras y un espacio entre palabras.")],
        widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Escribe tus nombres"}),
        error_messages={'required':'EL CAMPO NOMBRES ES OBLIGATORIO'}
    )

    apellidos = forms.CharField(
        max_length=150,
        validators=[RegexValidator(r'^(?! )[A-Za-zÁÉÍÓÚáéíóúÑñ]+(?: [A-Za-zÁÉÍÓÚáéíóúÑñ]+)*(?<! )$',"Solo letras y un espacio entre palabras.")],
        widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Escribe tus apellidos"}),
        error_messages={'required':'EL CAMPO APELLIDOS ES OBLIGATORIO'}
    )

    email = forms.EmailField(
        validators=[EmailValidator(message="Por favor ingresa un correo válido.")],
        widget=forms.EmailInput(attrs={"class": "form-control", "placeholder": "ejemplo@correo.com"})
    )

    password = forms.CharField(
        widget=forms.PasswordInput(attrs={"class": "form-control", "placeholder": "Contraseña"}),
        error_messages={'required':'EL CAMPO CONTRASEÑA ES OBLIGATORIO'}
    )

    dni = forms.CharField(
        max_length=15,
        validators=[RegexValidator(r'^\d+$', "El DNI solo puede contener números.")],
        widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Número de documento"}),
        error_messages={'required':'EL CAMPO DNI ES OBLIGATORIO'}
    )

    fecha_nacimiento = forms.DateField(
        widget=forms.DateInput(attrs={"type": "date", "class": "form-control"}),
        error_messages={'required':'EL CAMPO FECHA DE NACIMIENTO ES OBLIGATORIO'}
    )

    lugar_nacimiento = forms.CharField(
        max_length=100,
        widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Municipio"}),
        error_messages={'required':'EL CAMPO LUGAR DE NACIMIENTO ES OBLIGATORIO'}
    )

    direccion_facturacion = forms.CharField(
        max_length=200,
        widget=forms.TextInput(attrs={"class": "form-control", "placeholder": "Escribe tu dirección"}),
        error_messages={'required':'EL CAMPO LUGAR DE FACTURACIÓN ES OBLIGATORIO'}
    )

    genero = forms.ChoiceField(
        choices=[("", "Selecciona tu género"), ("M", "Masculino"), ("F", "Femenino"), ("O", "Otro")],
        widget=forms.Select(attrs={"class": "form-select"})
    )

    imagen_usuario = forms.ImageField(required=False)

    class Meta:
        model = Usuario
        fields = [
            "nombres", "apellidos", "dni", "email", "password",
            "fecha_nacimiento", "lugar_nacimiento",
            "direccion_facturacion", "genero", "imagen_usuario"
        ]

    # 🔎 Validaciones personalizadas
    def clean_nombres(self):
        nombres = self.cleaned_data.get("nombres", "").strip()
        if not nombres:
            raise forms.ValidationError("El campo nombres no puede estar vacío.")
        return nombres

    def clean_apellidos(self):
        apellidos = self.cleaned_data.get("apellidos", "").strip()
        if not apellidos:
            raise forms.ValidationError("El campo apellidos no puede estar vacío.")
        return apellidos

    def clean_password(self):
        password = self.cleaned_data.get("password", "").strip()
        if len(password) < 6 or not re.search(r"[A-Za-z]", password) or not re.search(r"\d", password):
            raise forms.ValidationError("La contraseña debe tener al menos 6 caracteres, una letra y un número.")
        return password

    def clean_dni(self):
        dni = self.cleaned_data.get("dni", "").strip()
        if len(dni) < 6 or len(dni) > 15:
            raise forms.ValidationError("El DNI debe tener entre 6 y 15 dígitos.")
        if Usuario.objects.filter(dni=dni).exists():
            raise forms.ValidationError("Ya existe un usuario con este DNI.")
        return dni

    def clean_fecha_nacimiento(self):
        fecha = self.cleaned_data.get("fecha_nacimiento")
        hoy = date.today()
        edad = (hoy - fecha).days // 365
        if fecha > hoy:
            raise forms.ValidationError("La fecha de nacimiento no puede estar en el futuro.")
        if edad < 12:
            raise forms.ValidationError("Debes tener al menos 12 años para registrarte.")
        if edad > 120:
            raise forms.ValidationError("Por favor ingresa una fecha de nacimiento válida.")
        return fecha

    def clean_email(self):
        email = self.cleaned_data.get("email", "").strip()
        if Usuario.objects.filter(email=email).exists():
            raise forms.ValidationError("Este correo ya está en uso.")
        return email
