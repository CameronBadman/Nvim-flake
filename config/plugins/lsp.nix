{
  plugins.lsp = {
    enable = true;
    
    onAttach = ''
      local opts = { buffer = bufnr, silent = true, noremap = true }
      
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
      
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
      
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)
      
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
      vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, opts)
      
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      
      vim.keymap.set('n', '<leader>fm', function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    '';
  };
  
  extraConfigLua = ''
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    vim.lsp.config('*', {
      capabilities = capabilities,
    })
    
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        severity = { min = vim.diagnostic.severity.ERROR },
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
        texthl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "always",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })
    
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
  '';
}
