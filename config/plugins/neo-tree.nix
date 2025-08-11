{
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = true;
    window = {
      width = 50;
      autoExpandWidth = true;
    };
    buffers = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
    };
    filesystem = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
      useLibuvFileWatcher = true;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree focus<CR>";
      options = {
        desc = "Focus Neo-tree";
        silent = true;
      };
    }
  ];
}
