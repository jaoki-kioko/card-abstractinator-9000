{
  pname,
  pkgs,
  flake,
}: let
  formatter = pkgs.alejandra;
in
  formatter
