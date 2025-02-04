
{
  plugins.telescope = {
    enable = true;
    
    defaults = {
      fileIgnorePatterns = [
        "^.git/"
        "^.mypy_cache/"
        "^__pycache__/"
        "^output/"
        "^data/"
        "%.ipynb"
      ];
      layoutConfig = {
        promptPosition = "top";
      };
      mappings = {
        i = {
          "<C-j>" = {
            __raw = "require('telescope.actions').move_selection_next";
          };
          "<C-k>" = {
            __raw = "require('telescope.actions').move_selection_previous";
          };
          "<esc>" = "actions.close";
        };
      };
      selectionCaret = "> ";
      setEnv.COLORTERM = "truecolor";
      sortingStrategy = "ascending";
    };

    extensions.fzf-native.enable = true;

    keymaps = {
       "<leader><space>" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>/" = {
        action = "live_grep";
        options = {
          desc = "Grep (root dir)";
        };
      };
  };
  };

  extraConfigLua = ''
    require('telescope').setup({
      pickers = {
        find_files = {
          theme = "dropdown",
          hidden = true,
          previewer = false,
        },
        live_grep = {
          theme = "dropdown",
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        }
      }
    })
  '';
}
