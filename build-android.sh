#!/bin/bash

# Exit on error
set -e

# Unset any iOS/macOS specific variables that might interfere
unset SDKROOT
unset PLATFORM_NAME
unset IPHONEOS_DEPLOYMENT_TARGET
unset TVOS_DEPLOYMENT_TARGET
unset XROS_DEPLOYMENT_TARGET

# First, make sure we have the targets
rustup target add \
    aarch64-linux-android \
    x86_64-linux-android \
    i686-linux-android

# Then, build the library
mkdir -p target/android

echo "Building for Android..."
cargo ndk \
    --platform 34 \
    -t arm64-v8a \
    -t x86 \
    -t x86_64 \
    --output-dir "target/android" \
    build --release \
    --features "vendored-openssl"

echo "Android build complete!"
