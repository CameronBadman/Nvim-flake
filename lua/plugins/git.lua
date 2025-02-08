local keymap = vim.keymap.set

-- Fugitive keymaps
keymap('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })
keymap('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git blame' })
keymap('n', '<leader>gd', ':Gdiff<CR>', { desc = 'Git diff' })
keymap('n', '<leader>gl', ':Git log<CR>', { desc = 'Git log' })
keymap('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git commit' })
keymap('n', '<leader>gh', ':GBrowse<CR>', { desc = 'Open in GitHub' })
keymap('v', '<leader>gh', ':GBrowse<CR>', { desc = 'Open in GitHub' })

-- Add custom commands for common operations
vim.api.nvim_create_user_command('Gpush', 'Git push', {})
vim.api.nvim_create_user_command('Gpull', 'Git pull', {})

-- Configure Rhubarb (assumes you're using GitHub)
vim.g.github_enterprise_urls = {} -- Add your GitHub enterprise URLs here if needed
