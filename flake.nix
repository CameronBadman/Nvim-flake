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
      
      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let
        # Configure nixpkgs to allow unfree packages
        pkgs-unfree = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in {
        packages = {
          default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = pkgs-unfree;
            module = [
              ./config
              ./languages.nix
            ];
          };
        };
        
        devShells.default = pkgs-unfree.mkShell {
          buildInputs = with pkgs-unfree; [
            nixvim.packages.${system}.default
          ];
        };
      };
      
      flake = {
        nixvimModule = ./config;
        
        # Export the extraPackages directly
        extraPackages = pkgs: (import ./languages.nix { inherit pkgs; }).extraPackages;
      };
    };
}
