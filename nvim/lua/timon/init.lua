vim.g.loaded_matchparen = 1

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local opt = vim.opt

-- Ignore compiled files
opt.wildignore = "__pycache__"
vim.opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*" })
vim.opt.wildignore:append({ "Cargo.lock", "Cargo.Bazel.lock" })

-- Cursorline highlighting control
--  Only have it on in the active buffer
opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

opt.belloff = "all" -- Just turn the dang bell off
opt.clipboard = "unnamedplus"
opt.foldlevel = 0
opt.foldmethod = "marker"
opt.inccommand = "split"
opt.modelines = 1
opt.mouse = "a"
opt.shada = { "!", "'1000", "<50", "s10", "h" }
opt.swapfile = false                                     -- Living on the edge
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#326941" }) -- Statusline is green
vim.cmd("filetype plugin on")                            -- filetype specific settings in /after/ftp
-- USE NVIM-TREE instead
vim.g.loaded_netrw = 1                                   -- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.opt.colorcolumn = "80"
vim.opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
vim.opt.expandtab = true
vim.opt.guicursor = ""
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.spell = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.winborder = "rounded" -- border for floating windows
vim.opt.wrap = false
