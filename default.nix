{ system ? builtins.currentSystem
, pins ? import ./npins
, pkgs ? import pins.nixpkgs { inherit system; }
}:

let
  inherit (pkgs) lib vimUtils python39;
  inherit (vimUtils) buildVimPlugin buildVimPluginFrom2Nix;


  coc-settings = pkgs.writeTextDir "coc-settings.json" (builtins.readFile ./coc-settings.json);

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
          solarized-nvim

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
          fzf-hoogle-vim
          nerdtree
          nerdtree-git-plugin
          oil-nvim

          #
          # misc
          #
          vim-rooter
          vim-nix
          direnv-vim
          neoformat
          vim-projectlocal
          vim-devicons
          nvim-comment

          #
          # lsp: coc
          #
          coc-nvim
          coc-rust-analyzer
          coc-json
          coc-fzf
          coc-yaml
          coc-snippets
          coc-vimlsp
          coc-java

          #
          # treesitter
          #
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects

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
neovim
