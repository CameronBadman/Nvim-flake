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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.writeTextFile {
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

      homeConfigurations.nvim = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
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
}
