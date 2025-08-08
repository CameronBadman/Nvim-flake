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
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            keyword_length = 0;
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

          # Enter for confirmation (optional, more explicit)
          "<CR>" = "cmp.mapping.confirm({ select = false })";
        };

        # Completion window styling
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:CmpDoc";
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
              return vim_item
            end
          '';
        };

        # Performance settings
        performance = {
          debounce = 60;
          throttle = 30;
          fetching_timeout = 500;
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

    -- SEPARATE: Command line completion (VIM COMMANDS ONLY)
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
      -- Only show vim commands, not LSP stuff
      completion = {
        autocomplete = { 
          require('cmp.types').cmp.TriggerEvent.TextChanged 
        },
      },
    })

    -- SEPARATE: Search completion (BUFFER SEARCH ONLY)
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

    -- Language-specific completion tweaks (LANGUAGE STUFF ONLY)
    cmp.setup.filetype('terraform', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 3 },
        { name = 'path', priority = 250 }
      })
    })

    cmp.setup.filetype('elixir', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 3 },
        { name = 'path', priority = 250 }
      })
    })

    cmp.setup.filetype('haskell', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 3 },
        { name = 'path', priority = 250 }
      })
    })

    cmp.setup.filetype('lua', {
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 3 },
        { name = 'path', priority = 250 }
      })
    })

    -- Disable completion in certain contexts to avoid interference
    cmp.setup.filetype('TelescopePrompt', {
      enabled = false
    })
  '';
}
