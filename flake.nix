{
  description = "My NixVim Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    kubectl-nvim = {
      url = "github:Ramilito/kubectl.nvim";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Import all modules through the default.nix
      commonConfig = (import ./modules { inherit pkgs inputs; }) // {
        plugins = import ./plugins { inherit pkgs; };
      };
    in {
      homeManagerModules.default = { config, lib, ... }: {
        programs.nixvim = commonConfig // {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
      };

      packages.${system}.default = nixvim.legacyPackages.${system}.makeNixvim (commonConfig // {
        viAlias = true;
        vimAlias = true;
      });

      homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.default
        ];
      };
    };
}
