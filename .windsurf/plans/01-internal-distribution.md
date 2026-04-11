# Internal Distribution + Production Readiness (Phase 1)

This plan prepares DriveTrack for internal distribution on Android and iOS by fixing release identifiers/signing, externalizing environment config, and tightening auth token storage, while keeping push notifications as a later phase.

## Goals (outcomes)
- Produce installable, shareable **release builds** for Android and iOS suitable for internal testers.
- Make builds configurable per environment without code changes (base URL, API keys).
- Remove obvious production blockers (debug signing, example app id, missing iOS permission strings).
- Improve security posture for internal distribution by moving JWT to secure storage.

## Scope
- In scope: Android package id + release signing, iOS bundle id + signing readiness, environment config via `--dart-define(-from-file)`, iOS/Android permission checklist (location, notifications placeholders), JWT storage hardening.
- Out of scope (Phase 2): full push implementation (FCM/APNs), CI/CD automation, crash reporting.

## Milestones

### 1) Android: release identity + signing (blocker)
- Change `applicationId` from `com.example.drivetrack` to the final one.
- Configure `signingConfigs.release` and switch `buildTypes.release` to use it (stop using debug signing).
- Add a safe pattern for local keystore config (not committed secrets), typically via `key.properties` ignored by git.
- Output: `flutter build apk --release` works and produces a signed APK for sharing.

### 2) iOS: bundle identity + signing readiness (blocker)
- Confirm final iOS Bundle Identifier.
- Ensure `Info.plist` contains required permission usage descriptions for features in use (at minimum location).
- Confirm Apple Developer Program availability; if available, target TestFlight (later) or Ad Hoc provisioning for internal.
- Output: iOS release build can be archived/signed in Xcode with correct identifiers.

### 3) Environment config: stop hardcoding and support internal endpoints
- Make `AppConfig` read `baseUrl` and keys from `String.fromEnvironment`.
- Add `--dart-define-from-file` workflow (ex: `.env/internal.json`) so internal testers can hit a reachable backend.
- Ensure `appConfigProvider` no longer always returns `AppConfig.dev()`; instead construct from environment.
- Output: you can build internal variants pointing to LAN IP / tunnel / VPS without code edits.

### 4) Auth security: move JWT out of SharedPreferences
- Add secure token storage (Keychain/Keystore) using `flutter_secure_storage`.
- Update `AuthNotifier` persistence:
  - keep user profile in SharedPreferences (optional)
  - move `user_token` to secure storage
  - add one-time migration: if token exists in prefs, move then delete.
- Output: internal builds are safer; token is not stored in plain prefs.

### 5) Distribution workflow for testers (recommended)
- Android: share signed APK directly OR set up Firebase App Distribution.
- iOS: recommended path is TestFlight (requires Apple Dev Program).

## Open questions (need your answers before implementation)
1) What final app IDs do you want?
   - Android `applicationId` (example: `com.yourorg.drivetrack`)
   - iOS Bundle ID (usually same reverse-domain style)
2) Internal distribution method preference:
   - Android: direct APK vs Firebase App Distribution
   - iOS: TestFlight vs Ad Hoc
3) For internal backend access (no domain yet):
   - Will testers be on the same Wi-Fi/LAN as your backend, or remote?
   - If remote, do you prefer a temporary tunnel (ngrok/cloudflared) or a small VPS?

## Acceptance criteria
- Android release build is **signed with release keystore**, not debug.
- iOS project has correct identifiers and required permission usage strings.
- `baseUrl` is set via build-time environment (`dart-define`), not hardcoded.
- JWT is stored securely (Keychain/Keystore).
