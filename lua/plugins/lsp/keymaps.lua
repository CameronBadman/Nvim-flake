local format = require('lua.plugins.lsp.format')
local M = {}

function M.set_keymaps(client, bufnr)
    local opts = {buffer = bufnr}
    
    -- Your existing keymaps
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    
    -- Use our new formatting system
    vim.keymap.set('n', '<leader>f', format.format_buffer, opts)
end

return M
