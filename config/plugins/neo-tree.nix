{
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window = {
        width = 30;
        auto_expand_width = true;
      };
      buffers = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
        };
      };
      filesystem = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
        };
        filtered_items = {
          hide_dotfiles = false;
        };
        use_libuv_file_watcher = true;
        group_empty_dirs = true;
      };
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
