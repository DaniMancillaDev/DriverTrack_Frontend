<p align="center">
  <img src="assets/images/app_icon.png" width="450" style="margin: 0 auto;" alt="DriverTrack Logo">
</p>
<h1 align="center" style="margin-top: 8px;">DriverTrack Frontend</h1>

<p align="center">
  <strong>Inteligencia Automotriz en tu Bolsillo</strong>
</p>

<p align="center">
  <a href="https://github.com/DaniMancillaDev/DriverTrack"><strong>Backend API →</strong></a>
</p>

---

## 📌 Descripción del Proyecto

**DriverTrack** es una aplicación móvil construida con Flutter que funciona como ecosistema de gestión vehicular. Resuelve el problema de la gestión dispersa de vehículos: mantenimiento, localización de servicios, finanzas y notificaciones, todo centralizado en una sola app.

**Público objetivo**: Conductores y propietarios de vehículos (autos y motocicletas) que necesitan llevar un control preciso del mantenimiento, encontrar talleres cercanos y recibir alertas preventivas.

### Características Principales

- **Garaje Inteligente**: Gestión de múltiples vehículos con indicadores de salud (Healthy, Attention, Critical) calculados mediante algoritmos de mantenimiento.
- **Service Map**: Localización en tiempo real de servicios automotrices (Talleres, Gasolineras) utilizando **OpenStreetMap** + **Overpass API**.
- **Notificaciones Predictivas**: Alertas meteorológicas y recordatorios de servicio sincronizados vía WebSockets.
- **Gestión Financiera**: Reflejo exacto de costos de mantenimiento con convertidor de divisas integrado.
- **Seguridad de Grado Bancario**: Persistencia de sesiones mediante **JWT** con almacenamiento seguro (`flutter_secure_storage`).

---

## 🏗️ Arquitectura General

| Flutter App | | FastAPI Backend |
|---|---|---|
| `DriverTrack FE` | **REST + JWT ──►** | `DriverTrack API` |
| | **◄── JSON Response** | |
| WebSocket (Notifications) | | PostgreSQL / SQLite |
| | | MinIO / S3 (Fotos) |

### Flujo General

1. **Login/Registro** → JWT access + refresh tokens almacenados en `flutter_secure_storage`
2. **Garaje** → CRUD de vehículos con fotos subidas vía presigned URLs (MinIO/S3)
3. **Mantenimiento** → Historial de servicios con costos y kilometraje
4. **Mapa** → Búsqueda geoespacial de talleres/gasolineras (Overpass API)
5. **Notificaciones** → WebSocket en tiempo real + scheduler automático del backend
6. **Clima** → Proxy seguro vía backend (OpenWeatherMap API key no expuesta al cliente)

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| **Framework** | Flutter 3.x (Material 3) |
| **Lenguaje** | Dart ^3.11.1 |
| **State Management** | `flutter_riverpod` (AsyncNotifier, Family Providers) |
| **Navigation** | `go_router` (navegación declarativa) |
| **Internacionalización** | `slang` (ES/EN, tipos seguros) |
| **Networking** | `http` con auto-refresh de tokens |
| **Mapas** | `flutter_map` + OpenStreetMap tiles (CartoDB) |
| **Geolocalización** | `geolocator` |
| **Almacenamiento seguro** | `flutter_secure_storage` |
| **Persistencia local** | `shared_preferences` |
| **Imágenes** | `image_picker` + `cached_network_image` |

---

## ⚙️ Instalación y Ejecución

### Requisitos

- **Flutter SDK** >= 3.11.1 ([Instalación oficial](https://docs.flutter.dev/get-started/install))
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Android SDK** (minSdk 21+)
- Un dispositivo Android o emulador

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/DaniMancillaDev/DriverTrack_Frontend.git
cd DriverTrack_Frontend

# 2. Instalar dependencias
flutter pub get

# 3. Generar código de internacionalización
dart run slang

# 4. Ejecutar en modo desarrollo
flutter run
```

### Configuración de entorno

La URL base de la API se configura en `lib/providers/app_providers.dart`:

```dart
// Desarrollo (localhost)
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.dev();   // http://localhost:8000
});

// Producción
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.prod();  // https://drivertrack.mikecardona076.com
});
```

> **Nota**: En emulador Android, usar `http://10.0.2.2:8000` en lugar de `localhost` para conectar con el backend local.

---

## 🔐 Configuración Importante

### Permisos Android (`AndroidManifest.xml`)

