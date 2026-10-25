# HANDOFF — NuevaApp (Android)

> **Documento de traspaso.** Léelo completo antes de tocar el proyecto.
> Última actualización: **2026-10-25** · Sesión: bootstrap de entorno + repositorio + pipeline de release.
> Estado global: **INFRAESTRUCTURA LISTA · CONTENIDO DE LA APP PENDIENTE**.

---

## 1. Resumen en una frase

`NuevaApp` es un proyecto Android nativo (Kotlin + Jetpack Compose) ya **compilable, testeable y firmable**; el APK release se firma con un keystore propio creado en esta sesión. El **concepto funcional de la app todavía no ha sido definido por el usuario**: ahora mismo hay una pantalla placeholder que debe sustituirse.

---

## 2. Datos clave (hoja de referencia rápida)

| Elemento | Valor |
|---|---|
| Repositorio | `https://github.com/ManuelAlmaguer/NuevaApp` |
| Cuenta GitHub | `@ManuelAlmaguer` (vía conector `github`, OAuth, scopes `repo` + `workflow`) |
| Nombre de app | NuevaApp (`@string/app_name`) |
| Application ID | `com.manuelalmaguer.nuevaapp` |
| Namespace Kotlin | `com.manuelalmaguer.nuevaapp` |
| versionName actual | `1.0.0` |
| versionCode actual | `1` |
| minSdk / target / compile | 24 / 35 / 35 |
| JDK | 21 (`/usr/lib/jvm/java-21-openjdk-amd64`) |
| Gradle | 8.11.1 (wrapper en el repo) |
| AGP | 8.7.3 |
| Kotlin | 2.0.21 (con plugin Compose) |
| Compose BOM | 2024.12.01 |
| Android SDK | `/home/user/android-sdk` (platforms;android-35, build-tools;35.0.0, platform-tools) |
| Keystore release | `NuevaApp/keys/release.jks` (git-ignored) · copia en `/home/user/keys/` |
| Alias | `nuevaapp` · RSA **4096** bits · PKCS12 · validez 30 años (hasta 2056-10-17) |
| SHA-256 del certificado | `A7:45:75:D7:E0:B1:02:0C:E2:4E:59:65:53:2E:A9:01:31:96:FE:60:FF:6A:7A:53:11:1E:CB:A2:FA:0D:20:05` |
| SHA-1 del certificado | `A1:57:B2:99:94:DE:E3:50:61:36:2B:68:D0:9D:22:6F:46:7A:07:09` |
| Esquemas de firma | APK Signature Scheme **v2 + v3** (v1 no aplica con minSdk 24) |
| Tamaño APK release (placeholder) | ~748 KB |

**Credenciales de firma:** están en `NuevaApp/keystore.properties` (git-ignored) y en `/home/user/keys/keystore.properties` (chmod 600). Se entregaron al usuario por chat/web. **No se versionan nunca.**

---

## 3. Qué se ha hecho en esta sesión (bitácora)

1. **Diagnóstico del entorno**: Ubuntu 24.04, x86_64, JDK 21, Gradle global 4.4.1 (inservible para AGP moderno), sin Android SDK, `gh` ya autenticado, sin `/dev/kvm` (no hay emulador posible).
2. **Instalación del toolchain**
   - Android command-line tools `11076708` → `/home/user/android-sdk`.
   - `platform-tools`, `platforms;android-35`, `build-tools;35.0.0`; licencias aceptadas.
   - Gradle 8.11.1 en `/opt/gradle` + wrapper en el repo (el build **no** depende del Gradle global).
   - Script de entorno persistente `/home/user/android-env.sh` (enlazado desde `~/.bashrc`); **hay que hacer `source` en cada shell nueva**.
   - Pillow en `/home/user/.venv-img` (para generar iconos).
3. **Scaffold Android completo** en `NuevaApp/`: Gradle KTS, manifiesto, tema Material 3 (claro/oscuro), tipografía, iconos adaptativos + PNG por densidad, reglas ProGuard/R8, backup rules, `.gitignore`, `keystore.properties.example`.
4. **Firma real creada**: keystore PKCS12 RSA 4096, alias `nuevaapp`, contraseña aleatoria de 32 caracteres. `signingConfigs.release` lee de `keystore.properties` (local) **o** de variables de entorno `SIGNING_*` (CI).
5. **Build verificado end-to-end**:
   - `./gradlew :app:assembleRelease` → **BUILD SUCCESSFUL**.
   - `apksigner verify --print-certs` → `Verifies`, v2 ✅, v3 ✅, 1 firmante, RSA 4096.
   - `aapt2 dump badging` → `com.manuelalmaguer.nuevaapp` v1.0.0, minSdk 24, targetSdk 35.
