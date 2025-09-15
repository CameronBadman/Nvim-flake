{ pkgs, ... }:
let
  # Helper function to safely extract extraPackages from a language module
  getPackagesFromModule = modulePath:
    let
      module = import modulePath { inherit pkgs; };
    in
      if builtins.hasAttr "extraPackages" module 
      then module.extraPackages 
      else [];
  
  # Get packages from each language file
  rustPackages = getPackagesFromModule ./rust.nix;
  latexPackages = getPackagesFromModule ./latex.nix;
  typescriptPackages = getPackagesFromModule ./typescript.nix;
  pythonPackages = getPackagesFromModule ./python.nix;
  goPackages = getPackagesFromModule ./go.nix;
  javaPackages = getPackagesFromModule ./java.nix;
  csharpPackages = getPackagesFromModule ./csharp.nix;
  clangPackages = getPackagesFromModule ./clang.nix;
  nixPackages = getPackagesFromModule ./nix.nix;
  luaPackages = getPackagesFromModule ./lua.nix;
  jsonPackages = getPackagesFromModule ./json.nix;
  yamlPackages = getPackagesFromModule ./yaml.nix;
  dockerPackages = getPackagesFromModule ./docker.nix;
  terraformPackages = getPackagesFromModule ./terraform.nix;
  gleamPackages = getPackagesFromModule ./gleam.nix;
  ocamlPackages = getPackagesFromModule ./ocaml.nix;
  haskellPackages = getPackagesFromModule ./haskell.nix;
  elixirPackages = getPackagesFromModule ./elixir.nix;
  kotlinPackages = getPackagesFromModule ./kotlin.nix;
in
{
  # Nixvim module imports (for the editor configuration)
  imports = [
    # Core languages - commonly used
    ./rust.nix
    ./typescript.nix
    ./python.nix
    ./go.nix
    ./nix.nix
    ./latex.nix
    
    # Systems languages
    ./clang.nix
    ./java.nix
    ./csharp.nix
    
    # Scripting & config
    ./lua.nix
    ./json.nix
    ./yaml.nix
    
    # DevOps & Infrastructure  
    ./docker.nix
    ./terraform.nix
    
    # Functional languages
    ./gleam.nix
    ./ocaml.nix
    ./haskell.nix
    ./elixir.nix
    ./kotlin.nix
    
  ];
  # Export all packages for use in flake.nix
  extraPackages = 
    rustPackages ++
    typescriptPackages ++
    pythonPackages ++
    goPackages ++
    javaPackages ++
    csharpPackages ++
    clangPackages ++
    nixPackages ++
    luaPackages ++
    jsonPackages ++
    yamlPackages ++
    dockerPackages ++
    terraformPackages ++
    kotlinPackages ++ 
    gleamPackages ++
    ocamlPackages ++
    haskellPackages ++
    latexPackages ++ 
    elixirPackages;
}