| Permiso | Propósito |
|---------|-----------|
| `INTERNET` | Comunicación con el backend |
| `ACCESS_FINE_LOCATION` | GPS para Service Map |
| `ACCESS_COARSE_LOCATION` | Ubicación aproximada |
| `READ_MEDIA_IMAGES` | Selección de fotos (Android 13+) |
| `READ_EXTERNAL_STORAGE` | Selección de fotos (Android < 13) |

### Mapas

No se requiere API key para los mapas. Se utilizan tiles gratuitos de **CartoDB/OpenStreetMap** vía `flutter_map`. La búsqueda de servicios usa **Overpass API** (gratuita, sin key).

---

## 🔌 Documentación de la API

> La API completa está documentada en el repositorio del backend: [DriverTrack API](https://github.com/DaniMancillaDev/DriverTrack)

### Endpoints Principales

#### Autenticación (`/auth`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/auth/register` | Registrar nuevo usuario | No |
| `POST` | `/auth/login` | Iniciar sesión | No |
| `POST` | `/auth/refresh` | Renovar access token | No |
| `GET` | `/auth/me` | Verificar token actual | Sí |
| `POST` | `/auth/verify-otp` | Verificar OTP | No |
| `POST` | `/auth/reset-password` | Restablecer contraseña | No |

**Ejemplo: Login**
```bash
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "mypassword"}'
```

**Response:**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "full_name": "John Doe",
    "is_active": true
  }
}
```

#### Vehículos (`/vehicles`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/vehicles/types` | Catálogo de tipos de vehículo | No |
| `POST` | `/vehicles/` | Registrar vehículo | Sí |
| `GET` | `/vehicles/` | Listar mis vehículos | Sí |
| `GET` | `/vehicles/{id}` | Detalle de vehículo | Sí |
| `PUT` | `/vehicles/{id}` | Actualizar vehículo | Sí |
| `DELETE` | `/vehicles/{id}` | Eliminar vehículo | Sí |
| `POST` | `/vehicles/{id}/photo/presigned-url` | URL para subir foto | Sí |
| `PUT` | `/vehicles/{id}/photo/confirm` | Confirmar subida de foto | Sí |

#### Mantenimiento (`/vehicles/{id}/maintenance`, `/maintenance`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/vehicles/{id}/maintenance` | Registrar mantenimiento | Sí |
| `GET` | `/vehicles/{id}/maintenance` | Historial por vehículo | Sí |
| `GET` | `/maintenance` | Todos mis mantenimientos | Sí |
| `GET` | `/maintenance/{id}` | Detalle de mantenimiento | Sí |
| `PUT` | `/maintenance/{id}` | Actualizar mantenimiento | Sí |
| `DELETE` | `/maintenance/{id}` | Eliminar mantenimiento | Sí |

#### Usuarios (`/users`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/users/me` | Mi perfil | Sí |
| `PUT` | `/users/me` | Actualizar perfil | Sí |
| `PATCH` | `/users/me/preferences` | Preferencias de notificaciones | Sí |
| `POST` | `/users/me/change-password` | Cambiar contraseña | Sí |
| `POST` | `/users/me/photo/presigned-url` | URL para subir foto de perfil | Sí |
| `PUT` | `/users/me/photo/confirm` | Confirmar foto de perfil | Sí |

#### Notificaciones (`/notifications`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/notifications` | Listar notificaciones (paginado) | Sí |
| `PATCH` | `/notifications/{id}/read` | Marcar como leída | Sí |
| `PATCH` | `/notifications/read-all` | Marcar todas como leídas | Sí |
| `GET` | `/notifications/unread-count` | Contador de no leídas | Sí |
| `DELETE` | `/notifications/{id}` | Eliminar notificación | Sí |
| `WS` | `/ws/notifications` | Notificaciones en tiempo real | Sí |

