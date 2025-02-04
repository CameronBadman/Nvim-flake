{ pkgs }: {
  neo-tree = import ./neo-tree.nix { inherit pkgs; };
  lualine = import ./lualine.nix { inherit pkgs; };
  telescope = import ./telescope.nix { inherit pkgs; };
  lsp = import ./lsp.nix { inherit pkgs; };
  
  treesitter = {
    enable = true;
    ensureInstalled = [
      "lua" "python" "typescript" "javascript" "go" "rust"
      "c" "cpp" "java" "json" "yaml" "toml" "html" "css"
      "markdown" "markdown_inline" "vim" "vimdoc" "query"
    ];
  };
  
  luasnip.enable = true;
}
