# DentisApp

Aplicación móvil multiplataforma para la gestión de una clínica odontológica.

## 1. Framework seleccionado

Se utilizó **Flutter 3.44.2 con Dart 3.12.2**, debido a que permite desarrollar aplicaciones multiplataforma utilizando una misma base de código y facilita el consumo de APIs REST.

## 2. Entorno de desarrollo

- Windows 11 Pro 64 bits
- Flutter 3.44.2
- Dart 3.12.2
- Android Studio
- Android SDK 36.1.0
- Java OpenJDK 21.0.10
- Android 15 (API 35)

## 3. Verificación del entorno

Se ejecutó el comando `flutter doctor` para comprobar la configuración del entorno.

**Resultado:** No issues found!

## 4. Dispositivo de ejecución

Se configuró un emulador **Pixel 7 con Android 15 (API 35)**, identificado como `emulator-5554`.

## 5. Ejecución del proyecto

Se instalaron las dependencias con `flutter pub get` y se ejecutó la aplicación mediante `flutter run`. Se verificó el funcionamiento de la aplicación y la recarga en caliente (Hot Reload).

## 6. Configuración de la API

La URL del backend se configura mediante la variable de entorno `API_BASE_URL`.

Para Windows se utiliza `http://localhost:5133` y para Android Emulator `http://10.0.2.2:5133`.

## 7. Comunicación con el backend

El backend utiliza **ASP.NET Core, Entity Framework Core y Oracle 19c**. Se comprobó exitosamente el endpoint `GET /api/pacientes`, obteniendo desde Flutter los pacientes almacenados en la base de datos.

## 8. Clasificación de datos y almacenamiento

| Clase de datos | Ejemplos | Almacenamiento | Finalidad | Retención |
| --- | --- | --- | --- | --- |
| Credenciales de sesión | Token JWT | `flutter_secure_storage` | Mantener la sesión autenticada | Hasta cerrar sesión, revocar o reemplazar el token |
| Datos personales y clínicos operativos | Pacientes, citas, tratamientos y pagos | API y Oracle; caché local SQLite cuando se habilite el modo offline | Operación de la clínica | Mientras la cuenta y la política de la clínica lo requieran |
| Datos temporales offline | Copias locales de pacientes, estado de sincronización y fecha de caché | SQLite (`dentisapp.db`) | Consultar y trabajar sin conexión | Hasta sincronizar, limpiar la caché o cerrar sesión |
| Operaciones pendientes | Tipo de operación, identificador de cliente, payload y reintentos | SQLite (`pending_operations`) | Reintentar escrituras realizadas sin conexión | Hasta sincronización exitosa, límite de reintentos o limpieza de la cuenta |
| Configuración no sensible | URL base de la API y preferencias de ejecución | Variables de entorno y configuración de la aplicación | Seleccionar el entorno de ejecución | Durante la instalación o configuración del entorno |
| Logs técnicos | Errores, códigos HTTP y eventos de sincronización | Consola/logs del entorno | Diagnóstico y soporte, sin almacenar tokens | Según la retención del entorno de desarrollo u operación |

Los tokens no deben escribirse en SQLite ni en logs. Los datos personales almacenados localmente son una copia temporal y deben eliminarse al cerrar sesión o al solicitar la eliminación de datos de la cuenta.

## 9. Lectura offline de pacientes

La pantalla de pacientes intenta primero consultar la API. Cuando la solicitud falla
por timeout o falta de conexión, utiliza la tabla `pacientes_local` de SQLite y muestra
un aviso con la antigüedad de la copia, por ejemplo: `Datos guardados hace 12 minutos`.
Cada respuesta exitosa reemplaza la caché y actualiza su fecha `cached_at`.

Al cerrar sesión, `AuthService.cerrarSesion()` elimina el token seguro y borra la base
local completa para evitar que los datos personales queden asociados a la siguiente sesión.

## 10. Escrituras offline

Si se registra un paciente sin conexión, la aplicación guarda una copia local con
estado `pending_create` y agrega una operación en `pending_operations`. Cada operación
recibe un `operation_id` y cada entidad recibe un `client_id` UUID, evitando duplicados
al reintentar. La operación conserva su payload JSON, contador de reintentos y fecha
programada para el siguiente intento.

## 11. Sincronización y conflictos

`SyncService` escucha la recuperación de conectividad y procesa las operaciones
pendientes en orden de creación. Las operaciones exitosas actualizan el ID del servidor,
marcan la entidad como `synced` y se eliminan de la cola. Los fallos de red se reintentan
con backoff creciente de 5, 10, 20 y 40 segundos, hasta cinco intentos.

Los errores HTTP permanentes no se reintentan automáticamente. Para conflictos se adopta,
por ahora, la política de última escritura aceptada por el servidor: evita bloquear la
sincronización, pero puede sobrescribir un cambio remoto. Para datos clínicos sensibles
se deberá añadir posteriormente una resolución explícita basada en versión o `updated_at`.