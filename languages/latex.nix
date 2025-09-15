{ pkgs, ... }:
{
  plugins.lsp.servers.texlab = {
    enable = true;
  };
  
  plugins.vimtex = {
    enable = true;
    settings = {
      view_method = "zathura";
      view_automatic = 1;  # Auto-open PDF viewer
      compiler_method = "latexmk";
      compiler_latexmk = {
        continuous = 1;  # Continuous compilation
      };
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.tex = [ "latexindent" ];
  
  extraPackages = with pkgs; [
    texlive.combined.scheme-full
    texlab
    zathura
    tree-sitter
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "latex" ];
  
  # Single keybind to start everything
  keymaps = [
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>VimtexCompile<cr>";
      options = {
        desc = "Start LaTeX compilation and view";
      };
    }
  ];
}
