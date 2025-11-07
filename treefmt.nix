{pkgs, ...}: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra = {
      enable = true;
      package = pkgs.alejandra;
    };
    rustfmt = {
      enable = true;
      package = pkgs.rustfmt;
      # If you ever want to configure the rust fmt edition consider doing it in a rustfmt.toml file instead of here.
    };
  };
}
