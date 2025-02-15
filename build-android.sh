#!/bin/bash

# First, make sure we have the targets
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android

# Then, build the library
mkdir -p target/android

cargo ndk \
    --platform 34 \
    -t arm64-v8a \
    -t x86 \
    -t x86_64 \
    --output-dir "target/android" \
    build --release \
    --features "vendored-openssl"
