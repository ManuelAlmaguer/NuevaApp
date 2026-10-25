#!/usr/bin/env bash
# setup_env.sh — prepara el entorno Android en una máquina Linux limpia.
# Idempotente: si el SDK ya existe, solo exporta variables.
set -euo pipefail

SDK_ROOT="${ANDROID_SDK_ROOT:-/home/user/android-sdk}"
CMDLINE_VERSION="11076708"
GRADLE_VERSION="8.11.1"
BUILD_TOOLS="35.0.0"
PLATFORM="android-35"

if [[ ! -d "$SDK_ROOT/cmdline-tools/latest" ]]; then
  echo "→ Descargando Android command-line tools"
  mkdir -p "$SDK_ROOT/cmdline-tools" /tmp/cmdline
  curl -sSL -o /tmp/cmdline/tools.zip \
    "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_VERSION}_latest.zip"
  unzip -q /tmp/cmdline/tools.zip -d "$SDK_ROOT/cmdline-tools"
  mv "$SDK_ROOT/cmdline-tools/cmdline-tools" "$SDK_ROOT/cmdline-tools/latest"
fi

export ANDROID_HOME="$SDK_ROOT"
export ANDROID_SDK_ROOT="$SDK_ROOT"
export PATH="$SDK_ROOT/cmdline-tools/latest/bin:$SDK_ROOT/platform-tools:$SDK_ROOT/build-tools/$BUILD_TOOLS:$PATH"

yes | sdkmanager --licenses >/dev/null 2>&1 || true
sdkmanager --install "platform-tools" "platforms;$PLATFORM" "build-tools;$BUILD_TOOLS" >/dev/null

cat > /home/user/android-env.sh <<EOF
export ANDROID_HOME=$SDK_ROOT
export ANDROID_SDK_ROOT=$SDK_ROOT
export ANDROID_USER_HOME=/home/user/.android
export JAVA_HOME=\${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk-amd64}
export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/build-tools/$BUILD_TOOLS:\$PATH
EOF

echo "→ SDK listo en $SDK_ROOT"
java -version 2>&1 | head -1
echo "Gradle: usa ./gradlew (wrapper $GRADLE_VERSION); no requiere Gradle global."