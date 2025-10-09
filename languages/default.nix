{ pkgs, ... }:
let
  rustModule = import ./rust.nix { inherit pkgs; };
  latexModule = import ./latex.nix { inherit pkgs; };
  typescriptModule = import ./typescript.nix { inherit pkgs; };
  pythonModule = import ./python.nix { inherit pkgs; };
  goModule = import ./go.nix { inherit pkgs; };
  javaModule = import ./java.nix { inherit pkgs; };
  csharpModule = import ./csharp.nix { inherit pkgs; };
  clangModule = import ./clang.nix { inherit pkgs; };
  nixModule = import ./nix.nix { inherit pkgs; };
  luaModule = import ./lua.nix { inherit pkgs; };
  jsonModule = import ./json.nix { inherit pkgs; };
  yamlModule = import ./yaml.nix { inherit pkgs; };
  dockerModule = import ./docker.nix { inherit pkgs; };
  terraformModule = import ./terraform.nix { inherit pkgs; };
  gleamModule = import ./gleam.nix { inherit pkgs; };
  ocamlModule = import ./ocaml.nix { inherit pkgs; };
  haskellModule = import ./haskell.nix { inherit pkgs; };
  elixirModule = import ./elixir.nix { inherit pkgs; };
  kotlinModule = import ./kotlin.nix { inherit pkgs; };
in
{
  imports = [
    ./rust.nix
    ./typescript.nix
    ./python.nix
    ./go.nix
    ./nix.nix
    ./latex.nix
    ./clang.nix
    ./java.nix
    ./csharp.nix
    ./lua.nix
    ./json.nix
    ./yaml.nix
    ./docker.nix
    ./terraform.nix
    ./gleam.nix
    ./ocaml.nix
    ./haskell.nix
    ./elixir.nix
    ./kotlin.nix
  ];
  
  extraPackages = (rustModule.extraPackages or [])
  ++ (typescriptModule.extraPackages or [])
  ++ (pythonModule.extraPackages or [])
  ++ (goModule.extraPackages or [])
  ++ (javaModule.extraPackages or [])
  ++ (csharpModule.extraPackages or [])
  ++ (clangModule.extraPackages or [])
  ++ (nixModule.extraPackages or [])
  ++ (luaModule.extraPackages or [])
  ++ (jsonModule.extraPackages or [])
  ++ (yamlModule.extraPackages or [])
  ++ (dockerModule.extraPackages or [])
  ++ (terraformModule.extraPackages or [])
  ++ (kotlinModule.extraPackages or [])
  ++ (gleamModule.extraPackages or [])
  ++ (ocamlModule.extraPackages or [])
  ++ (haskellModule.extraPackages or [])
  ++ (latexModule.extraPackages or [])
  ++ (elixirModule.extraPackages or []);

}
