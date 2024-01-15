-- keybindings to neogen
local neogen = require("neogen")
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>nf", function() neogen.generate({type = "func"}) end, opts)
vim.keymap.set("n", "<Leader>nc", function() neogen.generate({type = "class"}) end, opts)
vim.keymap.set("n", "<Leader>nF", function() neogen.generate({type = "file"}) end, opts)
