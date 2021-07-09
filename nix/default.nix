let
  sources = import ./sources.nix;
  config = { };
in
import sources.nixpkgs { inherit config; }
