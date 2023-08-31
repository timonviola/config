local nnoremap = require("timon.keymap").nnoremap

nnoremap("<leader>pv", "<cmd>Ex<CR>")

-- really cool visual line move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- make cursor stay after line op
vim.keymap.set("n", "J", "mzJ`z")
-- half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-j>", "<C-j>zz")
-- keep cursor in meadle while search terms
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- keep void buffer after pasting over
vim.keymap.set("x", "<leader>p", "\"_dP")
