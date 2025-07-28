local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- Java-specific format settings
    local format_opts = {
        async = false,
        format_on_save = true,
        timeout_ms = 10000,  -- Java can be slow to format
        formatting_options = {
            indent_size = 4,
            tab_size = 4,
            use_tabs = false,
        }
    }

    lspconfig.jdtls.setup({
        capabilities = capabilities,
        cmd = { 
            "jdt-language-server",
            "-configuration", vim.fn.expand("~/.cache/jdtls/config"),
            "-data", vim.fn.expand("~/.cache/jdtls/workspace")
        },
        filetypes = { "java" },
        root_dir = util.root_pattern("pom.xml", "build.gradle", "build.gradle.kts", ".git", "mvnw", "gradlew"),
        settings = {
            java = {
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                    -- Configure different JVM versions if needed
                    runtimes = {
                        {
                            name = "JavaSE-17",
                            path = "/path/to/java-17",  -- Update with actual path
                        },
                        {
                            name = "JavaSE-21",
                            path = "/path/to/java-21",  -- Update with actual path
                        }
                    }
                },
                maven = {
                    downloadSources = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                referencesCodeLens = {
                    enabled = true,
                },
                references = {
                    includeDecompiledSources = true,
                },
                inlayHints = {
                    parameterNames = {
                        enabled = "all", -- literals, all, none
                    },
                },
                format = {
                    enabled = true,
                    settings = {
                        url = vim.fn.stdpath("config") .. "/lang-configs/intellij-java-google-style.xml",
                        profile = "GoogleStyle",
                    },
                },
                signatureHelp = { enabled = true },
                completion = {
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*"
                    },
                },
                contentProvider = { preferred = "fernflower" },
                extendedClientCapabilities = {
                    progressReportsSupport = true,
                    classFileContentsSupport = true,
                    generateConstructorsPromptSupport = true,
                    hashCodeEqualsPromptSupport = true,
                    advancedExtractRefactoringSupport = true,
                    advancedOrganizeImportsSupport = true,
                    generateDelegateMethodsPromptSupport = true,
                    moveRefactoringSupport = true,
                    overrideMethodsPromptSupport = true,
                    inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
            }
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting
            format.setup(client, bufnr, format_opts)
            
            -- Add auto-format and organize imports on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Organize imports
                    local params = vim.lsp.util.make_range_params()
                    params.context = {only = {"source.organizeImports"}}
                    
                    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 5000)
                    if result and result[1] then
                        for _, r in pairs(result[1].result or {}) do
                            if r.edit then
                                vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                            end
                        end
                    end
                    
                    -- Then format
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 10000
                    })
                end
            })

            -- Java-specific commands
            vim.api.nvim_buf_create_user_command(bufnr, 'JavaOrganizeImports', function()
                vim.lsp.buf.code_action({
                    context = {
                        only = { "source.organizeImports" }
                    },
                    apply = true,
                })
            end, { desc = 'Organize Java imports' })

            vim.api.nvim_buf_create_user_command(bufnr, 'JavaCleanWorkspace', function()
                vim.lsp.buf.execute_command({
                    command = "java.clean.workspace"
                })
            end, { desc = 'Clean Java workspace' })

            vim.api.nvim_buf_create_user_command(bufnr, 'JavaUpdateProject', function()
                vim.lsp.buf.execute_command({
                    command = "java.project.refreshProjects"
                })
            end, { desc = 'Refresh Java projects' })
        end,
        init_options = {
            bundles = {},
            workspaceFolders = { vim.uri_from_fname(vim.fn.getcwd()) },
        },
    })
end

return M
