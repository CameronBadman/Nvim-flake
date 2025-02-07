{
  description = "Basic Neovim Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        neovimConfig = pkgs.stdenv.mkDerivation {
          name = "neovim-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r * $out/
          '';
        };
        
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
                telescope-nvim
                plenary-nvim
                neo-tree-nvim
                nui-nvim
                nvim-web-devicons
                kanagawa-nvim
                lualine-nvim
                (nvim-treesitter.withPlugins (plugins: with plugins; [
                  lua
                  nix
                  python
                  javascript
                  typescript
                  rust
                  
                  # Add any other languages you want
                ]))
              ];
            };
          };
        };
      in {
        packages.default = nvim-config;
        
        devShells.default = pkgs.mkShell {
          packages = [ nvim-config ];
        };
      }
    );
}
