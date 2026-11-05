#!/bin/bash
# OpenMirror: rebuild OpenSSL from a fixed official source archive, never trust vendored .a files.
set -euo pipefail
VER=3.3.2
SHA=2e8a40b01979afe8be0bbfb3de5dc1c6709fedb46d6c89c10da114ab5fc3d281
HERE="$(cd "$(dirname "$0")" && pwd)"
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
NDK="${NDK_HOME:-$SDK/ndk/26.3.11579264}"
OUT="$HERE/openssl-build/armeabi-v7a"
CACHE="$HERE/.cache"
SRC="$CACHE/openssl-$VER"
ARCHIVE="$CACHE/openssl-$VER.tar.gz"
[ -d "$NDK" ] || { echo "NDK ausente: $NDK" >&2; exit 1; }
mkdir -p "$CACHE"
if [ ! -f "$ARCHIVE" ]; then
  curl -fL --retry 2 "https://github.com/openssl/openssl/releases/download/openssl-$VER/openssl-$VER.tar.gz" -o "$ARCHIVE"
fi
printf '%s  %s\n' "$SHA" "$ARCHIVE" | shasum -a 256 -c -
if [ ! -f "$SRC/Configure" ]; then tar -xzf "$ARCHIVE" -C "$CACHE"; fi
export ANDROID_NDK_ROOT="$NDK"
TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin"
[ -d "$TOOLCHAIN" ] || TOOLCHAIN="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
export PATH="$TOOLCHAIN:$PATH"
cd "$SRC"
if [ -f Makefile ]; then make clean >/dev/null; fi
./Configure android-arm -D__ANDROID_API__=24 no-shared no-tests no-docs no-legacy no-comp no-asm --prefix="$OUT"
make build_generated
make -j4 libcrypto.a libssl.a
mkdir -p "$OUT/lib" "$OUT/include"
cp libcrypto.a libssl.a "$OUT/lib/"
mkdir -p "$OUT/include/openssl"
cp include/openssl/*.h "$OUT/include/openssl/"
printf '%s\n' "$SHA" > "$OUT/SOURCE_SHA256"
echo "OpenSSL $VER compilado do fonte em $OUT"
