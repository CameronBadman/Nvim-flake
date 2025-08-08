{
  colorschemes.kanagawa = {
    enable = true;
    settings = {
      compile = false;
      undercurl = true;
      commentStyle = {
        italic = true;
      };
      functionStyle = {
        bold = true;
      };
      keywordStyle = {
        italic = true;
        bold = true;
      };
      statementStyle = {
        bold = true;
      };
      typeStyle = {
        italic = true;
      };
      transparent = false;
      dimInactive = false;
      terminalColors = true;
      theme = "wave";

      # Custom colors to match your tmux theme
      colors = {
        palette = {
          # Tomorrow Night inspired colors to match tmux
          sumiInk0 = "#1d1f21"; # Background (matches tmux bg)
          sumiInk1 = "#282a2e"; # Slightly lighter background
          sumiInk2 = "#373b41"; # Even lighter
          sumiInk3 = "#969896"; # Comments
          oldWhite = "#c5c8c6"; # Foreground (matches tmux fg)
          fujiWhite = "#c5c8c6"; # Main text
          fujiGray = "#666666"; # Muted text (matches tmux muted)

          # Accent colors from tmux
          crystalBlue = "#81a2be"; # Blue accent (matches tmux active)
          springViolet1 = "#b294bb"; # Purple
          oniViolet = "#cc6666"; # Red (matches tmux prefix color)
          carpYellow = "#f0c674"; # Yellow (matches tmux message)
          springGreen = "#b5bd68"; # Green
          waveAqua1 = "#8abeb7"; # Cyan

          # Status and UI
          waveBlue1 = "#81a2be";
          waveBlue2 = "#7c9eb2";
        };

        theme = {
          wave = {
            ui = {
              bg = "#1d1f21";
              bg_gutter = "#1d1f21";
              bg_m3 = "#282a2e";
              bg_m1 = "#373b41";
              bg_p1 = "#282a2e";
              bg_p2 = "#373b41";
              fg = "#c5c8c6";
              fg_dim = "#969896";
              fg_reverse = "#1d1f21";
              nontext = "#666666";
              special = "#81a2be";
            };
            syn = {
              comment = "#969896";
              constant = "#de935f";
              string = "#b5bd68";
              variable = "#c5c8c6";
              keyword = "#b294bb";
              operator = "#8abeb7";
              preproc = "#f0c674";
              identifier = "#81a2be";
              statement = "#cc6666";
              type = "#f0c674";
              special1 = "#de935f";
              special2 = "#f0c674";
              special3 = "#b5bd68";
            };
            vcs = {
              added = "#b5bd68";
              removed = "#cc6666";
              changed = "#f0c674";
            };
            diag = {
              error = "#cc6666";
              warning = "#f0c674";
              info = "#81a2be";
              hint = "#8abeb7";
            };
          };
        };
      };

      # Enhanced overrides for consistent theming
      overrides = ''
        function(colors)
          local theme = colors.theme
          return {
            -- Editor basics
            Normal = { fg = "#c5c8c6", bg = "#1d1f21" },
            NormalFloat = { fg = "#c5c8c6", bg = "#282a2e" },
            CursorLine = { bg = "#282a2e" },
            LineNr = { fg = "#666666" },
            CursorLineNr = { fg = "#f0c674", bold = true },
            SignColumn = { bg = "#1d1f21" },
            
            -- Completion menu
            Pmenu = { fg = "#c5c8c6", bg = "#282a2e" },
            PmenuSel = { fg = "#1d1f21", bg = "#81a2be", bold = true },
            PmenuSbar = { bg = "#373b41" },
            PmenuThumb = { bg = "#81a2be" },
            
            -- Telescope (matching tmux style)
            TelescopeTitle = { fg = "#81a2be", bold = true },
            TelescopePromptNormal = { fg = "#c5c8c6", bg = "#282a2e" },
            TelescopePromptBorder = { fg = "#81a2be", bg = "#282a2e" },
            TelescopeResultsNormal = { fg = "#969896", bg = "#1d1f21" },
            TelescopeResultsBorder = { fg = "#666666", bg = "#1d1f21" },
            TelescopePreviewNormal = { fg = "#c5c8c6", bg = "#1d1f21" },
            TelescopePreviewBorder = { fg = "#666666", bg = "#1d1f21" },
            TelescopeSelection = { fg = "#1d1f21", bg = "#81a2be", bold = true },
            
            -- Neo-tree
            NeoTreeNormal = { fg = "#969896", bg = "#1d1f21" },
            NeoTreeNormalNC = { fg = "#969896", bg = "#1d1f21" },
            NeoTreeDirectoryIcon = { fg = "#81a2be" },
            NeoTreeDirectoryName = { fg = "#81a2be" },
            NeoTreeFileName = { fg = "#c5c8c6" },
            NeoTreeFileIcon = { fg = "#969896" },
            NeoTreeGitModified = { fg = "#f0c674" },
            NeoTreeGitAdded = { fg = "#b5bd68" },
            NeoTreeGitDeleted = { fg = "#cc6666" },
            
            -- Status line (lualine will override but good defaults)
            StatusLine = { fg = "#c5c8c6", bg = "#282a2e" },
            StatusLineNC = { fg = "#666666", bg = "#1d1f21" },
            
            -- Diagnostics
            DiagnosticError = { fg = "#cc6666" },
            DiagnosticWarn = { fg = "#f0c674" },
            DiagnosticInfo = { fg = "#81a2be" },
            DiagnosticHint = { fg = "#8abeb7" },
            DiagnosticVirtualTextError = { fg = "#cc6666", bg = "none" },
            DiagnosticVirtualTextWarn = { fg = "#f0c674", bg = "none" },
            DiagnosticVirtualTextInfo = { fg = "#81a2be", bg = "none" },
            DiagnosticVirtualTextHint = { fg = "#8abeb7", bg = "none" },
            
            -- Git signs
            GitSignsAdd = { fg = "#b5bd68" },
            GitSignsChange = { fg = "#f0c674" },
            GitSignsDelete = { fg = "#cc6666" },
            
            -- Search
            IncSearch = { fg = "#1d1f21", bg = "#f0c674", bold = true },
            Search = { fg = "#1d1f21", bg = "#81a2be" },
            
            -- Visual selection
            Visual = { fg = "#1d1f21", bg = "#81a2be" },
            
            -- Tabs
            TabLine = { fg = "#666666", bg = "#1d1f21" },
            TabLineFill = { bg = "#1d1f21" },
            TabLineSel = { fg = "#1d1f21", bg = "#81a2be", bold = true },
          }
        end
      '';
    };
  };
}
