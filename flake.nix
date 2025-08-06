{
  description = "Minimal NixVim configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = { nixpkgs, nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = [
              ./config
              ./languages.nix
            ];
          };
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixvim.packages.${system}.default
          ];
        };
      };
      
      flake = {
        nixvimModule = ./config;
        
        lib = {
          getLanguagePackages = pkgs: 
            let 
              languagesModule = import ./languages.nix { inherit pkgs; };
            in 
              languagesModule.extraPackages;
        };
      };
    };
}
