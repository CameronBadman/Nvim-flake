{ pkgs, ... }:
{
  plugins.lsp.servers.texlab = {
    enable = true;
  };
  
  plugins.vimtex = {
    enable = true;
    settings = {
      view_method = "zathura";
      compiler_method = "latexmk";
    };
  };
  
  plugins.conform-nvim.settings.formatters_by_ft.tex = [ "latexindent" ];
  
  extraPackages = with pkgs; [
    texlive.combined.scheme-full
    texlab
    latexmk
    zathura
  ];
  
  plugins.treesitter.settings.ensure_installed = [ "latex" ];
  
  # LaTeX-specific keybinds
  keymaps = [
    {
      mode = "n";
      key = "<leader>ll";
      action = "<cmd>VimtexCompile<cr>";
      options = {
        desc = "Toggle LaTeX compilation";
        buffer = true;  # Only active in LaTeX files
      };
    }
    {
      mode = "n";
      key = "<leader>lv";
      action = "<cmd>VimtexView<cr>";
      options = {
        desc = "View PDF";
        buffer = true;
      };
    }
  ];
}
