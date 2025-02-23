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
        format_on_save = true,
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
                    fillreturns = true,   -- Add missing return statements
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
                -- Import and formatting settings
                importShortcut = "Definition",
                matcher = "Fuzzy",
                symbolMatcher = "fuzzy",
                formatting = {
                    gofumpt = true,
                },
                -- Additional completion settings
                completionBudget = "100ms",
                deepCompletion = true,
                diagnosticsDelay = "500ms",
                annotatesPkgErrors = true,
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
            
            -- Add auto-import organization and formatting on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Organize imports
                    local params = vim.lsp.util.make_range_params()
                    params.context = {only = {"source.organizeImports"}}
                    
                    -- synchronously organize imports
                    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                    if result and result[1] then
                        for _, r in pairs(result[1].result or {}) do
                            if r.edit then
                                vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")  -- Changed from UTF-8 to utf-8
                            end
                        end
                    end
                    
                    -- Then format
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 5000
                    })
                end
            })
        end
    })
end

return M
