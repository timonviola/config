-- rustaceannvim does not need config from lsp.lua
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
    },
  },
})

local bufnr = vim.api.nvim_get_current_buf()
local opts = { silent = true, buffer = bufnr }

vim.keymap.set("n", "[d", function()
  vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
end, opts)
vim.keymap.set("n", "]d", function()
  vim.cmd.RustLsp("renderDiagnostic") -- defaults to 'cycle'
end, opts)
vim.keymap.set("n", "<leader>d", function()
  vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, opts)

vim.keymap.set("n", "<leader>a", function()
  vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, opts)
vim.keymap.set(
  "n",
  "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({ "hover", "actions" })
  end,
  opts
)
