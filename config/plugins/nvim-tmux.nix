# config/plugins/tmux.nix
{ config, lib, pkgs, ... }: {
  plugins.tmux-navigator = {
    enable = true;
    settings = {
      no_mappings = 0;
      save_on_switch = 1;
      disable_when_zoomed = 1;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>TmuxNavigateLeft<cr>";
      options = { silent = true; desc = "Navigate left"; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>TmuxNavigateDown<cr>";
      options = { silent = true; desc = "Navigate down"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>TmuxNavigateUp<cr>";
      options = { silent = true; desc = "Navigate up"; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>TmuxNavigateRight<cr>";
      options = { silent = true; desc = "Navigate right"; };
    }
    
    {
      mode = "n";
      key = "<C-c>|";
      action = "<cmd>vsplit<cr>";
      options = { silent = true; desc = "Vertical split"; };
    }
    {
      mode = "n";
      key = "<C-c>\\";
      action = "<cmd>vsplit<cr>";
      options = { silent = true; desc = "Vertical split alt"; };
    }
    {
      mode = "n";
      key = "<C-c>-";
      action = "<cmd>split<cr>";
      options = { silent = true; desc = "Horizontal split"; };
    }
    {
      mode = "n";
      key = "<C-c>_";
      action = "<cmd>split<cr>";
      options = { silent = true; desc = "Horizontal split alt"; };
    }
    
    {
      mode = "n";
      key = "<C-c>h";
      action = "<C-w>h";
      options = { silent = true; desc = "Move to left window"; };
    }
    {
      mode = "n";
      key = "<C-c>j";
      action = "<C-w>j";
      options = { silent = true; desc = "Move to bottom window"; };
    }
    {
      mode = "n";
      key = "<C-c>k";
      action = "<C-w>k";
      options = { silent = true; desc = "Move to top window"; };
    }
    {
      mode = "n";
      key = "<C-c>l";
      action = "<C-w>l";
      options = { silent = true; desc = "Move to right window"; };
    }
    
    {
      mode = "n";
      key = "<C-c>H";
      action = "<cmd>vertical resize -5<cr>";
      options = { silent = true; desc = "Decrease window width"; };
    }
    {
      mode = "n";
      key = "<C-c>J";
      action = "<cmd>resize -5<cr>";
      options = { silent = true; desc = "Decrease window height"; };
    }
    {
      mode = "n";
      key = "<C-c>K";
      action = "<cmd>resize +5<cr>";
      options = { silent = true; desc = "Increase window height"; };
    }
    {
      mode = "n";
      key = "<C-c>L";
      action = "<cmd>vertical resize +5<cr>";
      options = { silent = true; desc = "Increase window width"; };
    }
    
    {
      mode = "n";
      key = "<C-c>>";
      action = "<C-w>x";
      options = { silent = true; desc = "Swap window down"; };
    }
    {
      mode = "n";
      key = "<C-c><";
      action = "<C-w>X";
      options = { silent = true; desc = "Swap window up"; };
    }
    
    {
      mode = "n";
      key = "<C-c>z";
      action = "<cmd>lua vim.cmd('wincmd _') vim.cmd('wincmd |')<cr>";
      options = { silent = true; desc = "Zoom window"; };
    }
    
    {
      mode = "n";
      key = "<C-c>c";
      action = "<cmd>enew<cr>";
      options = { silent = true; desc = "New buffer"; };
    }
    
    {
      mode = "n";
      key = "<C-c>x";
      action = "<cmd>close<cr>";
      options = { silent = true; desc = "Close window"; };
    }
    {
      mode = "n";
      key = "<C-c>q";
      action = "<cmd>q<cr>";
      options = { silent = true; desc = "Quit window"; };
    }
    
    {
      mode = "n";
      key = "<C-c>=";
      action = "<C-w>=";
      options = { silent = true; desc = "Equal window sizes"; };
    }
  ];
}
