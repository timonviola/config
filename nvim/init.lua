-- All my personal remaps are in 'timon'
require("timon")

-- Lazy.nvim bootstrapping
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { { import = "plugins" } },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true, notify = false },
})

-- After setup
-- my custom remaps for plugins (e.g. telescope), vim native remaps are under
-- 'timon'
require("myremaps")
-- sync colorscheme with wezterm
require("wezterm_colorscheme_sync").setup()
-- This is a bit wonky here, but I need to customize a littlebit how vim looks
-- The autogroups execute for each colorscheme change and after Lazy is done.
local function apply_custom_highlights()
    -- spot the cursor line
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#FF8C00", ctermbg = 208 })
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
