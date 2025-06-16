# Admin Web
Esta aplicación Flutter demuestra un panel de administración para ser servido desde Firebase. Permite:

- Crear, editar y eliminar cuentas de usuario.
- Ajustar remotamente la duración de grabación entre 30 y 60 segundos.
- Visualizar un historial de activaciones y acceder a la descarga de grabaciones.

El proyecto está pensado como punto de partida y las acciones no están conectadas a una base de datos real.
## Despliegue en Firebase Hosting

1. Instala la Firebase CLI (`npm install -g firebase-tools`).
2. Reemplaza `your-project-id` en `.firebaserc` con el id de tu proyecto.
3. Ejecuta `flutter build web` para generar la carpeta `build/web`.
4. Lanza `firebase deploy` para publicar el contenido.

La configuración de hosting está definida en `firebase.json`.