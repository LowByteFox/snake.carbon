#!/bin/sh

RAYLIB="https://github.com/raysan5/raylib/releases/download/6.0/raylib-6.0_linux_amd64.tar.gz"
TAR=$(basename "$RAYLIB")
DIR="${TAR%.tar.gz}"

if [ ! -f "$TAR" ]; then
    wget $RAYLIB
fi

tar xf "$TAR"
mv "$DIR" "raylib"
