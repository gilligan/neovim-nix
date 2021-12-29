{ pkgs ? import ./nix
, sources ? import ./nix/sources.nix
}:
let
  pre-commit = (import sources."pre-commit-hooks.nix").run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
    };
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [ niv nixpkgs-fmt ];
  inherit (pre-commit) shellHook;
}
