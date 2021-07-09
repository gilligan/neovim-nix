{ pkgs ? import ./nix
, sources ? import ./nix/sources.nix
}:

let
  inherit (pkgs) lib vimUtils;
  inherit (vimUtils) buildVimPlugin buildVimPluginFrom2Nix;

  solarized8 = buildVimPlugin {
    name = "vim-solarized8-04-24-21";
    src = pkgs.fetchgit {
      url = "https://github.com/lifepillar/vim-solarized8.git";
      rev = "28b81a4263054f9584a98f94cca3e42815d44725";
      sha256 = "sha256:0vq0fxsdy0mk2zpbd1drrrxnbd44r39gqzp0s71vh9q4bnww7jds";
    };
  };

  vim-textobj-line = buildVimPlugin {
    name = "textobj-line";
    src = pkgs.fetchgit {
      url = "https://github.com/kana/vim-textobj-line.git";
      rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
      sha256 = "sha256:0mppgcmb83wpvn33vadk0wq6w6pg9cq37818d1alk6ka0fdj7ack";
    };
  };

  vim-textobj-entire = buildVimPlugin {
    name = "textobj-entire";
    src = pkgs.fetchgit {
      url = "https://github.com/kana/vim-textobj-entire.git";
      rev = "64a856c9dff3425ed8a863b9ec0a21dbaee6fb3a";
      sha256 = "sha256:0kv0s85wbcxn9hrvml4hdzbpf49b1wwr3nk6gsz3p5rvfs6fbvmm";
    };
  };

  vim-operator-flashy = buildVimPlugin {
    name = "vim-operator-flashy";
    src = pkgs.fetchgit {
      url = "https://github.com/haya14busa/vim-operator-flashy.git";
      rev = "b24673a9b0d5d60b26d202deb13d4ebf90d7a2ae";
      sha256 = "sha256:102va7cl1fyqm4yh0d6i773mgbfwlf9lpzc4sb3h2jgn7b1knr88";
    };
  };

  vim-projectlocal = buildVimPlugin {
    name = "vim-projectlocal";
    src = pkgs.fetchgit {
      url = "https://github.com/krisajenkins/vim-projectlocal.git";
      rev = "d1c3d84697727202917793b17f3e2a68fc9f09f5";
      sha256 = "sha256:03g204zk0p33q72bkampk76m7r0zw25hxasfaisl4kdrrwpbkr9z";
    };
  };

  plugin-settings = buildVimPlugin {
    name = "plugin-settings";
    src = ./config;
    buildInputs = with pkgs; [ git ];
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
    extraPython3Packages = (_: [ ]);
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
          completion-nvim
          completion-buffers
          completion-treesitter

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
