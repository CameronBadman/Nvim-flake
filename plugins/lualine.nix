{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    theme = {
      normal = {
        a = { fg = "#1F1F28"; bg = "#7E9CD8"; gui = "bold"; };
        b = { fg = "#7E9CD8"; bg = "#2A2A37"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
      insert = {
        a = { fg = "#1F1F28"; bg = "#98BB6C"; gui = "bold"; };
        b = { fg = "#98BB6C"; bg = "#2A2A37"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
      visual = {
        a = { fg = "#1F1F28"; bg = "#957FB8"; gui = "bold"; };
        b = { fg = "#957FB8"; bg = "#2A2A37"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
      replace = {
        a = { fg = "#1F1F28"; bg = "#E46876"; gui = "bold"; };
        b = { fg = "#E46876"; bg = "#2A2A37"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
      command = {
        a = { fg = "#1F1F28"; bg = "#FF9E3B"; gui = "bold"; };
        b = { fg = "#FF9E3B"; bg = "#2A2A37"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
      inactive = {
        a = { fg = "#DCD7BA"; bg = "#16161D"; gui = "bold"; };
        b = { fg = "#DCD7BA"; bg = "#1F1F28"; };
        c = { fg = "#DCD7BA"; bg = "NONE"; };
      };
    };

    componentSeparators = {
      left = "│";
      right = "│";
    };

    sectionSeparators = {
      left = "";
      right = "";
    };

    sections = {
      lualine_a = [{
        name = "mode";
        separator = {
          left = "";
          right = "";
        };
        padding = 2;
      }];
      
      lualine_b = [
        {
          name = "branch";
          icon = "󰊢";
          padding = { left = 1; right = 1; };
        }
        {
          name = "diff";
          symbols = {
            added = "󰐕 ";
            modified = "󰝤 ";
            removed = "󰍴 ";
          };
          padding = { left = 1; right = 1; };
        }
      ];

      lualine_c = [{
        name = "filename";
        path = 1;
        symbols = {
          modified = "●";
          readonly = "󰌾";
          unnamed = "[No Name]";
          newfile = "󰎔";
        };
      }];

      lualine_x = [
        {
          name = "diagnostics";
          sources = [ "nvim_diagnostic" ];
          sections = [ "error" "warn" "info" "hint" ];
          symbols = {
            error = "󰅚 ";
            warn = "󰀦 ";
            info = "󰋼 ";
            hint = "󰌶 ";
          };
        }
        {
          name = "encoding";
          icon = "󰁨";
        }
        {
          name = "fileformat";
        }
        {
          name = "filetype";
          icon_only = true;
          padding = { left = 1; right = 0; };
        }
        {
          name = "filetype";
          icons_enabled = false;
          padding = { left = 1; right = 2; };
        }
      ];

      lualine_y = [{
        name = "progress";
        icon = "󰜎";
        padding = { left = 1; right = 1; };
      }];

      lualine_z = [{
        name = "location";
        separator = {
          left = "";
          right = "";
        };
        padding = 2;
        icon = "󰍒";
      }];
    };

    inactiveSections = {
      lualine_a = [];
      lualine_b = [];
      lualine_c = [{ name = "filename"; }];
      lualine_x = [{ name = "location"; }];
      lualine_y = [];
      lualine_z = [];
    };
  };

  # Add this to support custom fileformat icons
  extraConfigLua = ''
    -- Custom file format icons
    local function get_fileformat_icon()
        local icons = {
            unix = "", -- Linux
            dos = "", -- Windows
            mac = "", -- macOS
        }
        return icons[vim.bo.fileformat] or ""
    end

    -- Set fileformat icon formatter
    require('lualine').setup({
      sections = {
        lualine_x = {
          {
            'fileformat',
            fmt = get_fileformat_icon
          }
        }
      }
    })
  '';
}
