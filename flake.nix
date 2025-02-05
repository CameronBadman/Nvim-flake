{
  description = "Minimal Neovim Flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager }:
    let
      # Support multiple systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in {
      packages = forAllSystems (system: {
        default = (pkgsFor system).writeTextFile {
          name = "neovim-config";
          destination = "/share/neovim-config";
          text = ''
            {
              programs.neovim = {
                enable = true;
                defaultEditor = true;
                viAlias = true;
                vimAlias = true;
                extraLuaConfig = '''
                  vim.opt.number = true
                  vim.opt.relativenumber = true
                  vim.opt.cursorline = true
                ''';
              }
            }
          '';
        };
      });

      homeConfigurations = {
        "nvim-x86_64-darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-darwin";
          modules = [{
            programs.neovim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              extraLuaConfig = ''
                vim.opt.number = true
                vim.opt.relativenumber = true
                vim.opt.cursorline = true
              '';
            };
          }];
        };

        "nvim-x86_64-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          modules = [{
            programs.neovim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              extraLuaConfig = ''
                vim.opt.number = true
                vim.opt.relativenumber = true
                vim.opt.cursorline = true
              '';
            };
          }];
        };
      };
    };
}
