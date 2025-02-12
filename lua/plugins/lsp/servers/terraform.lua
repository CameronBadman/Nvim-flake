local M = {}

local function setup_diagnostics()
    local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " "
    }
    
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config({
        virtual_text = {
            prefix = '●',
            severity_sort = true,
        },
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
        float = {
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })
end

local function setup_handlers()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
        }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
        }
    )
end

local function setup_terraform_highlights(bufnr)
    local highlights = {
        ['@lsp.type.variable.terraform'] = 'Variable',
        ['@lsp.type.string.terraform'] = 'String',
        ['@lsp.type.keyword.terraform'] = 'Keyword',
        ['@lsp.type.number.terraform'] = 'Number',
        ['@lsp.type.operator.terraform'] = 'Operator',
        ['@lsp.type.parameter.terraform'] = 'Parameter',
        ['@lsp.type.property.terraform'] = 'TSProperty',
        ['@lsp.type.function.terraform'] = 'Function'
    }

    for group, link in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, { link = link })
    end
end

function M.setup()
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')
    local keymaps = require('lua.plugins.lsp.keymaps')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    setup_diagnostics()
    setup_handlers()

    lspconfig.terraformls.setup({
        capabilities = capabilities,
        filetypes = { "terraform", "tf", "terraform-vars", "hcl" },
        root_dir = util.root_pattern(
            ".terraform",
            "*.tf",
            "*.tfvars",
            ".git"
        ),
        settings = {
            terraform = {
                format = {
                    enable = true,
                    ignoreAttributeErrors = false
                },
                experimentalFeatures = {
                    validateOnSave = true,
                    prefillRequiredFields = true
                }
            }
        },
        on_attach = function(client, bufnr)
            -- Setup buffer-local keymaps, highlighting, etc.
            keymaps.set_keymaps(client, bufnr)
            setup_terraform_highlights(bufnr)

            -- Enable formatting on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end
            })

            -- Enable inlay hints if available
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end

            -- Setup document highlight (highlight references)
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = "lsp_document_highlight",
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    group = "lsp_document_highlight",
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end
    })
end

return M