6. **Tests reales en JVM** con Robolectric (`MainActivityTest`): 2/2 en verde. Verifican que la Activity arranca y que la UI Compose se renderiza y muestra textos. **Esto es la red de seguridad del proyecto**: sin emulador, es la única prueba de ejecución real.
7. **CI/CD**: `.github/workflows/android-release.yml` — tests → build release → verificación de firma → artefacto; en tags `v*.*.*` publica GitHub Release con el APK.
8. **Scripts operativos**: `scripts/setup_env.sh`, `scripts/release.sh`, `scripts/generate_icons.py`.

---

## 4. Estado actual del código (mapa de ficheros)

```
NuevaApp/
├── app/
│   ├── build.gradle.kts            # versión, firma, R8, Compose, tests
│   ├── proguard-rules.pro
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml
│       │   ├── java/com/manuelalmaguer/nuevaapp/
│       │   │   ├── MainActivity.kt          # ⚠️ PANTALLA PLACEHOLDER
│       │   │   └── ui/theme/{Theme,Type}.kt
│       │   └── res/ (values, values-night, mipmap-*, drawable, xml)
│       └── test/java/com/manuelalmaguer/nuevaapp/MainActivityTest.kt
├── scripts/{setup_env.sh,release.sh,generate_icons.py}
├── store/icon-512.png              # icono para ficha de tienda
├── .github/workflows/android-release.yml
├── keystore.properties.example     # plantilla (el real está git-ignored)
├── gradlew / gradle/wrapper/
├── README.md
└── HANDOFF.md (este archivo)
```

`MainActivity.kt` contiene hoy una pantalla de bienvenida que muestra versión/paquete. **Debe reemplazarse por la app real.**

---

## 5. Cómo continuar (runbook para una sesión nueva)

```bash
# 1. Entorno (obligatorio en cada shell)
source /home/user/android-env.sh

# 2. Proyecto
cd /home/user/workspace/NuevaApp        # si no existe: git clone https://github.com/ManuelAlmaguer/NuevaApp

# 3. Restaurar credenciales de firma si el sandbox se reinició
#    (keystore + contraseña: pedirlos al usuario o recuperarlos del repo privado NuevaApp-keys)
ls keystore.properties keys/release.jks

# 4. Tests + build
./gradlew :app:testDebugUnitTest
./gradlew :app:assembleRelease

# 5. Release completo (tests + firma + verificación + sha256)
./scripts/release.sh 1.0.0
```

**Si el sandbox se reinicia:** SDK y Gradle pueden reinstalarse con `./scripts/setup_env.sh`; el código está en GitHub; **el keystore NO está en el repo público** — sin él no se pueden publicar actualizaciones con la misma identidad de firma.

---

## 6. Pipeline de release (cómo se publica)

### Opción A — Local (usada y verificada)
```bash
./scripts/release.sh 1.0.0
gh release create v1.0.0 dist/NuevaApp-v1.0.0.apk \
  --repo ManuelAlmaguer/NuevaApp --title "NuevaApp v1.0.0" --notes "..."
```

### Opción B — GitHub Actions (configurada, pendiente de secretos)
Añadir en *Settings → Secrets and variables → Actions*:
| Secret | Contenido |
|---|---|
| `SIGNING_KEYSTORE_BASE64` | `base64 -w0 keys/release.jks` |
| `SIGNING_STORE_PASSWORD` | contraseña del keystore |
| `SIGNING_KEY_ALIAS` | `nuevaapp` |
| `SIGNING_KEY_PASSWORD` | contraseña de la clave |

Luego: `git tag v1.0.0 && git push origin v1.0.0` → Release con APK adjunto.

---

## 7. Decisiones tomadas (y por qué)

