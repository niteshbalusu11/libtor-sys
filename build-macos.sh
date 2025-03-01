#!/bin/bash

# Exit on error
set -e

# Set up macOS-specific environment
unset SDKROOT
unset PLATFORM_NAME
unset DEVELOPER_DIR
export DEVELOPER_DIR="$(xcode-select -p)"
export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
# export MACOSX_DEPLOYMENT_TARGET="11.0"

# First, make sure we have the targets
rustup target add \
    aarch64-apple-darwin \
    x86_64-apple-darwin

# Create output directory
mkdir -p target/macos

# Build for Apple Silicon
echo "Building for Apple Silicon (arm64)..."
cargo build --release \
    --target aarch64-apple-darwin \
    --features "vendored-openssl" \
    --target-dir "target/macos"

# Build for Intel
echo "Building for Intel (x86_64)..."
cargo build --release \
    --target x86_64-apple-darwin \
    --features "vendored-openssl" \
    --target-dir "target/macos"

# Create universal dynamic binary (optional)
echo "Creating universal binary..."
if [ -f "target/macos/aarch64-apple-darwin/release/libtor_sys.dylib" ] && \
   [ -f "target/macos/x86_64-apple-darwin/release/libtor_sys.dylib" ]; then
    mkdir -p target/macos/universal
    lipo -create \
        target/macos/aarch64-apple-darwin/release/libtor_sys.dylib \
        target/macos/x86_64-apple-darwin/release/libtor_sys.dylib \
        -output target/macos/universal/libtor_sys.dylib
    echo "Universal binary created at target/macos/universal/libtor_sys.dylib"
else
    echo "Warning: Could not create universal binary. One or both architecture builds are missing."
fi

# Create universal static binary (optional)
echo "Creating universal static binary..."
if [ -f "target/macos/aarch64-apple-darwin/release/libtor_sys.a" ] && \
   [ -f "target/macos/x86_64-apple-darwin/release/libtor_sys.a" ]; then
    mkdir -p target/macos/universal
    lipo -create \
        target/macos/aarch64-apple-darwin/release/libtor_sys.a \
        target/macos/x86_64-apple-darwin/release/libtor_sys.a \
        -output target/macos/universal/libtor_sys.a
    echo "Universal static binary created at target/macos/universal/libtor_sys.a"
else
    echo "Warning: Could not create universal static binary. One or both architecture builds are missing."
fi

echo "macOS build complete!"
