# DriverTrack Frontend 🚗📱

<p align="center">
  <img src="assets/images/Gemini_Generated_Image_2p45892p45892p45-Photoroom.png" width="200" alt="DriverTrack Logo">
</p>

<p align="center">
  <strong>Inteligencia Automotriz en tu Bolsillo</strong>
</p>

---

## ✨ La Experiencia DriverTrack

DriverTrack no es solo una bitácora; es un ecosistema de gestión vehicular diseñado con **Flutter** que prioriza la velocidad, la seguridad y la precisión de datos. Desde el rastreo de servicios hasta la localización geoespacial de talleres, todo está a un toque de distancia.

### 🛡️ Características Principales
*   **Garaje Inteligente**: Gestión de múltiples vehículos con indicadores de salud (Healthy, Attention, Critical) calculados mediante algoritmos de mantenimiento.
*   **Service Map**: Localización en tiempo real de servicios automotrices (Talleres, Gasolineras, Llanteras) utilizando **OpenStreetMap** y consultas espaciales a **Overpass API**.
*   **Notificaciones Predictivas**: Alertas meteorológicas y recordatorios de servicio sincronizados via WebSockets y persistencia local.
*   **Gestión Financiera**: Reflejo exacto de costos de mantenimiento con convertidor de divisas integrado.
*   **Seguridad de Grado Bancario**: Persistencia de sesiones mediante **JWT** con almacenamiento seguro (`flutter_secure_storage`).

---

## 🛠️ Stack Tecnológico Premium

La aplicación está construida sobre los cimientos más robustos del ecosistema Dart/Flutter:

*   **Core**: Flutter 3.x (Material 3).
*   **State Management**: `flutter_riverpod` (AsyncNotifier, State Machine, Family Providers).
*   **Navigation**: `go_router` para una navegación declarativa y profunda.
*   **Internacionalización**: `slang` para soporte multiidioma (ES/EN) con tipos seguros.
*   **Networking**: Resiliencia integrada en `http` con lógica de auto-refresh de tokens.
*   **Geo-Location**: `flutter_map` + `geolocator` para experiencias espaciales ricas.

---

## 🏗️ Arquitectura y Diseño

El proyecto sigue una estructura de **Clean Architecture / DDD Lite**, asegurando la separación total entre la lógica de negocio y la interfaz de usuario. Todo el código base está documentado profesionalmente siguiendo el estándar *Effective Dart*.

---

## 🚀 Instalación Rápida

Asegúrate de tener el entorno de Flutter configurado correctamente.

1.  **Clonar y configurar**:
    ```bash
    git clone https://github.com/DaniMancillaDev/DriverTrack_Frontend.git
    cd DriverTrack_Frontend
    ```

2.  **Instalar dependencias**:
    ```bash
    flutter pub get
    ```

3.  **Preparar generadores (i18n)**:
    ```bash
    dart run slang
    ```

4.  **Ejecutar**:
    ```bash
    flutter run
    ```

---

## 🌍 Contribución y Estándares
Todo el código sigue el estándar **Effective Dart**. Se utiliza documentación técnica extensiva (`///`) en todos los proveedores y capas de core para facilitar la colaboración.

---
Desarrollado con ❤️ por el equipo de **DriverTrack**.
