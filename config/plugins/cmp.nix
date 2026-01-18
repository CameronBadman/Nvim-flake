{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        sources = [
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 900;
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

        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        preselect = "cmp.PreselectMode.None";

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";

          "<M-j>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<M-k>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";

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

          "<CR>" = "cmp.mapping.confirm({ select = false })";
        };

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
              
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
              
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[Sig]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                cmdline = "[Cmd]",
              })[entry.source.name] or "[?]"
              
              if string.len(vim_item.abbr) > 60 then
                vim_item.abbr = string.sub(vim_item.abbr, 1, 57) .. "..."
              end
              
              return vim_item
            end
          '';
        };

        performance = {
          debounce = 60;
          throttle = 30;
          fetching_timeout = 2000;
          confirm_resolve_timeout = 80;
          async_budget = 1;
          max_view_entries = 200;
        };

        completion = {
          autocomplete = [
            "require('cmp.types').cmp.TriggerEvent.TextChanged"
          ];
          completeopt = "menu,menuone,noinsert";
          keyword_length = 1;
        };

        matching = {
          disallow_fuzzy_matching = false;
          disallow_fullfuzzy_matching = false;
          disallow_partial_fuzzy_matching = false;
          disallow_partial_matching = false;
          disallow_prefix_unmatching = false;
        };

        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText";
          };
        };

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

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
  };

  extraConfigLua = ''
    local cmp = require('cmp')

    cmp.setup({
      enabled = function()
        local context = require('cmp.config.context')
        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
        end
      end,
    })

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

    cmp.setup.filetype('TelescopePrompt', {
      enabled = false
    })

    cmp.setup.filetype('go', {
      sources = cmp.config.sources({
        {
          name = 'nvim_lsp',
          entry_filter = function(entry, ctx)
            local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
            return true
          end,
        }
      }, {
        { name = 'luasnip' },
        { name = 'buffer', keyword_length = 5 },
        { name = 'path' }
      })
    })

    vim.api.nvim_set_hl(0, 'CmpGhostText', {
      link = 'Comment',
      default = true
    })
  '';
}
