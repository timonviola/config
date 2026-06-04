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
require('lsp').setup()

-- vim.opt.statusline = [[%!luaeval('require("statusline").setup()')]]

-- my custom remaps for plugins (e.g. telescope), vim native remaps are under
-- 'timon'
require("myremaps")
-- sync colorscheme with wezterm
require("wezterm_colorscheme_sync").setup()


