#!/bin/bash

# First, make sure we have the targets
rustup target add \
    x86_64-apple-darwin \
    aarch64-apple-darwin \
    x86_64-apple-ios \
    aarch64-apple-ios \

# Then, build the library
mkdir -p target/ios

cargo build --release --target aarch64-apple-ios --features "vendored-openssl" --target-dir "target/ios"
cargo build --release --target x86_64-apple-ios --features "vendored-openssl" --target-dir "target/ios"
# cargo build --release --target aarch64-apple-darwin --features "vendored-openssl" --target-dir "target/ios"
# cargo build --release --target x86_64-apple-darwin --features "vendored-openssl" --target-dir "target/ios"
