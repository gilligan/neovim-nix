{ pkgs ? import ./nix
, sources ? import ./nix/sources.nix
}:

let
  inherit (pkgs) lib vimUtils python39;
  inherit (vimUtils) buildVimPlugin buildVimPluginFrom2Nix;

  solarized8 = buildVimPlugin {
    name = "vim-solarized8-04-24-21";
    src = sources.vim-solarized8;
  };

  vim-textobj-line = buildVimPlugin {
    name = "textobj-line";
    src = sources.vim-textobj-line;
  };

  vim-textobj-entire = buildVimPlugin {
    name = "textobj-entire";
    src = sources.vim-textobj-entire;
  };

  vim-operator-flashy = buildVimPlugin {
    name = "vim-operator-flashy";
    src = sources.vim-operator-flashy;
  };

  vim-projectlocal = buildVimPlugin {
    name = "vim-projectlocal";
    src = sources.vim-projectlocal;
  };

  plugin-settings = buildVimPlugin {
    name = "plugin-settings";
    src = ./config;
    buildInputs = with pkgs; [ git ];
  };

  std2 = python39.pkgs.buildPythonPackage {
    src = sources.std2;
    version = "git";
    pname = "coq-nvim-std2";
    doCheck = false;
  };

  pynvim_pp = python39.pkgs.buildPythonPackage {
    src = sources.pynvim_pp;
    propagatedBuildInputs = [ python39.pkgs.pynvim ];
    pname = "coq-nvim-pynvim-pp";
    version = "git";
    doCheck = false;
  };

  coq-nvim =
    let
      coqPythonEnv = python39.withPackages (ps: with ps; [ std2 pynvim_pp pynvim pyyaml ]);
    in
    buildVimPlugin {
      name = "coq_nvim";
      src = sources.coq_nvim;
      buildInputs = with pkgs; [ coqPythonEnv sqlite ];
      patches = [ ./patches/ignore_venv.patch ];
      postInstall = ''
        cp ${./coq-config.yml} $out/config/defaults.yml
      '';
    };

  tree-sitter-grammars = buildVimPluginFrom2Nix rec {
    pname = "tree-sitter-grammars";
    version = pkgs.tree-sitter.version;
    banned = (map (v: "tree-sitter-${v}") [
      "agda"
      "fluent"
      "svelte"
      "swift"
      "verilog"
    ]);
    src = pkgs.runCommandNoCC "tree-sitter-grammars" { } ''
      mkdir -p $out/parser
      ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs
      (n: v: "ln -s ${v}/parser $out/parser/${
        builtins.replaceStrings ["-"] ["_"] (pkgs.lib.removePrefix "tree-sitter-" n)
        }.so")
        (lib.filterAttrs (n: _: !builtins.elem n banned) pkgs.tree-sitter.builtGrammars)
        ))}
    '';
    dependencies = [ ];
  };

  neovim = pkgs.neovim.override {
    withNodeJs = true;
    extraPython3Packages = (ps: with ps; [ std2 pynvim_pp pynvim pyyaml ]);
    configure = {
      customRC = ''
        ${builtins.readFile ./init.vim}
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          #
          # tpope essentials
          #
          vim-surround
          vim-unimpaired
          vim-endwise
          vim-eunuch
          vim-repeat
          vim-markdown
          vim-vinegar
          vim-rhubarb
          vim-fugitive

          #
          # textobj plugins
          #
          vim-textobj-user
          vim-textobj-comment
          vim-textobj-line
          vim-textobj-entire

          #
          # movement
          #
          #mark.vim
          vim-sneak
          targets-vim
          vim-operator-user
          vim-operator-flashy

          #
          # scm
          #
          #vim-gitgutter
          vim-mergetool

          #
          # theme & looks
          #
          vim-airline
          vim-airline-themes
          solarized8

          #
          # terminal / process integration
          #
          vimproc
          vim-tmux-navigator
          #neoterm

          # navigation / buffers
          vim-togglelist
          nerdcommenter
          zoomwintab-vim
          fzf-vim
          nerdtree
          nerdtree-git-plugin

          #
          # misc
          #
          vim-rooter
          vim-nix
          direnv-vim
          neoformat
          vim-projectlocal
          vim-devicons

          #
          # lsp stuff / neovim 0.5
          #
          nvim-lspconfig
          nvim-treesitter
          tree-sitter-grammars
          lspsaga-nvim
          lsp-colors-nvim
          trouble-nvim

          #
          # completion
          #
          coq-nvim

          #
          # local plugin settings
          #
          plugin-settings
        ];
        opt = [ ];
      };
    };
  };
in
{
  inherit neovim;
}
