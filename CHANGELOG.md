# Changelog

Todas las versiones notables de NuevaApp.

## [Unreleased]

### Pendiente
- Definición del producto y pantallas reales de la app.

## [1.0.0] — En preparación

### Añadido
- Scaffold Android nativo: Kotlin 2.0.21 + Jetpack Compose (Material 3).
- Tema claro/oscuro, tipografía, iconos adaptativos y de tienda.
- Firma release real (PKCS12, RSA 4096, alias `nuevaapp`) con v2 + v3.
- Tests JVM con Robolectric que validan el arranque de la Activity y el render de la UI.
- Pipeline CI: tests → APK firmado → verificación → GitHub Release en tags.
- Scripts `setup_env.sh`, `release.sh`, `generate_icons.py`.
