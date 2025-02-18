-- lua/plugins/lsp/servers/gopls.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- Go-specific format settings
    local format_opts = {
        async = false,  -- Go formatting is usually fast
        format_on_save = false,
        timeout_ms = 5000,
        formatting_options = {
            gofumpt = true,
            indent_size = 8,
        }
    }

    lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    unreachable = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                    unusedvariable = true,
                    lostcancel = true,
                    printf = true,
                    shadow = true,
                    fieldalignment = false, -- Explicitly disable deprecated analysis
                    staticcheck = true,   -- Enable staticcheck integration
                    nilfunc = true,        -- Check for nil function calls
                    nonewvars = true,      -- Warn on unused new variables
                    undeclaredname = true, -- Check for undeclared names
                    unusedresult = true,   -- Check for unused function results
                    unusedstructs = true,  -- Check for unused struct fields
                    deepequalerrors = true, -- Check for errors in deep equal
                    embed = true,          -- Check for incorrect embed usage
                    errorsas = true,      -- Check for errors.As usage
                    httpresponse = true,   -- Check for unclosed HTTP responses
                    ifaceassert = true,    -- Check for interface assertions
                    loopclosure = true,    -- Check for loop variable capture
                    noresultvalues = true, -- Check for missing result values
                    testinggoroutine = true, -- Check for incorrect testing goroutines
                    tests = true,         -- Check for test issues
                    timeformat = true,    -- Check for time format issues
                    unmarshal = true,     -- Check for unmarshal issues
                    unsafeptr = true,     -- Check for unsafe.Pointer usage
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                    constantValues = true, -- Show hints for constant values
                },
                completeUnimported = true,
                usePlaceholders = true,
                semanticTokens = true,
                codelenses = {
                    generate = true,
                    gc_details = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true, -- Add dependency upgrade code lens
                },
                experimentalPostfixCompletions = true,
                -- Format settings
                gofumpt = format_opts.formatting_options.gofumpt,
                buildFlags = { "-tags", "integration" },
                directoryFilters = { "-node_modules", "-.git", "-vendor" },
            }
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with Go-specific options
            format.setup(client, bufnr, format_opts)
        end
    })
end

return M
