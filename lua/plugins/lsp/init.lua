local lsp_zero = require('lsp-zero')
local M = {}

function M.setup()
    -- Initialize lsp-zero with preset
    lsp_zero.preset({
        name = 'recommended',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = true,
    })

    -- Load language server configurations
    require('lua.plugins.lsp.servers.gopls').setup()
    require('lua.plugins.lsp.servers.python').setup()
    require('lua.plugins.lsp.servers.javascript').setup()   
    require('lua.plugins.lsp.servers.terraform').setup()   

    -- Set up lsp-zero
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
