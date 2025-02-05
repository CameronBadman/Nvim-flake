# plugins/default.nix
{ pkgs }: {
  # Import modular plugin configurations
  neo-tree = (import ./neo-tree.nix { inherit pkgs; });
  lualine = (import ./lualine.nix { inherit pkgs; });
  telescope = (import ./telescope.nix { inherit pkgs; });
  lsp = (import ./lsp.nix { inherit pkgs; });

  # Syntax highlighting and parsing
  treesitter = {
    enable = true;
    
    # Languages to install parsers for
    ensureInstalled = [
      # Programming languages
      "lua"
      "python" 
      "typescript"
      "javascript"
      "go"
      "rust"
      "c"
      "cpp"
      "java"
      
      # Data formats
      "json"
      "yaml"
      "toml"
      
      # Web development
      "html"
      "css"
      
      # Documentation
      "markdown"
      "markdown_inline"
      
      # Vim specific
      "vim"
      "vimdoc"
      "query"
    ];
  };
  
  # Enable snippet support
  luasnip.enable = true;
  nvim-tree.view = {
  number = true;
  relativenumber = true
  ;};


  # Diagnostics view
  trouble = {
    enable = true;
    position = "bottom";
  };
}
