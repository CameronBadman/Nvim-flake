-- lua/plugins/lsp/servers/rust.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- Rust-specific format settings
    local format_opts = {
        async = false,  -- Rust formatting with rustfmt is fast
        format_on_save = true,
        timeout_ms = 5000,
        formatting_options = {
            rustfmt = true,
            edition = "2021",
        }
    }

    lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
        settings = {
            ["rust-analyzer"] = {
                -- Cargo and project settings
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                    buildScripts = {
                        enable = true,
                    },
                },
                -- Procedural macro settings
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["napi-derive"] = { "napi" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
                -- Diagnostics settings
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                    enableExperimental = true,
                    disabled = { "unresolved-proc-macro" },
                    -- Fixed: remapPrefix should be a map, not an array
                    remapPrefix = {},
                    -- Fixed: these should be arrays if you want to specify warning codes
                    warningsAsHint = {},
                    warningsAsInfo = {},
                },
                -- Completion settings
                completion = {
                    addCallArgumentSnippets = true,
                    addCallParenthesis = true,
                    postfix = {
                        enable = true,
                    },
                    autoimport = {
                        enable = true,
                    },
                    privateEditable = {
                        enable = false,
                    },
                },
                -- Inlay hints
                inlayHints = {
                    bindingModeHints = {
                        enable = false,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    closingBraceHints = {
                        enable = true,
                        minLines = 25,
                    },
                    closureReturnTypeHints = {
                        enable = "never",
                    },
                    lifetimeElisionHints = {
                        enable = "never",
                        useParameterNames = false,
                    },
                    maxLength = 25,
                    parameterHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "never",
                    },
                    renderColons = true,
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
                -- Lens settings
                lens = {
                    enable = true,
                    debug = {
                        enable = true,
                    },
                    implementations = {
                        enable = true,
                    },
                    references = {
                        adt = {
                            enable = false,
                        },
                        enumVariant = {
                            enable = false,
                        },
                        method = {
                            enable = false,
                        },
                        trait = {
                            enable = false,
                        },
                    },
                    run = {
                        enable = true,
                    },
                },
                -- Hover settings
                hover = {
                    actions = {
                        enable = true,
                        implementations = {
                            enable = true,
                        },
                        references = {
                            enable = true,
                        },
                        run = {
                            enable = true,
                        },
                        debug = {
                            enable = true,
                        },
                    },
                    documentation = {
                        enable = true,
                    },
                    links = {
                        enable = true,
                    },
                },
                -- Semantic highlighting
                semanticHighlighting = {
                    strings = {
                        enable = true,
                    },
                },
                -- Workspace settings
                workspace = {
                    symbol = {
                        search = {
                            scope = "workspace_and_dependencies",
                            kind = "only_types",
                        },
                    },
                },
                -- Check settings
                check = {
                    command = "clippy",
                    features = "all",
                    extraArgs = { "--no-deps" },
                },
                -- Import settings
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                -- Rustfmt settings
                rustfmt = {
                    extraArgs = {},
                    overrideCommand = nil,
                },
                -- Assist settings
                assist = {
                    importEnforceGranularity = true,
                    importPrefix = "plain",
                },
            }
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with Rust-specific options
            format.setup(client, bufnr, format_opts)
            
            -- Rust-specific keymaps
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', '<leader>rr', '<cmd>RustRunnables<cr>', opts)
            vim.keymap.set('n', '<leader>rd', '<cmd>RustDebuggables<cr>', opts)
            vim.keymap.set('n', '<leader>rt', '<cmd>RustExpandMacro<cr>', opts)
            vim.keymap.set('n', '<leader>rc', '<cmd>RustOpenCargo<cr>', opts)
            vim.keymap.set('n', '<leader>rp', '<cmd>RustParentModule<cr>', opts)
            vim.keymap.set('n', '<leader>rj', '<cmd>RustJoinLines<cr>', opts)
            vim.keymap.set('n', '<leader>rh', '<cmd>RustHoverActions<cr>', opts)
            vim.keymap.set('n', '<leader>rg', '<cmd>RustHoverRange<cr>', opts)
            vim.keymap.set('n', '<leader>re', '<cmd>RustExplainError<cr>', opts)
            vim.keymap.set('n', '<leader>ro', '<cmd>RustOpenExternalDocs<cr>', opts)
            
            -- Auto-format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 5000
                    })
                end
            })
            
            -- Auto-update imports on save (if supported)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    local params = vim.lsp.util.make_range_params()
                    params.context = {only = {"source.organizeImports"}}
                    
                    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
                    if result and result[1] then
                        for _, r in pairs(result[1].result or {}) do
                            if r.edit then
                                vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                            end
                        end
                    end
                end
            })
        end
    })
end

return M
