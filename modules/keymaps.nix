# modules/keymaps.nix
{ pkgs }: {
  globals.mapleader = " ";  # Set leader key
  
  keymaps = [
    # Neo-tree
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree focus<CR>";
      options = {
        silent = true;
        desc = "Open and focus Neotree";
      };
    }

    # Save file
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
      options = {
        silent = true;
        desc = "Save file";
      };
    }
    
    # Quit
    {
      mode = "n";
      key = "<leader>q";
      action = ":q<CR>";
      options = {
        silent = true;
        desc = "Quit";
      };
    }
  ];
}
