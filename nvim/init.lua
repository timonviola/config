-- define keymaps, leader etc.
require("timon")

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

-- require("lazy").setup('plugins')
require("lazy").setup({
    spec = {
        -- import your plugins
        { { import = "plugins" }, { import = "plugins.lsp" } },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})

--vim.api.nvim_set_hl(0, 'NormalNC', { fg = '#6b6d8f' })
--vim.api.nvim_set_hl(0, 'NormalNC', { fg = '#36374d' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#36374d' })
local nvim_filename = vim.fn.stdpath("state") .. "/colorscheme"
-- local filename = "/Users/timon/.config/nvim/colorscheme"
assert(type(nvim_filename) == "string")
local file = io.open(nvim_filename, "r")
assert(file)
local colorscheme = file:read("*l")
vim.notify(colorscheme, vim.log.levels.INFO)
file:close()
vim.cmd("colorscheme " .. colorscheme)

-- Currently disable my statusline to try https://github.com/nvim-lualine/lualine.nvim
-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#03fc7b' })
-- require('timon.statusline').setup()
require('timon.wezterm_colorscheme_sync').setup()
