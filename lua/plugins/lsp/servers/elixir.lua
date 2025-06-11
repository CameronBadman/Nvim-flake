-- lua/plugins/lsp/servers/elixir.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- Elixir-specific format settings
    local format_opts = {
        async = false,  -- Elixir formatting is usually fast with mix format
        format_on_save = true,
        timeout_ms = 3000,
        formatting_options = {
            mix_format = true,
        }
    }

    lspconfig.elixirls.setup({
        capabilities = capabilities,
        cmd = { "elixir-ls" },
        filetypes = { "elixir", "eelixir", "heex", "surface" },
        root_dir = util.root_pattern("mix.exs", ".git"),
        settings = {
            elixirLS = {
                -- Language server settings
                dialyzerEnabled = true,
                fetchDeps = false,  -- Don't auto-fetch deps, do it manually
                enableTestLenses = true,
                suggestSpecs = true,
                
                -- Code completion settings
                autoInsertRequiredAlias = true,
                signatureAfterComplete = true,
                
                -- Additional settings for better development experience
                mixEnv = "dev",
                projectDir = ".",
                
                -- Test configuration
                testElixirLS = {
                    enabled = true,
                },
                
                -- Dialyzer configuration
                dialyzerWarnOpts = {
                    "error_handling",
                    "no_behaviours",
                    "no_contracts",
                    "no_fail_call",
                    "no_fun_app",
                    "no_improper_lists",
                    "no_match",
                    "no_missing_calls",
                    "no_opaque",
                    "no_return",
                    "no_undefined_callbacks",
                    "no_unused",
                    "underspecs",
                    "unknown",
                    "unmatched_returns",
                    "overspecs",
                    "specdiffs"
                },
                
                -- Workspace symbol settings
                workspaceSymbols = {
                    enabled = true,
                },
                
                -- Additional language features
                completionProvider = {
                    resolveProvider = true,
                    triggerCharacters = { ".", "@", "&", "%", "^", ":" }
                },
                
                -- Hover and signature help
                hoverProvider = true,
                signatureHelpProvider = {
                    triggerCharacters = { "(", "," }
                },
                
                -- Document symbols and formatting
                documentSymbolProvider = true,
                documentFormattingProvider = true,
                documentRangeFormattingProvider = false,  -- Use full document formatting
                
                -- Code actions and refactoring
                codeActionProvider = {
                    codeActionKinds = {
                        "quickfix",
                        "refactor",
                        "source.organizeImports"
                    }
                },
                
                -- Definition and references
                definitionProvider = true,
                referencesProvider = true,
                implementationProvider = true,
                
                -- Workspace features
                workspaceEditProvider = true,
                executeCommandProvider = {
                    commands = {
                        "spec",
                        "expandMacro",
                        "restart",
                        "reloadConfiguration"
                    }
                }
            }
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with Elixir-specific options
            format.setup(client, bufnr, format_opts)
            
            -- Elixir-specific keymaps
            local opts = { noremap = true, silent = true, buffer = bufnr }
            
            -- Mix commands
            vim.keymap.set('n', '<leader>mt', ':!mix test<CR>', opts)
            vim.keymap.set('n', '<leader>mta', ':!mix test --failed<CR>', opts)
            vim.keymap.set('n', '<leader>mc', ':!mix compile<CR>', opts)
            vim.keymap.set('n', '<leader>md', ':!mix deps.get<CR>', opts)
            vim.keymap.set('n', '<leader>mf', function()
                vim.lsp.buf.format({ timeout_ms = 3000 })
            end, opts)
            vim.keymap.set('n', '<leader>mr', ':!mix deps.compile<CR>', opts)
            vim.keymap.set('n', '<leader>mu', ':!mix deps.update --all<CR>', opts)
            
            -- Phoenix-specific commands (if in a Phoenix project)
            vim.keymap.set('n', '<leader>ps', ':!mix phx.server<CR>', opts)
            vim.keymap.set('n', '<leader>pr', ':!mix phx.routes<CR>', opts)
            vim.keymap.set('n', '<leader>pm', ':!mix phx.gen.migration ', opts)
            vim.keymap.set('n', '<leader>pc', ':!mix phx.gen.context ', opts)
            vim.keymap.set('n', '<leader>pl', ':!mix phx.gen.live ', opts)
            vim.keymap.set('n', '<leader>ph', ':!mix phx.gen.html ', opts)
            vim.keymap.set('n', '<leader>pj', ':!mix phx.gen.json ', opts)
            
            -- Ecto commands
            vim.keymap.set('n', '<leader>em', ':!mix ecto.migrate<CR>', opts)
            vim.keymap.set('n', '<leader>er', ':!mix ecto.rollback<CR>', opts)
            vim.keymap.set('n', '<leader>es', ':!mix ecto.setup<CR>', opts)
            vim.keymap.set('n', '<leader>ed', ':!mix ecto.drop<CR>', opts)
            vim.keymap.set('n', '<leader>ec', ':!mix ecto.create<CR>', opts)
            
            -- IEx and debugging
            vim.keymap.set('n', '<leader>ix', ':!iex -S mix<CR>', opts)
            vim.keymap.set('n', '<leader>ixp', ':!iex -S mix phx.server<CR>', opts)
            
            -- Dialyzer
            vim.keymap.set('n', '<leader>dx', ':!mix dialyzer<CR>', opts)
            vim.keymap.set('n', '<leader>dp', ':!mix dialyzer --plt<CR>', opts)
            
            -- Credo (if using)
            vim.keymap.set('n', '<leader>cx', ':!mix credo<CR>', opts)
            vim.keymap.set('n', '<leader>cs', ':!mix credo --strict<CR>', opts)
            
            -- ExUnit test at cursor
            vim.keymap.set('n', '<leader>tt', function()
                local line = vim.api.nvim_win_get_cursor(0)[1]
                vim.cmd('!mix test ' .. vim.fn.expand('%') .. ':' .. line)
            end, opts)
            
            -- Format on save with mix format
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Use LSP formatting which should use mix format
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 3000,
                        async = false
                    })
                end
            })
            
            -- Auto-require aliases for modules (Elixir-specific feature)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Request code actions for auto-alias
                    local params = vim.lsp.util.make_range_params()
                    params.context = {only = {"source.organizeImports", "quickfix"}}
                    
                    -- Apply auto-alias code actions if available
                    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
                    if result and result[1] then
                        for _, r in pairs(result[1].result or {}) do
                            if r.edit and r.title and string.match(r.title:lower(), "alias") then
                                vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                            end
                        end
                    end
                end
            })
        end,
        
        -- Additional initialization options
        init_options = {
            -- Enable additional features
            enableTestLenses = true,
            enableDialyzer = true,
            enableCompletions = true,
            enableHover = true,
            enableSignatureHelp = true,
        }
    })
end

return M
