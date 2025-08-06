{
  plugins.fugitive.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>gs";
      action = ":Git<CR>";
      options = {
        desc = "Git status";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = ":Git blame<CR>";
      options = {
        desc = "Git blame";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = ":Gdiffsplit<CR>";
      options = {
        desc = "Git diff split";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = ":Git log<CR>";
      options = {
        desc = "Git log";
        silent = true;
      };
    }
  ];
}
