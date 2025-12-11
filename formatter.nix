{
  pkgs,
  inputs,
  ...
}: let
  config = {
    projectRootFile = "flake.nix";

    programs = {
      alejandra = {
        # https://github.com/kamadorueda/alejandra
        enable = true;
        package = pkgs.alejandra;
      };
      rustfmt = {
        # https://rust-lang.github.io/rustfmt/
        enable = true;
        package = pkgs.rustfmt;
        # If you ever want to configure the rust fmt edition consider doing it in a rustfmt.toml file instead of here.
      };
      dprint = {
        # https://dprint.dev/
        enable = true;
        package = pkgs.dprint;
        includes = ["**/*.{toml,json,jsonc,md,yml}"];
        settings = {
          json = {
            indentWidth = 4;
          };
          plugins = pkgs.dprint-plugins.getPluginList (
            plugins:
              with plugins; [
                dprint-plugin-toml
                dprint-plugin-json
                dprint-plugin-markdown
                g-plane-pretty_yaml
              ]
          );
        };
      };
    };
  };
in
  inputs.treefmt-nix.lib.mkWrapper pkgs config
