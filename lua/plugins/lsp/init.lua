local lsp_zero = require('lsp-zero')

local M = {}

function M.setup()
    lsp_zero.preset({
        name = 'recommended',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = true,
    })

    -- Configure servers
    require('lua.plugins.lsp.settings.gopls').setup(lsp_zero)

    -- Set up keymaps
    lsp_zero.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr}
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
    end)

    lsp_zero.setup()

    -- Configure diagnostics
    vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = {
            source = 'always',
            border = 'rounded',
            header = '',
            prefix = '',
        },
    })
end

return M
