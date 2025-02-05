# plugins/default.nix
{ pkgs }: {
  lualine = (import ./lualine.nix { inherit pkgs; }).plugins.lualine;
  neo-tree = (import ./neo-tree.nix { inherit pkgs; }).plugins.neo-tree;
  telescope = (import ./telescope.nix { inherit pkgs; }).plugins.telescope;
  lsp = (import ./lsp.nix { inherit pkgs; }).plugins.lsp;
  
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
