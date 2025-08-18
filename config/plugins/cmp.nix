{
  plugins = {
    # Completion engine (updated API)
    cmp = {
      enable = true;

      settings = {
        # Completion sources in priority order for code files
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            # IMPORTANT: Allow longer completion items for Java imports
            max_item_count = 50;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            keyword_length = 2;  # Reduced from 0 for better performance
          }
          {
            name = "path";
            priority = 250;
          }
        ];

        # Snippet configuration
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };

        # Key mappings for completion
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";

          # Alt+j/k for navigation (vim-like)
          "<M-j>" = "cmp.mapping.select_next_item()";
          "<M-k>" = "cmp.mapping.select_prev_item()";

          # Tab to confirm selection when menu is visible
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.confirm({ select = true })
              elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          # Shift+Tab for snippet jumping back
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          # Enter for confirmation
          "<CR>" = "cmp.mapping.confirm({ select = false })";
        };

        # Completion window styling
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
            max_height = 20;  # Show more items for Java imports
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:CmpDoc";
            max_height = 15;
          };
        };

        # Formatting for completion items
        formatting = {
          format = ''
            function(entry, vim_item)
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              
              -- Truncate long Java class names but keep them readable
              if vim_item.kind == "Class" or vim_item.kind == "Method" then
                if string.len(vim_item.abbr) > 50 then
                  vim_item.abbr = string.sub(vim_item.abbr, 1, 47) .. "..."
                end
              end
              
              return vim_item
            end
          '';
        };

        # Performance settings - tuned for Java LSP
        performance = {
          debounce = 100;  # Slightly higher for Java LSP
          throttle = 50;
          fetching_timeout = 1000;  # Longer timeout for Java imports
        };

        # IMPORTANT: Enable experimental features for better LSP integration
        experimental = {
          ghost_text = true;
        };
      };
    };

    # Snippet engine
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

    # Additional completion sources
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
  };

  # Global Lua configuration
  extraConfigLua = ''
    -- Kind icons for completion items
    kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }

    local cmp = require('cmp')

    -- JAVA-SPECIFIC: Enhanced completion for Java files
    cmp.setup.filetype('java', {
      sources = cmp.config.sources({
        { 
          name = 'nvim_lsp', 
          priority = 1000,
          max_item_count = 100,  -- More items for Java imports
          keyword_length = 1,    -- Shorter keyword length for Java
        },
        { name = 'luasnip', priority = 750 },
        { 
          name = 'buffer', 
          priority = 500, 
          keyword_length = 3,
          max_item_count = 10,   -- Fewer buffer items to prioritize LSP
        },
        { name = 'path', priority = 250 }
      }),
      -- Custom completion behavior for Java
      completion = {
        autocomplete = { 
          require('cmp.types').cmp.TriggerEvent.TextChanged,
        },
        keyword_length = 1,  -- Start completing after 1 character
      },
    })

    -- Command line completion (VIM COMMANDS ONLY)
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline({
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<M-k>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'path', priority = 1000 }
      }, {
        { name = 'cmdline', priority = 500 }
      }),
    })

    -- Search completion (BUFFER SEARCH ONLY)
    cmp.setup.cmdline({'/', '?'}, {
      mapping = cmp.mapping.preset.cmdline({
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<M-k>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Other language-specific completion tweaks
    for _, lang in ipairs({'terraform', 'elixir', 'haskell', 'lua'}) do
      cmp.setup.filetype(lang, {
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500, keyword_length = 3 },
          { name = 'path', priority = 250 }
        })
      })
    end

    -- Disable completion in certain contexts
    cmp.setup.filetype('TelescopePrompt', {
      enabled = false
    })

    -- IMPORTANT: Auto-trigger completion for Java imports
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        -- Force completion to trigger more aggressively for Java
        vim.api.nvim_create_autocmd({"TextChangedI", "TextChangedP"}, {
          buffer = 0,
          callback = function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = string.sub(line, 1, col)
            
            -- Trigger completion after typing class names or method calls
            if string.match(before_cursor, "%w+$") or string.match(before_cursor, "%.%w*$") then
              if not cmp.visible() then
                cmp.complete()
              end
            end
          end,
        })
      end,
    })
  '';
}
