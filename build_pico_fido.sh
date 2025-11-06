#!/bin/bash

VERSION_MAJOR="7"
VERSION_MINOR="0"
NO_EDDSA=0
SUFFIX="${VERSION_MAJOR}.${VERSION_MINOR}"
#if ! [[ -z "${GITHUB_SHA}" ]]; then
#    SUFFIX="${SUFFIX}.${GITHUB_SHA}"
#fi

if [[ $1 == "--no-eddsa" ]]; then
    NO_EDDSA=1
    echo "Skipping EDDSA build"
fi

mkdir -p build_release
mkdir -p release
mkdir -p release_eddsa
rm -rf -- release/*
if [[ $NO_EDDSA -eq 0 ]]; then
    rm -rf -- release_eddsa/*
fi
cd build_release

PICO_SDK_PATH="${PICO_SDK_PATH:-../../pico-sdk}"
SECURE_BOOT_PKEY="${SECURE_BOOT_PKEY:-../../ec_private_key.pem}"

if [[ $NO_EDDSA -eq 0 ]]; then
    board_name="$(basename -- "waveshare_rp2350_one" .h)"
    rm -rf -- ./*
    PICO_SDK_PATH="${PICO_SDK_PATH}" cmake .. -DPICO_BOARD=$board_name -DSECURE_BOOT_PKEY=${SECURE_BOOT_PKEY} -DENABLE_EDDSA=1
    make -j`nproc`
    mv pico_fido.uf2 ../release_eddsa/pico_fido_$board_name-$SUFFIX-eddsa1.uf2
fi
