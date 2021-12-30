{ system ? builtins.currentSystem
, pins ? import ./npins
, pkgs ? import pins.nixpkgs { inherit system; }
}:

let
  inherit (pkgs) lib vimUtils python39;
  inherit (vimUtils) buildVimPlugin buildVimPluginFrom2Nix;


  coc-settings = pkgs.writeTextDir "coc-settings.json" (builtins.readFile ./coc-settings.json);

  solarized8 = buildVimPlugin {
    name = "vim-solarized8-04-24-21";
    src = pins.vim-solarized8;
  };

  vim-textobj-line = buildVimPlugin {
    name = "textobj-line";
    src = pins.vim-textobj-line;
  };

  vim-textobj-entire = buildVimPlugin {
    name = "textobj-entire";
    src = pins.vim-textobj-entire;
  };

  vim-operator-flashy = buildVimPlugin {
    name = "vim-operator-flashy";
    src = pins.vim-operator-flashy;
  };

  vim-projectlocal = buildVimPlugin {
    name = "vim-projectlocal";
    src = pins.vim-projectlocal;
  };

  plugin-settings = buildVimPlugin {
    name = "plugin-settings";
    src = "${./config}";
    buildInputs = with pkgs; [ git ];
  };

  coc-nvim = buildVimPlugin {
    src = pins."coc.nvim";
    version = "git";
    pname = "coc-nvim";
  };

  neovim = pkgs.neovim.override {
    withNodeJs = true;
    configure = {
      customRC = ''
        ${builtins.readFile ./init.vim}
        let g:coc_config_home = '${coc-settings}'
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
          vim-sneak
          targets-vim
          vim-operator-user
          vim-operator-flashy

          #
          # scm
          #
          vim-mergetool

          #
          # theme & looks
          #
          vim-airline
          vim-airline-themes
          solarized8
          haskell-vim

          #
          # terminal / process integration
          #
          vimproc
          vim-tmux-navigator

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
          # lsp: coc
          #
          coc-nvim
          (coc-rust-analyzer.overrideAttrs (old: { patches = [ ./patches/coc-rust-analyzer-path.patch ]; }))
          coc-json
          coc-fzf
          coc-yaml
          coc-snippets
          coc-vimlsp

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
