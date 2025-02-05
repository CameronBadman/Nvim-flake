# modules/packages.nix
{ pkgs, inputs }: {
  # LSP and Dev tools
  extraPackages = with pkgs; [
    # Language Servers
    gopls
    rust-analyzer
    nodePackages.typescript-language-server
    lua-language-server
    nil  # Nix language server
    sonarlint-ls  # SonarLint language server
    pylint  # Python linter
    shellcheck  # Shell script linter
    eslint  # JavaScript/TypeScript linter
    
    # Development Tools
    python311Packages.pip
    luarocks
    black  # Python formatter
    stylua  # Lua formatter
    nodePackages.prettier  # JavaScript/TypeScript formatter
    shfmt  # Shell script formatter
    nixfmt  # Nix formatter
    codespell  # Spell checker
    
    # Utilities
    ripgrep  # Fast grep
    fd  # Fast find
    wl-clipboard  # Wayland clipboard support
    kubectl  # Kubernetes CLI
    
    # C/C++ Tools
    clang-tools  # Clang tooling
    cpplint  # C++ linter
  ];
  
  # Vim Plugins that need special handling
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "kubectl-nvim";
      src = inputs.kubectl-nvim;
    })
  ];
}
