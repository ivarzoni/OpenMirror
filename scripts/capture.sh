#!/bin/bash
set -eu
[ "$#" -eq 2 ] || { echo "Uso: $0 IP:5555 arquivo.log" >&2; exit 2; }
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
echo 'Capturando novos logs; encerre com Ctrl+C. Arquivo pode conter identificadores da rede.' >&2
"$SDK/platform-tools/adb" -s "$1" logcat -T 1 -v threadtime OpenMirror:I AirPlay:I AirPlayStack:I VideoSink:I AudioSink:W AndroidRuntime:E '*:S' > "$2"
