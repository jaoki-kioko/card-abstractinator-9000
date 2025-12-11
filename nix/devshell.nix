{
  pkgs,
  perSystem,
}:
perSystem.devshell.mkShell (
  let
    rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ../rust-toolchain.toml;

    dependenciesFromBevyDocs =
      # I based these off the flake in this example from the bevy docs. But the Bevy nix docs are a little outdated. And don't seem to be maintained often.
      # TODO: A good person would update the flake in the bevy docs to be more like this one.
      # https://github.com/bevyengine/bevy/blob/c7f607a509e2cd879ba65207ebf7e84ab4ff7543/docs/linux_dependencies.md#flakenix
      with pkgs; rec {
        linuxLibraries = [
          # I added this one manually. It includes `lib/pkgconfig/wayland-client.pc` which is required for bevy to generate a wayland compatible output.
          kdePackages.wayland.dev

          # Cross Platform 3D Graphics API
          vulkan-loader

          # Audio
          alsa-lib.dev

          xorg.libX11
          xorg.libXi
          xorg.libXcursor
          libxkbcommon
        ];
        packages =
          [
            # Rust dependencies
            rustToolchain
            pkg-config
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux (
            [
              # Audio (Linux only)
              alsa-lib

              # For debugging around vulkan
              vulkan-tools
              # Other dependencies
              libudev-zero
              xorg.libXrandr
            ]
            ++ linuxLibraries
          );
      };
  in {
    packages = dependenciesFromBevyDocs.packages;
    # Add environment variables
    env = [
      {
        name = "LD_LIBRARY_PATH";
        value = pkgs.lib.makeLibraryPath dependenciesFromBevyDocs.linuxLibraries;
      }
      {
        name = "PKG_CONFIG_PATH";
        prefix = "$DEVSHELL_DIR/lib/pkgconfig";
      }
      {
        name = "RUST_SRC_PATH";
        value = "${rustToolchain}/lib/rustlib/src/rust/library";
      }
    ];
  }
)
