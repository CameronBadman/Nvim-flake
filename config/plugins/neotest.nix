# In your nixvim configuration
{
  plugins = {
    # Neotest with adapters
    neotest = {
      enable = true;
      adapters = {
        java = {
          enable = true;
        };
        python = {
          enable = true;
        };
        jest = {
          enable = true;
        };
      };
      settings = {
        output = {
          enabled = true;
          open_on_run = "short";
        };
        quickfix = {
          enabled = false;
        };
      };
    };

    # Required dependencies
    treesitter.enable = true;
    plenary.enable = true;
  };

  # Key mappings
  keymaps = [
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>lua require('neotest').run.run()<cr>";
      options.desc = "Run nearest test";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>";
      options.desc = "Run current file tests";
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>lua require('neotest').output.open({ enter = true })<cr>";
      options.desc = "Open test output";
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<cmd>lua require('neotest').summary.toggle()<cr>";
      options.desc = "Toggle test summary";
    }
  ];
}
