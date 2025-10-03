from django.shortcuts import redirect
from django.urls import reverse

class RestriccionAdminMiddleware:
    """
    Evita que un administrador (incluido superusuario) use la parte de clientes.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.user.is_authenticated:
            es_admin = (
                getattr(request.user, "is_staff", False) or
                getattr(request.user, "is_superuser", False) or
                (hasattr(request.user, "usuario") and request.user.usuario.es_admin)
            )

            if es_admin:
                rutas_clientes = [
                    "/buscar-vuelos",
                    "/reservar",
                    "/comprar",
                    "/checkin",
                    "/foro",
                    "/registro",
                    "/perfil",
                ]
                for ruta in rutas_clientes:
                    if request.path.startswith(ruta):
                        return redirect(reverse("admin:index"))  # o "panel_admin"

        return self.get_response(request)
