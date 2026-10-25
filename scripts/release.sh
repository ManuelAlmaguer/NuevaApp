#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# release.sh — construye, verifica y publica un APK release firmado.
#
#   ./scripts/release.sh              # usa la versión de app/build.gradle.kts
#   ./scripts/release.sh 1.0.0        # fija versionName y calcula versionCode
#
# Requisitos: keystore.properties + keys/release.jks + gh autenticado.
# ---------------------------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"
. /home/user/android-env.sh 2>/dev/null || true

VERSION="${1:-}"
GRADLE_FILE="app/build.gradle.kts"

if [[ -n "$VERSION" ]]; then
  [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Versión inválida: usa X.Y.Z"; exit 1; }
  IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"
  CODE=$(( MAJOR * 10000 + MINOR * 100 + PATCH ))
  sed -i -E "s/versionCode = [0-9]+/versionCode = ${CODE}/" "$GRADLE_FILE"
  sed -i -E "s/versionName = \"[^\"]+\"/versionName = \"${VERSION}\"/" "$GRADLE_FILE"
  echo "→ versionName=${VERSION}  versionCode=${CODE}"
fi

mkdir -p keys
[[ -f keystore.properties ]] || { echo "Falta keystore.properties"; exit 1; }
[[ -f "$(sed -nE 's/^storeFile=//p' keystore.properties)" ]] || { echo "Falta el keystore (keys/release.jks)"; exit 1; }

echo "→ Tests"
./gradlew :app:testDebugUnitTest --console=plain -q

echo "→ Build release"
./gradlew :app:assembleRelease --console=plain -q

APK="app/build/outputs/apk/release/app-release.apk"
BT="$ANDROID_HOME/build-tools/35.0.0"

echo "→ Verificando firma"
"$BT/apksigner" verify --verbose --print-certs "$APK"

VER=$(sed -nE 's/.*versionName = "([^"]+)".*/\1/p' "$GRADLE_FILE")
OUT="dist/NuevaApp-v${VER}.apk"
mkdir -p dist
cp "$APK" "$OUT"
"$BT/apksigner" verify "$OUT"
sha256sum "$OUT" | tee "$OUT.sha256"

echo "→ APK listo: $OUT"
echo "   Para publicar:  gh release create v${VER} \"$OUT\" --repo ManuelAlmaguer/NuevaApp --title \"NuevaApp v${VER}\" --notes-file CHANGELOG.md"