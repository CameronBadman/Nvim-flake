{ ... }:
{
  imports = [
    # Core languages - commonly used
    ./rust.nix
    ./typescript.nix
    ./python.nix
    ./go.nix
    ./nix.nix
    
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
    
  ];
}
