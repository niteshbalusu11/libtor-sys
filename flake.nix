{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      android-nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
      androidSdkFor =
        system:
        android-nixpkgs.sdk.${system} (
          sdkPkgs: with sdkPkgs; [
            build-tools-35-0-0
            build-tools-34-0-0
            cmdline-tools-latest
            platform-tools
            platforms-android-34
            platforms-android-35
            ndk-27-1-12297006
            cmake-3-22-1
          ]
        );
      mkShellFor =
        system:
        let
          pkgs = pkgsFor system;
          androidSdk = androidSdkFor system;
          basePackages = with pkgs; [
            # Android SDK
            androidSdk
            jdk17

            # Build tools for libtor-sys
            autoconf
            automake
            cmake
            libtool
            pkg-config
            openssl
            zlib

            # Rust tools
            rustup
            cargo-ndk
          ];
          commonHook = ''
            export LC_ALL=en_US.UTF-8
            export LANG=en_US.UTF-8

            # Setup Rust Android targets
            rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android
          '';
        in
        pkgs.mkShellNoCC {
          buildInputs = basePackages;
          shellHook = commonHook;
        };
    in
    {
      devShells = forAllSystems (system: {
        default = mkShellFor system;
      });
    };
}