#### Clima (`/weather`)

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/weather/current?lat=&lon=` | Clima por coordenadas | Sí |
| `GET` | `/weather/city/{name}` | Clima por nombre de ciudad | Sí |

### Manejo de Errores

| Código | Significado | Acción del cliente |
|--------|------------|-------------------|
| `401` | Token expirado/inválido | Auto-refresh con `/auth/refresh`, si falla → logout |
| `403` | Sin permisos | Mostrar mensaje de acceso denegado |
| `404` | Recurso no encontrado | Mostrar estado vacío |
| `422` | Validación fallida | Mostrar errores de formulario |
| `429` | Rate limit excedido | Reintentar con backoff |
| `5xx` | Error del servidor | Mostrar error genérico, reintentar |

---

## 📂 Estructura del Proyecto

```
lib/
├── config/              # Configuración de entorno (AppConfig)
├── core/
│   ├── error/           # Manejo centralizado de errores
│   ├── i18n/            # Internacionalización (slang)
│   ├── location/        # Servicio de geolocalización
│   ├── network/         # Cliente HTTP con auto-refresh
│   ├── responsive/      # Sistema de diseño responsivo
│   ├── router/          # Configuración de go_router
│   ├── security/        # Almacenamiento seguro (tokens)
│   ├── units/           # Sistema de unidades (km/mi, L/gal)
│   └── validation/      # Validadores de formularios
├── features/
│   ├── auth/            # Autenticación (login, registro, OTP)
│   ├── currency/        # Convertidor de divisas
│   ├── maintenance/     # Gestión de mantenimientos
│   ├── map/             # Service Map (talleres, gasolineras)
│   ├── notifications/   # Notificaciones en tiempo real
│   └── weather/         # Datos climáticos
├── gen/                 # Código generado (slang translations)
├── layouts/             # Layouts principales (bottom nav)
├── models/              # Modelos de dominio
├── pages/               # Pantallas de la app
├── providers/           # Providers globales de Riverpod
├── services/            # Servicios de infraestructura
├── theme/               # Tema Material 3 (light/dark)
├── widgets/             # Widgets compartidos
└── main.dart            # Punto de entrada
```

---

## 🧠 Buenas Prácticas Implementadas

- **Clean Architecture / DDD Lite**: Separación estricta entre domain, data y presentation layers
- **Riverpod + AsyncNotifier**: Estado reactivo con manejo de loading/error/data
- **Auto-refresh de tokens**: El `ApiClient` intercepta 401 y renueva tokens transparentemente
- **Presigned URLs**: Subida de fotos directa a S3/MinIO sin exponer credenciales del servidor
- **Responsive Design**: Sistema de breakpoints propio (`AppResponsive`) con escalado adaptativo
- **Internacionalización tipada**: `slang` genera código Dart con tipos seguros (sin strings mágicos)
- **Secure Storage**: Tokens JWT en `flutter_secure_storage` (cifrado AES en Android)
- **Documentación profesional**: Estándar `///` Effective Dart en todo el codebase

---

## 🧪 Testing

### Probar endpoints con curl

```bash
# Login
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@drivetrack.com","password":"admin123"}'

# Listar vehículos (reemplazar TOKEN)
curl http://localhost:8000/vehicles/ \
  -H "Authorization: Bearer TOKEN"

# Clima actual
curl "http://localhost:8000/weather/current?lat=19.43&lon=-99.13" \
  -H "Authorization: Bearer TOKEN"
```

### Probar la app

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar tests
flutter test
```

---

## 📦 Descargar APK

La APK de la aplicación está disponible en [GitHub Releases](https://github.com/DaniMancillaDev/DriverTrack_Frontend/releases). Descarga la versión más reciente e instálala directamente en tu dispositivo Android.

> **Nota**: Es posible que debas habilitar "Instalar desde orígenes desconocidos" en la configuración de tu dispositivo.

---

## ❗ Problemas Conocidos

- **Overpass API**: Puede devolver errores 429 (rate limit) o 504 en consultas intensivas. La app maneja esto graciosamente reteniendo los markers previos.
- **GPS en emulador**: La ubicación puede no estar disponible en emuladores sin GPS simulado.
- **Signing**: La APK release está firmada con la key de debug. Para Play Store se requiere signing config propio.

---

## 💡 Despliegue y Extras

### Dockerizar el Backend

El backend ya está dockerizado. Ver [DriverTrack API](https://github.com/DaniMancillaDev/DriverTrack) para instrucciones:

```bash
cd DriverTrack
cp .env.example .env   # Editar con valores reales
docker compose up -d --build
```

### Desplegar Backend (Opciones)

| Plataforma | Configuración |
|-----------|--------------|
| **Render** | Docker deploy, puerto 8010, variables de entorno en dashboard |
| **Railway** | Conectar repo GitHub, auto-detecta Dockerfile |
| **VPS + Docker** | `docker compose up -d` + Nginx Proxy Manager para SSL |

### Publicar en Play Store (Futuro)

1. Crear cuenta de desarrollador Google Play ($25 USD)
2. Configurar signing key propia en `android/app/build.gradle.kts`
3. Generar AAB: `flutter build appbundle --release`
4. Crear listing en Google Play Console
5. Subir AAB, completar ficha de store
6. Revisión interna → producción

---

Desarrollado con ❤️ por [DaniMancillaDev](https://github.com/DaniMancillaDev) & [GatoRX8](https://github.com/GatoRX8)
