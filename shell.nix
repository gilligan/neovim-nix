{ pkgs ? import ./nix }:
pkgs.mkShell {
  buildInputs = with pkgs; [ niv nixpkgs-fmt ];
}
