from django import forms
from django.core.exceptions import ValidationError
from .models import Vuelo
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
