{
  description = "Simple flake with a devshell";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    # todo this shoulddnt be needed 
    systems.url = "github:nix-systems/default";
  };

  # TODO Remove the techdebt from working outside the blueprint framework thx

  # Load the blueprint
  outputs = inputs: let
    # Small tool to iterate over each systems
    eachSystem = f: inputs.nixpkgs.lib.genAttrs (import inputs.systems) (system: f inputs.nixpkgs.legacyPackages.${system});

    # Eval the treefmt modules from ./treefmt.nix
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in
    inputs.blueprint {inherit inputs;}
    // {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    };
}
