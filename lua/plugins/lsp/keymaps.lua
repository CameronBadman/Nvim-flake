local keymap = vim.keymap.set

keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
keymap('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
keymap('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
keymap('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Float Diagnostic' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic List' })
