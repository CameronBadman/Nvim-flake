local M = {}

function M.setup(lsp_zero)
    lsp_zero.configure('gopls', {
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
            gopls = {
                ["ui.diagnostic.staticcheck"] = true,
                experimentalPostfixCompletions = true,
                analyses = {
                    nilness = true,
                    shadow = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                    atomic = true,
                    bools = true,
                    composites = true,
                    copylocks = true,
                    defers = true,
                    errorsas = true,
                    httpresponse = true,
                    ifaceassert = true,
                    loopclosure = true,
                    lostcancel = true,
                    nilfunc = true,
                    printf = true,
                    shift = true,
                    sortslice = true,
                    stdmethods = true,
                    stringintconv = true,
                    structtag = true,
                    tests = true,
                    unmarshal = true,
                    unreachable = true,
                    unsafeptr = true,
                    unusedresult = true,
                },
                codelenses = {
                    gc_details = true,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
                gofumpt = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        }
    })
end

return M
