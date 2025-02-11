-- File: lua/plugins/lsp/servers/go.lua

-- Enable debug logging for LSP
vim.lsp.set_log_level("debug")

local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
    cmd = { 
        "gopls", 
        "serve",
        "-rpc.trace",                             -- Enable RPC tracing
        "-logfile=/tmp/gopls.log"                 -- Set log file location
    },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
    },
    settings = {
        gopls = {
            -- Analysis settings
            analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                copylocks = true,
                fieldalignment = true,
                assign = true,
                lostcancel = true,
                stdmethods = true,
                defers = true
            },
            
            -- Enable verbose output
            verboseOutput = true,
            
            -- Code lenses
            codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true
            },
            
            -- Hints configuration
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true
            },
            
            -- Additional features
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            gofumpt = false,
            semanticTokens = true,
            
            -- Directory filters
            directoryFilters = { 
                "-.git", 
                "-.vscode", 
                "-.idea", 
                "-.vscode-test", 
                "-node_modules" 
            }
        }
    }
})

-- Create command to view LSP logs
vim.api.nvim_create_user_command('ViewLspLog', function()
    vim.cmd('edit ' .. vim.lsp.get_log_path())
end, {})

-- Force diagnostics on save
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.go",
    callback = function()
        vim.cmd('write')  -- Save the file
        vim.lsp.buf.document_diagnostic()  -- Force diagnostics refresh
    end,
})

return {}
