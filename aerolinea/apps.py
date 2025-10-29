from django.apps import AppConfig

class AerolineaConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'aerolinea'

    def ready(self):
        from aerolinea.models import Rol, Usuario
        from django.contrib.auth.models import User
        try:
            # Crear roles base
            Rol.objects.get_or_create(nombre="Cliente")
            Rol.objects.get_or_create(nombre="Administrador")
            rol_root, _ = Rol.objects.get_or_create(nombre="Root")

            # Crear usuario root si no existe
            if not User.objects.filter(username="root").exists():
                root_user = User.objects.create_superuser(
                    username="root",
                    email="root@condorairways.com",
                    password="root123"
                )
                Usuario.objects.create(
                    user=root_user,
                    rol=rol_root,
                    email="root@condorairways.com",
                    password="root123",
                    nombres="Root",
                    apellidos="System",
                    dni="0000000000",
                    fecha_nacimiento="2000-01-01",
                    genero="O",
                    direccion_facturacion="Sistema Central",
                    es_admin=False,
                    es_root=True
                )
                print("✅ Usuario root creado correctamente.")
        except Exception as e:
            print(f"⚠️ Error creando roles o root: {e}")
