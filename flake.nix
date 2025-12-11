{
  description = "Simple flake with a devshell";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Load the blueprint
  outputs = inputs @ {rust-overlay, ...}:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
      ### the systems field controls which system architectures this flake will try to support
      systems = [
        "x86_64-linux"
        # TODO: Consider adding "aarch64-darwin" for Arm-chip MacOS support
      ];
      nixpkgs.overlays = [
        rust-overlay.overlays.default
      ];
    };
}
