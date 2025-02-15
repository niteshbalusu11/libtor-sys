#!/bin/bash

# Exit on error
set -e

# Set up iOS-specific environment
export PLATFORM_NAME=iphoneos
export DEVELOPER_DIR="$(xcode-select -p)"
export SDKROOT="$DEVELOPER_DIR/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"

# First, make sure we have the targets
rustup target add \
    x86_64-apple-ios \
    aarch64-apple-ios

# Then, build the library
mkdir -p target/ios

echo "Building for iOS (arm64)..."
cargo build --release \
    --target aarch64-apple-ios \
    --features "vendored-openssl" \
    --target-dir "target/ios"

echo "Building for iOS Simulator (x86_64)..."
cargo build --release \
    --target x86_64-apple-ios \
    --features "vendored-openssl" \
    --target-dir "target/ios"

# Create universal binary (optional)
echo "Creating universal binary..."
if [ -f "target/ios/aarch64-apple-ios/release/libtor_sys.dylib" ] && \
   [ -f "target/ios/x86_64-apple-ios/release/libtor_sys.dylib" ]; then
    mkdir -p target/ios/universal
    lipo -create \
        target/ios/aarch64-apple-ios/release/libtor_sys.dylib \
        target/ios/x86_64-apple-ios/release/libtor_sys.dylib \
        -output target/ios/universal/libtor_sys.dylib
    echo "Universal binary created at target/ios/universal/libtor_sys.dylib"
else
    echo "Warning: Could not create universal binary. One or both architecture builds are missing."
fi

echo "iOS build complete!"
