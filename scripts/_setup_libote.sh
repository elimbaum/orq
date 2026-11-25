#!/bin/bash

# abort if any command fails
set -e

## Set up libOTe
echo "==== Building libOTe..."

source $(dirname $0)/_clone_libote.sh

if [[ $(uname -m) == x86_64 ]]; then
    SSE_OPTION="-DENABLE_SSE=ON"
else
    SSE_OPTION="-DENABLE_SSE=OFF -DENABLE_AVX=OFF "
fi

# <format> is in libstdc++ from GCC 13. Use g++-13 when the default compiler is older.
if ! echo '#include <format>' | ${CXX:-g++} -std=c++20 -x c++ -E - >/dev/null 2>&1; then
    if command -v g++-13 >/dev/null 2>&1; then
        export CXX=g++-13
        export CC=gcc-13
    else
        echo "libOTe requires GCC 13 or newer (missing <format>). Install g++-13 and rerun." >&2
        exit 1
    fi
fi

# Boost.Asio includes <termios.h>, and that header's B0 macro breaks the libOTe tests.
python3 build.py --par=4 --boost --sodium --relic -DSODIUM_MONTGOMERY=false -DENABLE_LOGVOLE=OFF --all --install=../libOTe-install \
    -DCMAKE_CXX_FLAGS=-DBOOST_ASIO_DISABLE_SERIAL_PORT \
    $SSE_OPTION

echo "==== libOTe installed"
