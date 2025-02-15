# libtor-sys ![Continuous integration](https://github.com/MagicalBitcoin/libtor-sys/workflows/Continuous%20integration/badge.svg?branch=master)

This library compiles Tor and a few dependencies (zlib, libevent and openssl) into a single Rust library that can be imported like any other Rust crate into existing projects.
This provides a way to use Tor without having to ship/download extra binaries - on platforms that allows running them - while for some other platforms like
iOS and newer Android versions this is the only way to run Tor since the OS straight up doesn't allow exec'ing binaries.

Keep in mind that the interface exposed here is very very "low-level" (literally just what's in `tor_api.h`). Another crate wrapping all of these parts with a nice Rust interface will
be released separately.

By default this library only compiles with the minimal set of libraries needed to run Tor, namely OpenSSL, Libevent and Zlib. The `with-lzma` and `with-zstd` features can be used to enable the
respective compression algorithms, and the `vendored-lzma` and `vendored-zstd` features can be used to compile and like those libraries statically instead of using the one provided by your system.

## Supported platforms

The currently supported platforms are:

* Linux (tested on Fedora 30 and Ubuntu Xenial)
* Android through the NDK
* MacOS
* iOS

### Build using nix on a Mac
- Install [nix](https://determinate.systems/nix-installer/)
- Install [direnv](https://direnv.net/)
- Run `direnv allow` to allow direnv to load the nix environment
- If you want to install xcode and xcode command line tools, simply run `setup-ios-env`.


```
# Build Android
chmod + ./build-android.sh && ./build-android.sh

# Build iOS
chmod + ./build-ios.sh && ./build-ios.sh 

# Build MacOS
chmod + ./build-macos.sh && ./build-macos.sh
```
