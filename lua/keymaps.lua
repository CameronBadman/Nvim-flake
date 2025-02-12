-- General keymaps can go here
vim.keymap.set('n', '<leader>e', ':Neotree<CR>')

vim.api.nvim_create_user_command('GoplsLog', function()
    local logpath = vim.fn.stdpath("cache") .. "/lsp_logs/gopls.log"
    vim.cmd('edit ' .. logpath)
end, {})
