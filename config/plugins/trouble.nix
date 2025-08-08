{
  plugins.trouble = {
    enable = true;

    settings = {
      auto_close = false;
      auto_open = false;
      auto_preview = true;
      auto_refresh = true;
      auto_jump = false;
      focus = true;
      restore = true;
      follow = true;
      indent_guides = true;
      max_items = 200;
      multiline = true;
      pinned = false;
      warn_no_results = true;
      open_no_results = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = ":Trouble diagnostics toggle<CR>";
      options = {
        desc = "Toggle trouble diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xw";
      action = ":Trouble diagnostics toggle filter.buf=0<CR>";
      options = {
        desc = "Buffer diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = ":Trouble loclist toggle<CR>";
      options = {
        desc = "Location list";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = ":Trouble qflist toggle<CR>";
      options = {
        desc = "Quickfix list";
        silent = true;
      };
    }
  ];
}
