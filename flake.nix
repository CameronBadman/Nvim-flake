{
  description = "Basic Neovim Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
       let
  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };


        neovimConfig = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r * $out/
          '';
        };
        # Base packages that neovim needs
        basePackages = with pkgs; [
          git
          ripgrep
          fd
        ];
        
        extraPackages = with pkgs; [
  # LSP servers
  python3Packages.python-lsp-server
  python3Packages.python-lsp-black
  python3Packages.python-lsp-ruff
  python3Packages.pylint
  nodePackages_latest.typescript-language-server
  rust-analyzer
  sumneko-lua-language-server
  nil                     # Nix LSP
  gopls                   # Go LSP
  terraform-ls
  terraform
  haskell-language-server # Haskell LSP
  hlint                   # Haskell linting
  ormolu                  # Haskell formatting
  
  # Go tools
  go
  golangci-lint
  delve
  gore
  gotools
  gotests
  gofumpt                # Go formatting
  
  # Formatters and linters
  black
  ruff
  nixpkgs-fmt
  stylua
  rustfmt
  
  # Additional tools
  ripgrep
  fd
  git
  nodePackages.typescript-language-server
];
        
        nvim-config = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua << EOF
              package.path = '${neovimConfig}/?.lua;${neovimConfig}/?/init.lua;' .. package.path
              require('lua.init')
              EOF
            '';
            packages.myPlugins = with pkgs.vimPlugins; {
              start = [
                # Core plugins
                telescope-nvim
                plenary-nvim
                neo-tree-nvim
                nui-nvim
                nvim-web-devicons
                kanagawa-nvim
                lualine-nvim
                vim-visual-multi
                trouble-nvim

                # Git integration
                vim-fugitive
                gitsigns-nvim
                vim-rhubarb

                # Enhanced editing
                vim-surround
                vim-repeat
                comment-nvim
                nvim-autopairs
                indent-blankline-nvim
                which-key-nvim

                # LSP Support
                nvim-lspconfig
                mason-nvim
                mason-lspconfig-nvim
                lsp-zero-nvim      # Added
                neodev-nvim        # Added for Lua development
                
                # Completion
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                cmp-path
                cmp-nvim-lua       # Added
                luasnip
                cmp_luasnip
                friendly-snippets

                # Treesitter
                (nvim-treesitter.withPlugins (plugins: with plugins; [
                  lua
                  nix
                  python
                  javascript
                  typescript
                  rust
                  bash
                  markdown
                  json
                  yaml
                  toml
                  git_rebase
                  gitcommit
                  gitignore
                  diff
                  go          # Added Go
                  gomod      # Added Go modules
                  gowork    # Added Go workspace
                  haskell
                ]))
              ];
            };
          };
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath (basePackages ++ extraPackages)}"'';
        };

        nvim-wrapped = pkgs.writeScriptBin "nvim" ''
          #!${pkgs.bash}/bin/bash
          if [ "$EUID" -ne 0 ]; then
            export PATH="${pkgs.lib.makeBinPath basePackages}:$PATH"
            exec ${nvim-config}/bin/nvim "$@"
          else
            exec sudo -E ${nvim-config}/bin/nvim "$@"
          fi
        '';
      in {
        packages = {
          default = nvim-wrapped;
          nvim = nvim-wrapped;
          vim = nvim-wrapped;
        };
        
        devShells.default = pkgs.mkShell {
          packages = [ nvim-wrapped ] ++ basePackages;
        };
      }
    );
}