| # | Decisión | Motivo |
|---|---|---|
| D1 | Kotlin + Jetpack Compose (Material 3) | UI declarativa, menos XML, rápido de iterar; estándar actual. |
| D2 | `minSdk 24` | Cubre >98% de dispositivos activos y evita multidex forzado. |
| D3 | `targetSdk/compileSdk 35` | Requisito de Play Store 2025+. |
| D4 | R8 + `shrinkResources` | APK pequeño y ofuscado desde el primer día. |
| D5 | Firma por `keystore.properties` o env vars | Permite build local y CI sin filtrar secretos. |
| D6 | Keystore **fuera** del repo público | Si la clave se publica, cualquiera puede firmar actualizaciones maliciosas. Backup en repo privado `NuevaApp-keys`. |
| D7 | Robolectric para tests de UI | No hay KVM/emulador en el sandbox; es la única verificación de ejecución real posible. |
| D8 | `leakcanary` u otras libs NO añadidas aún | Mantener el scaffold mínimo; se añadirán según el concepto de app. |

---

## 8. Lo que falta (backlog ordenado)

- [ ] **BLOQUEANTE**: recibir del usuario el concepto de la app (qué hace, pantallas, datos, permisos).
- [ ] Definir arquitectura de features (MVVM + Repository, Room si hay persistencia, DataStore para preferencias).
- [ ] Construir pantallas reales y navegación (`androidx.navigation-compose`).
- [ ] Sustituir iconos/colores/`app_name` por la identidad definitiva de la app.
- [ ] Ampliar tests Robolectric por pantalla + tests unitarios de lógica.
- [ ] Subir secretos de firma a GitHub Actions y validar la CI con un `workflow_dispatch`.
- [ ] Tag `v1.0.0` + GitHub Release con APK firmado final (criterio de entrega del usuario).
- [ ] Crear repo privado `NuevaApp-keys` con el backup del keystore.
- [ ] (Opcional) AAB para Play Store; `store/icon-512.png` y capturas ya previstas.

---

## 9. Puntos a recordar / trampas conocidas

1. **`source /home/user/android-env.sh`** en cada shell: `~/.bashrc` no se evalúa en shells no interactivas.
2. **Gradle global es 4.4.1 y NO sirve.** Usa siempre `./gradlew`.
3. **`gradle.properties` tiene configuration cache activado**: si un script modifica `build.gradle.kts` en caliente, puede requerir `--no-configuration-cache`.
4. **Los tests de UI necesitan Robolectric con `@Config(sdk = [33])`** y `testOptions.unitTests.isIncludeAndroidResources = true`. Si se quita, fallan con recursos nulos.
5. **No hay emulador** (`/dev/kvm` ausente). No perder tiempo intentando `avdmanager`/`emulator`.
6. **El keystore caduca en 2056**, pero **si se pierde la contraseña no hay recuperación posible**: Google Play rechazará cualquier actualización firmada con otra clave.
7. Las contraseñas del keystore están en texto plano en `keystore.properties` (local, git-ignored) — nunca mover ese archivo al repo.
8. `versionCode` se calcula como `MAJOR*10000 + MINOR*100 + PATCH` en `release.sh`: no editarlo a mano para no romper el orden de actualizaciones.
9. `local.properties` (ruta del SDK) es local y git-ignored; en CI lo genera `android-actions/setup-android`.
10. El reloj del sandbox marca 2026: los timestamps de commits y del certificado reflejan eso.

---

## 10. Verificación rápida (¿está todo bien?)

```bash
source /home/user/android-env.sh && cd /home/user/workspace/NuevaApp
./gradlew :app:testDebugUnitTest :app:assembleRelease -q          # debe terminar sin errores
apksigner verify --print-certs app/build/outputs/apk/release/app-release.apk | head -3
aapt2 dump badging app/build/outputs/apk/release/app-release.apk | head -1
```
Esperado: `Verifies`, `v2 scheme: true`, `v3 scheme: true`, `versionName='1.0.0'`.

---

## 11. Definición de "terminado" para el usuario

1. APK **release firmado** instalable en un Android real (no debug).
2. Código fuente completo en `github.com/ManuelAlmaguer/NuevaApp`.
3. GitHub Release **v1.0.0** con el APK adjunto + checksum SHA-256.
4. Tests en verde y este handoff actualizado con el estado final.