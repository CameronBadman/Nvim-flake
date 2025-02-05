{ pkgs }: {
  globals.mapleader = " ";  # Set leader key
  
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree focus<CR>";
      options = {
        silent = true;
        desc = "Open and focus Neotree";
      };
    }
  ];
}
