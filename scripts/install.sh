#!/bin/bash
set -eu
if [ "$#" -ne 1 ]; then echo "Uso: $0 IP_DO_FIRE_TV:5555" >&2; exit 2; fi
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
ADB="$SDK/platform-tools/adb"
APK="$ROOT/app/build/outputs/apk/debug/app-debug.apk"
[ -f "$APK" ] || { echo 'Compile assembleDebug primeiro.' >&2; exit 1; }
"$ADB" connect "$1"
"$ADB" -s "$1" shell getprop ro.product.cpu.abilist
if ! "$ADB" -s "$1" shell getprop ro.product.cpu.abilist | tr ',' '\n' | tr -d '\r' | grep -qx armeabi-v7a; then
  echo 'Este protótipo exige ABI armeabi-v7a. Instalação cancelada.' >&2; exit 1
fi
"$ADB" -s "$1" install -r "$APK"
"$ADB" -s "$1" shell am start -n org.openmirror.presentation/com.codelphi.airplay.MirrorActivity
