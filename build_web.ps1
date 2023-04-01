#!/bin/bash

#set -e
$ErrorActionPreference = "Stop"

Set-Variable OPTIMIZE="-Os"
#export LDFLAGS="${OPTIMIZE}"
#export CFLAGS="${OPTIMIZE}"
#export CPPFLAGS="${OPTIMIZE}"

Write-Output "============================================="
Write-Output "Compiling wasm bindings"
Write-Output "============================================="

mkdir -p source/web/build -Force

# Compile C/C++ code
& emcc `
  -std=c++1y `
  -DXA_MULTITHREADED=0 `
  ${OPTIMIZE} `
  --bind `
  --no-entry `
  -s ERROR_ON_UNDEFINED_SYMBOLS=0 `
  -s ALLOW_MEMORY_GROWTH=1 `
  -s MALLOC=emmalloc `
  -s MODULARIZE=1 `
  -s ENVIRONMENT='worker' `
  -s EXPORT_NAME="createXAtlasModule" `
  -o ./source/web/build/xatlas.js `
  --js-library ./source/web/jslib.js `
  ./source/web/xatlas_web.cpp `
  ./source/xatlas/xatlas.cpp `
  -s ASSERTIONS=1 `
  -DNDEBUG `
  # -gsource-map `
  #    -s TOTAL_MEMORY=278mb `
#    -D SANITIZE_ADDRESS_CHECK `
#    -fsanitize=address `
#    -g3 `
#    Uncomment above line for leak checking

# Move artifacts
If (Test-Path ./dist -PathType Container) { Remove-Item -path ./dist -recurse -force }
New-Item -path ./dist -ItemType Directory
Copy-Item source/web/build/xatlas.wasm dist  -force
If (Test-Path source/web/build/xatlas.wasm.map) { Copy-Item source/web/build/xatlas.wasm.map dist -force }

Write-Output "============================================="
Write-Output "Compiling wasm bindings done"
Write-Output "============================================="
