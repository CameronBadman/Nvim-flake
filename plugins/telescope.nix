# plugins/telescope.nix
{ pkgs }: {
  enable = true;
  defaults = {
    file_ignore_patterns = [
      "^.git/"
      "^node_modules/"
      "^__pycache__/"
    ];
  };
  
  keymaps = {
    "<leader>ff" = "find_files";
    "<leader>fg" = "live_grep";
    "<leader>fb" = "buffers";
    "<leader>fh" = "help_tags";
  };
}
