-- lua/plugins/lsp/servers/clangd.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- C-specific format settings for CSSE2310/CSSE7231 style (WebKit-based)
    local format_opts = {
        async = false,
        format_on_save = true,
        timeout_ms = 5000,
        formatting_options = {
            indent_size = 4,
            tab_width = 4,
            use_tabs = false,
        }
    }

    -- Create .clang-format configuration for WebKit style with CSSE2310/CSSE7231 modifications
    local function ensure_clang_format_config()
        local config_path = vim.fn.getcwd() .. '/.clang-format'
        if vim.fn.filereadable(config_path) == 0 then
            local f = io.open(config_path, 'w')
            if f then
                f:write([[
# CSSE2310/CSSE7231 style configuration (based on WebKit)
BasedOnStyle: WebKit
Language: Cpp
IndentWidth: 4
TabWidth: 4
UseTab: Never
ColumnLimit: 80  # Function and line length constraint
AlignAfterOpenBracket: Align
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
AllowShortBlocksOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: None
AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
BreakBeforeBraces: Attach
SpaceAfterCStyleCast: false
SpaceBeforeParens: ControlStatements
SpaceInEmptyParentheses: false
SpacesInCStyleCastParentheses: false
SpacesInParentheses: false
SpacesInSquareBrackets: false
IndentCaseLabels: true
PointerAlignment: Right
SortIncludes: false
]])
                f:close()
                vim.notify("Created .clang-format file with CSSE2310/CSSE7231 style", vim.log.levels.INFO)
            end
        end
    end

    -- Create .clang-tidy configuration for additional requirements
    local function ensure_clang_tidy_config()
        local config_path = vim.fn.getcwd() .. '/.clang-tidy'
        if vim.fn.filereadable(config_path) == 0 then
            local f = io.open(config_path, 'w')
            if f then
                f:write([[
# CSSE2310/CSSE7231 additional requirements
Checks: 'readability-*,bugprone-*,cert-*,clang-analyzer-*,misc-*,-misc-unused-parameters,performance-*,portability-*'
WarningsAsErrors: ''
HeaderFilterRegex: '.*'
FormatStyle: file
CheckOptions:
  - key: readability-identifier-naming.FunctionCase
    value: camelBack
  - key: readability-identifier-naming.ConstantCase
    value: UPPER_CASE
  - key: readability-identifier-naming.VariableCase
    value: camelBack
  - key: readability-identifier-naming.ParameterCase
    value: camelBack
  - key: readability-function-size.LineThreshold
    value: 80
  - key: readability-function-size.StatementThreshold
    value: 50
]])
                f:close()
                vim.notify("Created .clang-tidy file with CSSE2310/CSSE7231 requirements", vim.log.levels.INFO)
            end
        end
    end

    lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=WebKit",
        },
        filetypes = { "c", "h" },
        root_dir = function(fname)
            return lspconfig.util.root_pattern("compile_commands.json", ".git")(fname) or
                   vim.fn.getcwd()
        end,
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with C-specific options
            format.setup(client, bufnr, format_opts)
            
            -- Ensure style configuration files exist
            vim.defer_fn(function()
                ensure_clang_format_config()
                ensure_clang_tidy_config()
            end, 1000)
            
            -- Add formatting on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Format the buffer
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 5000
                    })
                end
            })
            
            -- Show diagnostics in hover
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    local opts = {
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, opts)
                end
            })
        end,
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true
        }
    })
    
end

return M
