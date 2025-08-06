{
  plugins.telescope = {
    enable = true;
    
    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };
    
    extensions = {
      file-browser.enable = true;
      fzf-native.enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = ":Telescope find_files<CR>";
      options = {
        desc = "Find files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = ":Telescope live_grep<CR>";
      options = {
        desc = "Live grep";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = ":Telescope buffers<CR>";
      options = {
        desc = "Find buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = ":Telescope help_tags<CR>";
      options = {
        desc = "Help tags";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = ":Telescope oldfiles<CR>";
      options = {
        desc = "Recent files";
        silent = true;
      };
    }
  ];
}
