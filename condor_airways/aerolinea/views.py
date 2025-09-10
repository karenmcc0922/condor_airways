from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from .models import Vuelo, Reserva, Usuario, Compra, CheckIn, Maleta
import random

def buscar_vuelos(request):
    origen = request.GET.get("origen")
    destino = request.GET.get("destino")
    vuelos = Vuelo.objects.all()

    if origen:
        vuelos = vuelos.filter(origen__icontains=origen)
    if destino:
        vuelos = vuelos.filter(destino__icontains=destino)

    return render(request, "buscar_vuelos.html", {"vuelos": vuelos})

def reservar_vuelo(request, vuelo_id):
    vuelo = get_object_or_404(Vuelo, id=vuelo_id)

    if request.method == "POST":
        usuario = Usuario.objects.filter(rol__nombre="Cliente").first()
        if not usuario:
            messages.error(request, "No hay un usuario cliente disponible")
            return redirect("buscar_vuelos")

        # Crear la reserva
        reserva = Reserva.objects.create(
            usuario=usuario,
            vuelo=vuelo,
            estado="activa",
            num_tiquetes=random.randint(1, 3)
        )

        return render(request, "reserva_confirmada.html", {"reserva": reserva})

    # GET → mostrar formulario
    return render(request, "reservar_vuelo.html", {"vuelo": vuelo})

def comprar_vuelo(request, reserva_id):
    reserva = get_object_or_404(Reserva, id=reserva_id)

    if request.method == "POST":
        compra = Compra.objects.create(
            usuario=reserva.usuario,
            vuelo=reserva.vuelo,
            codigo_reserva=f"RES{random.randint(10000, 99999)}",
            metodo_pago=random.choice(["Tarjeta de Crédito", "PSE", "Efectivo"]),
            estado="activa"
        )

        reserva.estado = "confirmada"
        reserva.save()

        # Mostrar confirmación de compra con opción de check-in
        return render(request, "compra_confirmada.html", {"compra": compra})

    return render(request, "comprar_vuelo.html", {"reserva": reserva})

def checkin_vuelo(request, compra_id):
    compra = get_object_or_404(Compra, id=compra_id)

    if request.method == "POST":
        asiento = request.POST.get("asiento")
        peso_maleta = request.POST.get("peso_maleta")

        checkin = CheckIn.objects.create(
            compra=compra,
            asiento=asiento
        )

        if peso_maleta:
            Maleta.objects.create(
                checkin=checkin,
                peso=float(peso_maleta),
                costo=20000 if float(peso_maleta) <= 20 else 50000
            )

        return render(request, "checkin_confirmado.html", {"checkin": checkin})

    return render(request, "checkin_vuelo.html", {"compra": compra})
