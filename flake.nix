{
  description = "Neovim Flake with Markdown and Terraform Support";
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

        # Import our markdown LSP module
        markdownModule = import ./modules/markdown-lsp.nix { inherit pkgs; lib = pkgs.lib; };

        neovimConfig = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r * $out/
            
            # Create the efm config directory
            mkdir -p $out/efm-config
            ln -s ${markdownModule.pkgs.efmConfig} $out/efm-config/markdown.yaml
          '';
        };
        
        # Base packages that neovim needs
        basePackages = with pkgs; [
          git
          ripgrep
          fd
        ];
        
        # Terraform-specific packages
        terraformPackages = with pkgs; [
          terraform-ls
          terraform
          terraform-docs
          tflint
          tfsec
        ];
        
        # Merge our markdown dependencies with other packages
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
  clang-tools
  
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
] ++ markdownModule.dependencies ++ terraformPackages; # Add Terraform-specific dependencies
        
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
                render-markdown-nvim

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
                lsp-zero-nvim
                neodev-nvim
                
                # Completion
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                cmp-path
                cmp-nvim-lua
                luasnip
                cmp_luasnip
                friendly-snippets

                # Markdown specific plugins
                markdown-preview-nvim        # Live preview
                vim-table-mode               # Table creation/formatting
                vim-markdown                 # Extended Markdown support
                headlines-nvim               # Better headings
                mkdnflow-nvim                # Markdown workflows
                zk-nvim                      # Simple note-taking
                
                # Terraform specific plugins
                vim-terraform               # Basic Terraform support
                
                # Spelling and grammar
                vim-grammarous              # Grammar checking integrated

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
                  markdown_inline
                  json
                  yaml
                  toml
                  git_rebase
                  gitcommit
                  gitignore
                  diff
                  go
                  gomod
                  gowork
                  haskell
                  hcl                      # For Terraform/HCL support
                ]))
              ];
            };
          };
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath (basePackages ++ extraPackages)}"'';
        };

        # Wrap nvim and add our custom efm-langserver to the path
        nvim-wrapped = pkgs.writeScriptBin "nvim" ''
          #!${pkgs.bash}/bin/bash
          if [ "$EUID" -ne 0 ]; then
            export PATH="${markdownModule.pkgs.efmLangServerWrapped}/bin:${pkgs.lib.makeBinPath basePackages}:$PATH"
            exec ${nvim-config}/bin/nvim "$@"
          else
            export PATH="${markdownModule.pkgs.efmLangServerWrapped}/bin:$PATH"
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
