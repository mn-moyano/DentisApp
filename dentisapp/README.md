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