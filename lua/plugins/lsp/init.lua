-- config/plugins/lsp/init.lua
local lspconfig = require('lspconfig')

-- LSP servers setup
lspconfig.pylsp.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        ruff = { enabled = true },
        black = { enabled = true },
        pylint = { enabled = true },
        pycodestyle = { enabled = false },  -- we use ruff instead
        pyflakes = { enabled = false },     -- we use ruff instead
        mccabe = { enabled = false },       -- we use ruff instead
        autopep8 = { enabled = false },     -- we use black instead
      }
    }
  }
})

-- LSP Keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })

-- Diagnostic keymaps (Changed <leader>e to <leader>d)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Float Diagnostic' }) -- Changed from <leader>e
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic List' })

-- LSP handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
  }
)

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
