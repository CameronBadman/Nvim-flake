# plugins/lualine.nix
{ pkgs }: {
  enable = true;
  theme = {
    normal = {
      a = { fg = "#1F1F28"; bg = "#7E9CD8"; style = "bold"; };
      b = { fg = "#7E9CD8"; bg = "#2A2A37"; };
      c = { fg = "#DCD7BA"; bg = "NONE"; };
    };
    insert = {
      a = { fg = "#1F1F28"; bg = "#98BB6C"; style = "bold"; };
      b = { fg = "#98BB6C"; bg = "#2A2A37"; };
      c = { fg = "#DCD7BA"; bg = "NONE"; };
    };
    visual = {
      a = { fg = "#1F1F28"; bg = "#957FB8"; style = "bold"; };
      b = { fg = "#957FB8"; bg = "#2A2A37"; };
      c = { fg = "#DCD7BA"; bg = "NONE"; };
    };
    replace = {
      a = { fg = "#1F1F28"; bg = "#E46876"; style = "bold"; };
      b = { fg = "#E46876"; bg = "#2A2A37"; };
      c = { fg = "#DCD7BA"; bg = "NONE"; };
    };
    command = {
      a = { fg = "#1F1F28"; bg = "#FF9E3B"; style = "bold"; };
      b = { fg = "#FF9E3B"; bg = "#2A2A37"; };
      c = { fg = "#DCD7BA"; bg = "NONE"; };
    };
    inactive = {
      a = { fg = "#DCD7BA"; bg = "#16161D"; style = "bold"; };
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

  globalstatus = true;

  sections = {
    lualine_a = [{
      name = "mode";
      extraConfig = {
        padding = 1;
        fmt = ''
          function(str)
            local mode_icons = {
              NORMAL = "󰆾 ",
              INSERT = "󰏫 ",
              VISUAL = "󰈈 ",
              ["V-LINE"] = "󰈈 ",
              ["V-BLOCK"] = "󰈈 ",
              REPLACE = "󰮂 ",
              COMMAND = "󰘳 "
            }
            return mode_icons[str] and mode_icons[str] .. str or str
          end
        '';
      };
    }];

    lualine_b = [
      {
        name = "branch";
        extraConfig = {
          icon = "󰊢";
          padding = { left = 1; right = 1; };
        };
      }
      {
        name = "diff";
        extraConfig = {
          symbols = {
            added = "󰐕 ";
            modified = "󰝤 ";
            removed = "󰍴 ";
          };
          padding = { left = 1; right = 1; };
        };
      }
    ];

    lualine_c = [{
      name = "filename";
      extraConfig = {
        path = 1;
        symbols = {
          modified = "●";
          readonly = "󰌾";
          unnamed = "[No Name]";
          newfile = "󰎔";
        };
      };
    }];

    lualine_x = [
      {
        name = "diagnostics";
        extraConfig = {
          sources = [ "nvim_diagnostic" ];
          sections = [ "error" "warn" "info" "hint" ];
          symbols = {
            error = "󰅚 ";
            warn = "󰀦 ";
            info = "󰋼 ";
            hint = "󰌶 ";
          };
        };
      }
      {
        name = "encoding";
        extraConfig = {
          icons_enabled = true;
          icon = "󰁨";
        };
      }
      {
        name = "fileformat";
        extraConfig = {
          icons_enabled = true;
          symbols = {
            unix = "";
            dos = "";
            mac = "";
          };
        };
      }
      {
        name = "filetype";
        extraConfig = {
          icons_enabled = true;
          icon_only = true;
          padding = { left = 1; right = 0; };
        };
      }
      {
        name = "filetype";
        extraConfig = {
          icons_enabled = false;
          padding = { left = 1; right = 2; };
        };
      }
    ];

    lualine_y = [{
      name = "progress";
      extraConfig = {
        icon = "󰜎";
        padding = { left = 1; right = 1; };
      };
    }];

    lualine_z = [{
      name = "location";
      extraConfig = {
        padding = 2;
        icon = "󰍒";
      };
    }];
  };

  inactiveSections = {
    lualine_a = [ ];
    lualine_b = [ ];
    lualine_c = [ "filename" ];
    lualine_x = [ "location" ];
    lualine_y = [ ];
    lualine_z = [ ];
  };
}
