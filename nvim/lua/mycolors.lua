-- Some additional color tweaking - not pretty, but visible
--
-- The autogroups execute for each colorscheme change and after Lazy is done.
local function apply_custom_highlights()
  -- spot the cursor line
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#FF8C00", ctermbg = 208 })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#FF8C00", ctermbg = 208 })
  -- spot the splits
  vim.api.nvim_set_hl(0, "WinSeparator", { link = "Comment" })
end
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_custom_highlights,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = apply_custom_highlights,
})
