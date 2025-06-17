-- General keymaps can go here
vim.keymap.set('n', '<leader>e', ':Neotree<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit current window' })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { desc = 'Force quit current window' })

vim.api.nvim_create_user_command('GoplsLog', function()
    local logpath = vim.fn.stdpath("cache") .. "/lsp_logs/gopls.log"
    vim.cmd('edit ' .. logpath)
end, {})
