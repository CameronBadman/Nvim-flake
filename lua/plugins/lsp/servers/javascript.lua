local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local keymaps = require('lua.plugins.lsp.keymaps') -- Assuming you have keymaps setup
local M = {}

function M.setup()
    -- TypeScript/JavaScript Language Server (ts_ls)
    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            keymaps.set_keymaps(client, bufnr)

            -- Format on save (optional)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- "none" | "literals" | "all"
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
                suggest = {
                    completeFunctionCalls = true, -- Complete function calls with parentheses
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- "none" | "literals" | "all"
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
                suggest = {
                    completeFunctionCalls = true, -- Complete function calls with parentheses
                },
            },
        },
    })

    -- ESLint Language Server
    lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            keymaps.set_keymaps(client, bufnr)
        end,
        settings = {
            eslint = {
                codeAction = {
                    disableRuleComment = {
                        enable = true,
                        location = "separateLine", -- "separateLine" | "sameLine"
                    },
                    showDocumentation = {
                        enable = true,
                    },
                },
                format = true, -- Enable ESLint as a formatter
                lintTask = {
                    enable = true,
                },
                onIgnoredFiles = "off", -- "off" | "warn" | "error"
                packageManager = "npm", -- "npm" | "yarn" | "pnpm"
                quiet = false,
                rulesCustomizations = {},
                run = "onType", -- "onType" | "onSave"
                useESLintClass = false,
                validate = "on", -- "on" | "off"
                workingDirectory = {
                    mode = "auto", -- "auto" | "location"
                },
            },
        },
    })
end

return M
