{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "kanagawa";
        component_separators = {
          left = "|";
          right = "|";
        };
        section_separators = {
          left = "";
          right = "";
        };
        globalstatus = true;
        disabled_filetypes = {
          statusline = [ "alpha" "neo-tree" ];
        };
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1;
            symbols = {
              modified = "●";
              readonly = "";
              unnamed = "[No Name]";
            };
          }
        ];
        lualine_x = [
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactive_sections = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
        ];
        lualine_x = [ "location" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
    };
  };
}
