vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
        },
    },
})
