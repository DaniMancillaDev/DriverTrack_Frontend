# Profile Page — Pulidos y features pendientes

Plan para auditar la pantalla `ProfilePage`, pulir UX/UI y cerrar funcionalidades pendientes (editar perfil, seguridad, soporte) de forma incremental y con criterios de “done”.

## Hallazgos rápidos (lo más visible)

- **Acciones UI sin comportamiento**
  - `ProfileHero`: el ícono de cámara y el ícono de editar son solo UI (no hay `onTap`).
  - `ProfileSecurityButton` (Reset password): no tiene `onTap`.
  - Soporte: `FAQs`, `Chat support` y teléfono están como filas sin navegación/acción real.
  - “Rate DriveTrack”: no abre store ni deep link.

- **Manejo de estados Async (loading/error) mejorable**
  - `profilePreferencesProvider` es `AsyncNotifier`, pero en UI se usa `prefsAsync.value ?? const ProfilePreferences()`:
    - En `loading` muestra valores por defecto y deja toggles activos (puede sentirse “parpadeo” cuando carga lo persistido).
    - En `error` también cae a defaults sin informar al usuario.
  - `ProfileStatsDashboard`: en `error` muestra skeleton (no hay “retry” ni mensaje).

- **Consistencia de componentes**
  - `ProfileToggleRow` / `ProfileSelectionRow`: tienen `showBottomBorder`, pero actualmente no se ve lógica de borde/divisor (señal de feature incompleta o refactor a medias).
  - En algunos items se usa `GestureDetector` en lugar de `InkWell` (sin ripple, sin feedback material, peor accesibilidad).

- **Contenido hardcodeado**
  - Teléfono `+1 (800) DRIVE-TK` está hardcodeado (no i18n / no config).

## Qué pulir (UX/UI)

1. **Estados de carga y error “honestos”**
   - Preferencias: mientras carga, deshabilitar toggles y mostrar un mini loader o skeleton dentro de la sección.
   - En error: mostrar mensaje corto y botón “Reintentar”.
   - Stats dashboard: si falla API, mostrar fallback con `Retry` en vez de skeleton infinito.

2. **Accesibilidad y feedback**
   - Reemplazar taps con `InkWell`/`ListTile` donde aplique.
   - Asegurar `min tap target` (48dp) y `Semantics` para avatar/edit/camera.

3. **Consistencia visual**
   - Definir una regla para separadores en secciones expandibles (dividers o spacing). Actualmente hay props de borde no utilizadas.
   - Revisar contraste de `textMuted/textSecondary` vs backgrounds según tema.

## Features que faltan implementar (funcionalidad)

1. **Editar perfil**
   - Pantalla/modal para editar `fullName` (y posiblemente email si lo permite el backend).
   - Guardar cambios en backend + reflejar en `authProvider` (y persistencia de sesión).

2. **Foto de perfil**
   - Elegir fuente (galería/cámara) + upload.
   - Guardar imagen en bucket **MinIO (S3-compatible)** y persistir solo la URL en backend (o en sesión si decides no guardarla aún).
   - Fallback local (iniciales) si no hay foto.

3. **Reset password / Seguridad**
   - Recomendación: implementar **cambio de contraseña dentro de sesión** (requiere contraseña actual).
     - Mantiene el producto simple para distribución interna (sin infraestructura de emails/tokens).
   - Decisión: **no implementar “forgot password”** por ahora; remover cualquier UI asociada.
   - 2FA: se mantiene como **UI/placeholder local** (toggle en `SharedPreferences`, sin backend).

4. **Soporte y rating**
   - Mantener solo **Teléfono** (tu número) con `tel:` launcher.
   - Remover de Profile: FAQs, Chat, Rate app (no aplica por distribución interna).

## Preguntas para cerrar alcance (bloqueantes)

- **Backend**
  - ¿Ya existen endpoints para actualizar perfil (nombre/email) y foto? ¿Cuáles?
  - Contraseña: implementar **cambiar contraseña** (in-session) y eliminar “forgot” (decisión tomada).
  - Foto: si no hay endpoint para foto, ¿vas a guardar la **URL en el backend** (ideal) o lo dejamos solo local en app en esta iteración?
  - Bucket: **MinIO**. Confirmar:
    - nombre del bucket (e.g. `drivertrack`)
    - si los objetos serán `public-read` o privados
    - si el backend entregará **pre-signed URLs** (recomendado) para `PUT` (upload) y (opcional) para `GET`

- **Navegación/UX**
  - Editar perfil: se implementa como **bottom sheet** (decisión tomada).
  - Soporte: solo llamada telefónica.

## Entregables (milestones)

1. **Pulido de estados y accesibilidad**
   - Loading/error/retry en stats y preferencias.
   - Taps con feedback (InkWell) + semantics.

2. **Acciones reales conectadas**
   - Edit profile (bottom sheet + integración backend).
   - Contraseña: cambio de contraseña (o remover UI de reset/forgot si no entra).
   - Soporte: llamada telefónica (tu número).

3. **Foto de perfil (si entra en alcance)**
   - Picker + subida a bucket (MinIO, idealmente via pre-signed URL) + cache/fallback.

4. **Checklist de QA**
   - Probar con: sin sesión (`authProvider == null`), con sesión, APIs fallando, tema dark/light, ES/EN, tablet.
