{
  plugins.alpha = {
    enable = true;
    layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        opts = {
          position = "center";
          hl = "Type";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  Find File";
            on_press.__raw = "function() require('telescope.builtin').find_files() end";
            opts = {
              keymap = [
                "n"
                "f"
                "<cmd>Telescope find_files<cr>"
                { desc = "Find Files"; }
              ];
              shortcut = "f";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "  Recent Files";
            on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
            opts = {
              keymap = [
                "n"
                "r"
                "<cmd>Telescope oldfiles<cr>"
                { desc = "Recent Files"; }
              ];
              shortcut = "r";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "  New File";
            on_press.__raw = "function() vim.cmd('enew') end";
            opts = {
              keymap = [
                "n"
                "n"
                "<cmd>enew<cr>"
                { desc = "New File"; }
              ];
              shortcut = "n";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "󰈞  File Manager";
            on_press.__raw = "function() vim.cmd('Neotree') end";
            opts = {
              keymap = [
                "n"
                "e"
                "<cmd>Neotree<cr>"
                { desc = "File Manager"; }
              ];
              shortcut = "e";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "button";
            val = "  Quit";
            on_press.__raw = "function() vim.cmd('qa') end";
            opts = {
              keymap = [
                "n"
                "q"
                "<cmd>qa<cr>"
                { desc = "Quit"; }
              ];
              shortcut = "q";
              position = "center";
              cursor = 3;
              width = 50;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
    ];
  };
}
