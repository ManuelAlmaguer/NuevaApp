# NuevaApp

Aplicación Android nativa en **Kotlin + Jetpack Compose (Material 3)**, con build reproducible y **APK release firmado** listo para distribuir.

> Estado: **infraestructura y pipeline de release listos**; la funcionalidad de producto está pendiente de definición.
> Ver [`HANDOFF.md`](HANDOFF.md) para el traspaso técnico completo.

---

## Stack

| | |
|---|---|
| Lenguaje | Kotlin 2.0.21 |
| UI | Jetpack Compose + Material 3 (BOM 2024.12.01) |
| Build | Gradle 8.11.1 · AGP 8.7.3 |
| SDK | compile/target 35 · min 24 |
| Firma | keystore PKCS12 RSA 4096 propio (`keys/release.jks`, no versionado) |
| Tests | JUnit4 + Robolectric (JVM, sin emulador) |
| CI/CD | GitHub Actions → Release con APK adjunto |

## Compilar

```bash
source /home/user/android-env.sh     # SDK + PATH
./gradlew :app:assembleDebug         # APK de depuración
./gradlew :app:testDebugUnitTest     # tests en JVM
./scripts/release.sh 1.0.0           # APK release firmado + verificado + sha256
```

Salida: `app/build/outputs/apk/release/app-release.apk` (release) y `dist/NuevaApp-vX.Y.Z.apk` (entrega).

## Firma

El `signingConfig` de release lee credenciales de:

1. `keystore.properties` (local, **git-ignored**), o
2. variables de entorno `SIGNING_STORE_FILE`, `SIGNING_STORE_PASSWORD`, `SIGNING_KEY_ALIAS`, `SIGNING_KEY_PASSWORD` (CI).

Huella SHA-256 del certificado de firma:

```
A7:45:75:D7:E0:B1:02:0C:E2:4E:59:65:53:2E:A9:01:31:96:FE:60:FF:6A:7A:53:11:1E:CB:A2:FA:0D:20:05
```

> Guarda el keystore y su contraseña: sin ellos no se pueden publicar actualizaciones con la misma identidad.

## Estructura

```
app/src/main/java/com/manuelalmaguer/nuevaapp/   código de la app
app/src/main/res/                                recursos e iconos
app/src/test/                                    tests JVM (Robolectric)
scripts/                                         entorno, release, iconos
.github/workflows/android-release.yml           CI de release
```

## Licencia

Uso privado del titular del repositorio. Todos los derechos reservados.