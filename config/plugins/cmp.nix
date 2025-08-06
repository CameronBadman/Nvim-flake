{ lib, ... }:
{
  plugins.cmp = {
    enable = true;
    
    settings = {
      snippet = {
        expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };
      
      completion = {
        completeopt = "menu,menuone,noinsert";
      };
      
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None";
        };
        documentation = {
          border = "rounded";
        };
      };
      
      mapping = {
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        
        # Better navigation with Tab/Shift-Tab AND arrow keys
        "<Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
        "<S-Tab>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
        "<Down>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
        "<Up>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
        
        # Ctrl navigation as well
        "<C-n>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
        "<C-p>" = "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
      };
      
      sources = lib.mkDefault [
        { name = "nvim_lsp"; priority = 1000; }
        { name = "luasnip"; priority = 750; }
        { name = "buffer"; priority = 500; }
        { name = "path"; priority = 250; }
      ];
      
      formatting = {
        format = ''
          function(entry, vim_item)
            local icons = {
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
            
            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            }
            
            -- Kind icon
            vim_item.kind = string.format('%s %s', icons[vim_item.kind] or "", vim_item.kind)
            
            -- Source name
            vim_item.menu = source_names[entry.source.name] or "[" .. entry.source.name .. "]"
            
            return vim_item
          end
        '';
      };
    };
  };

  # Essential completion sources that external flakes can extend
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
  };
}
