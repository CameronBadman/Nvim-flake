local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- C#-specific format settings
    local format_opts = {
        async = false,
        format_on_save = true,
        timeout_ms = 8000,  -- C# can take longer to format
        formatting_options = {
            indent_size = 4,
            tab_size = 4,
            use_tabs = false,
        }
    }

    lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        filetypes = { "cs", "vb" },
        root_dir = util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
        settings = {
            FormattingOptions = {
                -- Formatting preferences
                OrganizeImports = true,
                EnableEditorConfigSupport = true,
                NewLine = "\n",
                UseTabs = false,
                TabSize = 4,
                IndentationSize = 4,
            },
            MsBuild = {
                -- MSBuild options
                LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
                -- Enable code lens
                EnableAnalyzersSupport = true,
                EnableImportCompletion = true,
                EnableDecompilationSupport = true,
                DocumentationProvider = "xmldoc",
            },
            Sdk = {
                -- Include prereleases in search
                IncludePrereleases = false,
            },
            -- InlayHints configuration
            InlayHints = {
                Enabled = true,
                EnableForParameters = true,
                ForLiteralParameters = true,
                ForIndexerParameters = true,
                ForObjectCreationParameters = true,
                ForOtherParameters = true,
                SuppressForParametersThatDifferOnlyBySuffix = false,
                SuppressForParametersThatMatchMethodIntent = false,
                SuppressForParametersThatMatchArgumentName = false,
                EnableForTypes = true,
                ForImplicitVariableTypes = true,
                ForLambdaParameterTypes = true,
                ForImplicitObjectCreation = true,
            },
            -- Code analysis
            AnalyzeOpenDocumentsOnly = false,
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting
            format.setup(client, bufnr, format_opts)
            
            -- Add auto-format and organize usings on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Organize usings first
                    vim.lsp.buf.code_action({
                        context = {
                            only = { "source.organizeImports" }
                        },
                        apply = true,
                    })
                    
                    -- Then format
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 8000,
                        async = false
                    })
                end
            })

            -- Set up additional C#-specific commands
            vim.api.nvim_buf_create_user_command(bufnr, 'CSharpFixUsings', function()
                vim.lsp.buf.code_action({
                    context = {
                        only = { "source.organizeImports", "source.removeUnusedImports" }
                    },
                    apply = true,
                })
            end, { desc = 'Fix and organize C# usings' })

            vim.api.nvim_buf_create_user_command(bufnr, 'CSharpReloadProject', function()
                vim.lsp.buf.execute_command({
                    command = "o#/reloadproject",
                    arguments = { vim.uri_from_bufnr(bufnr) }
                })
            end, { desc = 'Reload C# project' })
        end,
        -- Additional initialization options
        init_options = {
            AutomaticWorkspaceInit = true,
        },
    })
end

return M
