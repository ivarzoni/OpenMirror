#!/bin/bash
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
status=0
check() { if [ -e "$1" ]; then echo "OK: $2"; else echo "FALTA: $2 ($1)"; status=1; fi; }
if [ -n "${JAVA_HOME:-}" ]; then "$JAVA_HOME/bin/java" -version; else java -version; fi
check "$SDK/platforms/android-34/android.jar" 'Android SDK 34'
check "$SDK/build-tools/34.0.0" 'Build Tools 34.0.0'
check "$SDK/ndk/26.3.11579264" 'NDK 26.3.11579264'
check "$SDK/cmake/3.22.1" 'CMake 3.22.1'
check "$SDK/platform-tools/adb" 'ADB'
check "$ROOT/deps/openssl-build/armeabi-v7a/lib/libcrypto.a" 'OpenSSL ARMv7'
echo 'Java exigido: 17. SDK encontrado em:' "$SDK"
exit "$status"
