{
  plugins = {
    # Completion engine
    cmp = {
      enable = true;
      settings = {
        # Global completion sources (languages will extend these)
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
            max_item_count = 50;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "buffer";
            priority = 500;
            keyword_length = 3;
            max_item_count = 15;
          }
          {
            name = "path";
            priority = 250;
          }
        ];

        # Snippet engine integration
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        # Key mappings
        mapping = {
          # Scrolling
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          
          # Completion control
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";

          # Navigation (vim-like with Alt)
          "<M-j>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<M-k>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";

          # Tab for completion and snippet jumping
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.confirm({ select = true })
              elseif require('luasnip').locally_jumpable(1) then
                require('luasnip').jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if require('luasnip').locally_jumpable(-1) then
                require('luasnip').jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          # Enter for explicit confirmation only
          "<CR>" = "cmp.mapping.confirm({ select = false })";
        };

        # Window appearance
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None";
            max_height = 15;
            max_width = 80;
            scrollbar = true;
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:CmpDoc";
            max_height = 15;
            max_width = 80;
          };
        };

        # Item formatting
        formatting = {
          expandable_indicator = true;
          fields = [ "kind" "abbr" "menu" ];
          format = ''
            function(entry, vim_item)
              local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
              }
              
              -- Add kind icon
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
              
              -- Add source indicator
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                cmdline = "[Cmd]",
              })[entry.source.name] or "[?]"
              
              -- Truncate long completions but keep them readable
              if string.len(vim_item.abbr) > 60 then
                vim_item.abbr = string.sub(vim_item.abbr, 1, 57) .. "..."
              end
              
              return vim_item
            end
          '';
        };

        # Performance optimization
        performance = {
          debounce = 150;
          throttle = 60;
          fetching_timeout = 500;
          confirm_resolve_timeout = 80;
          async_budget = 1;
          max_view_entries = 200;
        };

        # Completion behavior
        completion = {
          autocomplete = [
            "require('cmp.types').cmp.TriggerEvent.TextChanged"
          ];
          completeopt = "menu,menuone,noinsert";
          keyword_length = 1;
        };

        # Experimental features
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText";
          };
        };

        # Sorting preferences
        sorting = {
          priority_weight = 2;
          comparators = [
            "cmp.config.compare.offset"
            "cmp.config.compare.exact"
            "cmp.config.compare.score"
            "cmp.config.compare.recently_used"
            "cmp.config.compare.locality"
            "cmp.config.compare.kind"
            "cmp.config.compare.sort_text"
            "cmp.config.compare.length"
            "cmp.config.compare.order"
          ];
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

    # Completion sources
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
  };

  # Minimal Lua config for command line completion only
  extraConfigLua = ''
    local cmp = require('cmp')

    -- Command line completion
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline({
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<M-k>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Search completion
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline({
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<M-k>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Disable in telescope
    cmp.setup.filetype('TelescopePrompt', {
      enabled = false
    })

    -- Set up ghost text highlight
    vim.api.nvim_set_hl(0, 'CmpGhostText', { 
      link = 'Comment', 
      default = true 
    })
  '';
}
