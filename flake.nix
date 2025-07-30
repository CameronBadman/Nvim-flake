{
  description = "Neovim Flake with Markdown, Terraform, Elixir, Gleam";
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
        
        # Python packages
        pythonDevPackages = with pkgs; [
          python3Packages.python-lsp-server
          python3Packages.python-lsp-black
          python3Packages.python-lsp-ruff
          python3Packages.pylint
          black
          ruff
        ];

        # JavaScript/TypeScript packages  
        jsDevPackages = with pkgs; [
          nodePackages_latest.typescript-language-server
          nodePackages.typescript-language-server
        ];

        # Go packages
        goDevPackages = with pkgs; [
          go
          gopls
          golangci-lint
          delve
          gore
          gotools
          gotests
          gofumpt
        ];


                csharpDevPackages = with pkgs; [
          # Core .NET
          dotnet-sdk         # Latest .NET SDK
          dotnet-runtime     # .NET runtime
          
          # Language server
          omnisharp-roslyn   # C# LSP server
          
          # Debugger
          netcoredbg        # .NET debugger
        ];

# Minimal safe Java packages (guaranteed to exist in nixpkgs)
        javaDevPackages = with pkgs; [
          # JDK (includes jdb debugger, javac, java, etc.)
          jdk21             # Java 21 LTS with all tools
          
          # Language server
          jdt-language-server   # Eclipse JDT Language Server
          
          # Build tools
          maven             # Apache Maven
          gradle            # Gradle build system
          
          # Code analysis
          checkstyle        # Java code style checker
        ];

        # Lua packages
        luaDevPackages = with pkgs; [
          sumneko-lua-language-server
          stylua
        ];

        # Nix packages
        nixDevPackages = with pkgs; [
          nil
          nixpkgs-fmt
        ];

        # Haskell packages
        haskellDevPackages = with pkgs; [
          haskell-language-server
          hlint
          ormolu
          ghc
          cabal-install
          stack
          pandoc
          haskellPackages.hakyll
          haskellPackages.parsec
        ];

        # C++ packages
        cppDevPackages = with pkgs; [
          clang-tools
        ];

        # Terraform-specific packages
        terraformDevPackages = with pkgs; [
          terraform-ls
          terraform   
          terraform-docs
          tflint
          tfsec
        ];

        # Elixir/Erlang packages
        elixirDevPackages = with pkgs; [
          # Core Elixir/Erlang runtime
          erlang
          elixir
          elixir_ls           # Elixir Language Server
          
          # Phoenix framework
          nodejs              # Needed for Phoenix assets
          
          # Additional Elixir tools
          rebar3              # Erlang build tool
          hex                 # Elixir package manager (usually comes with Elixir)
          
          # Database support (commonly used with Phoenix)
          postgresql          # PostgreSQL client tools
          
          # Optional: Debugging and profiling tools
          # observer_cli        # CLI version of Observer (if available)
        ];

        # Gleam packages
        gleamDevPackages = with pkgs; [
          # Core Gleam toolchain
          gleam               # Gleam compiler and build tool (includes LSP)
          erlang              # Gleam runs on the BEAM VM (already in elixirPackages but good to be explicit)
          
          # JavaScript runtime for Gleam's JS target
          nodejs              # For running Gleam code compiled to JS
          
          # Additional tools for Gleam development
          rebar3              # Erlang build tool (already in elixirPackages)
          
          # Note: Gleam LSP is built into the `gleam` command as `gleam lsp`
          # Formatting is also built-in as `gleam format`
        ];

        # Merge our markdown dependencies with other packages
        extraPackages = pythonDevPackages ++ javaDevPackages ++ csharpDevPackages  ++ jsDevPackages ++ goDevPackages ++ luaDevPackages ++ nixDevPackages ++ haskellDevPackages ++ cppDevPackages ++ markdownModule.dependencies ++ terraformDevPackages ++ elixirDevPackages ++ gleamDevPackages;

        # All development packages combined
        allDevPackages = basePackages ++ extraPackages;
        
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
                
                # Elixir specific plugins
                vim-elixir                  # Elixir syntax highlighting and indentation
                # Note: mix format integration is handled by LSP formatting
                
                # Gleam specific plugins
                # Note: There might not be dedicated Gleam plugins yet, but Treesitter handles syntax
                
                # Spelling and grammar
                vim-grammarous              # Grammar checking integrated

                # Treesitter
                (nvim-treesitter.withPlugins (plugins: with plugins; [
                  lua
                  nix
                  python
                  javascript
                  typescript
                  bash
                  markdown
                  markdown_inline
                  json
                  yaml
                  toml                     # Important for Cargo.toml
                  git_rebase
                  gitcommit
                  gitignore
                  diff
                  go
                  gomod
                  gowork
                  haskell
                  hcl                      # For Terraform/HCL support
                  elixir                   # Elixir syntax highlighting
                  erlang                   # Erlang syntax highlighting (also used by Gleam)
                  eex                      # Embedded Elixir templates
                  heex                     # Phoenix HTML templates
                  surface                  # Surface UI components (if using Surface)
                  gleam                    # Gleam syntax highlighting
                ]))
              ];
            };
          };
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath allDevPackages}"'';
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
          
          # Export individual package groups
          pythonPackages = pkgs.buildEnv {
            name = "nvim-python-packages";
            paths = pythonDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };

          jsPackages = pkgs.buildEnv {
            name = "nvim-js-packages";
            paths = jsDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };

          goPackages = pkgs.buildEnv {
            name = "nvim-go-packages";
            paths = goDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };

          haskellPackages = pkgs.buildEnv {
            name = "nvim-haskell-packages";
            paths = haskellDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };

          terraformPackages = pkgs.buildEnv {
            name = "nvim-terraform-packages";
            paths = terraformDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };
          
          elixirPackages = pkgs.buildEnv {
            name = "nvim-elixir-packages";
            paths = elixirDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };
          
          gleamPackages = pkgs.buildEnv {
            name = "nvim-gleam-packages";
            paths = gleamDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };

          cppPackages = pkgs.buildEnv {
            name = "nvim-cpp-packages";
            paths = with pkgs; [
              # C++ toolchain
              clang                # Clang C++ compiler
              clang-tools          # clang-format, clang-tidy, clangd LSP
              llvm                 # LLVM toolchain
              gdb                  # Debugger
              valgrind             # Memory debugging
              
              # C++ build systems
              cmake                # CMake build system
              ninja                # Ninja build system
              meson                # Meson build system
              
              # C++ libraries commonly used
              boost                # Boost libraries
              fmt                  # Modern formatting library
              catch2               # Testing framework
              
              # Additional C++ tools
              ccache               # Compiler cache
              cppcheck             # Static analysis
              include-what-you-use # Header optimization
            ];
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };
          
          # Export the development packages as a buildEnv
          devPackages = pkgs.buildEnv {
            name = "nvim-dev-packages";
            paths = allDevPackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };
          
          # Export base packages
          basePackages = pkgs.buildEnv {
            name = "nvim-base-packages";
            paths = basePackages;
            pathsToLink = [ "/bin" "/share" "/lib" ];
          };
        };
        
        devShells.default = pkgs.mkShell {
          packages = [ nvim-wrapped ] ++ allDevPackages;
          
          # Set up development environment variables
          shellHook = ''
            echo "Multi-language development environment loaded!"
            
            # Ensure mix is available for Elixir
            export MIX_ENV=dev
            export ERL_AFLAGS="-kernel shell_history enabled"
            
            # Set environment variables for native compilation
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.sqlite.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
            export OPENSSL_DIR="${pkgs.openssl.dev}"
            export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
            export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
          '';
        };
      }
    );
}
