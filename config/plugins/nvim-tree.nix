{
  plugins.nvim-tree = {
    enable = true;

    settings = {
      disable_netrw = true;
      hijack_netrw = true;

      update_focused_file = {
        enable = true;
        update_root = false;
      };

      view = {
        width = 30;
        side = "left";
      };

      renderer = {
        group_empty = true;
        full_name = false;
        highlight_git = true;
        highlight_opened_files = "name";
        root_folder_label = ":~:s?$?/..?";
        indent_width = 2;
        indent_markers = {
          enable = true;
        };
        icons = {
          glyphs = {
            default = "";
            symlink = "";
            folder = {
              default = "";
              open = "";
              empty = "";
              empty_open = "";
              symlink = "";
              symlink_open = "";
            };
            git = {
              unstaged = "✗";
              staged = "✓";
              unmerged = "";
              renamed = "➜";
              untracked = "★";
              deleted = "";
              ignored = "◌";
            };
          };
        };
      };

      filters = {
        dotfiles = false;
        custom = [ ".git" "node_modules" ".cache" ];
      };

      git = {
        enable = true;
        ignore = false;
      };

      actions = {
        open_file = {
          quit_on_open = false;
          resize_window = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":NvimTreeFocus<CR>";
      options = {
        desc = "Focus nvim-tree";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>t";
      action = ":NvimTreeToggle<CR>";
      options = {
        desc = "Toggle nvim-tree";
        silent = true;
      };
    }
  ];
}
