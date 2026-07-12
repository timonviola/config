-- some more remaps (e.g. telescop/lsp specific) are scattered in other places
local map = require("timon.keymap")
local telescope = require("telescope")
-- remaps
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
-- find files
map.nnoremap("<leader>ff", function()
  builtin.find_files(
    themes.get_ivy()
    -- {layout_strategy = 'vertical', layout_config={height=0.5}}
  )
end)
-- find git
map.nnoremap("<leader>fg", builtin.git_files, {})
-- find string
map.nnoremap("<leader>fs", function()
  builtin.grep_string({ search = vim.fn.input("Grep 🔍> ") })
end)
-- find resume
map.nnoremap("<leader>fr", builtin.resume, { desc = "Resume telescope search" })
map.nnoremap("<leader>lg", function()
  builtin.live_grep({ layout_strategy = "vertical" })
end)
map.nnoremap("<leader>mc", telescope.extensions.metals.commands)
map.nnoremap("gds", require("telescope.builtin").lsp_document_symbols)
map.nnoremap("gws", require("telescope.builtin").lsp_dynamic_workspace_symbols)
-- select color
map.nnoremap("<leader>sc", builtin.colorscheme)
-- show definition
map.nnoremap("<leader>sd", builtin.lsp_definitions)

-- highlight
map.nnoremap("<leader><leader>hl", vim.show_pos)
map.nnoremap("<leader>pv", "<cmd>30Ex<CR>")
map.nnoremap("<leader>pV", "<cmd>30Vex<CR>")
-- really cool visual line move
map.vnoremap("J", ":m '>+1<CR>gv=gv")
map.vnoremap("K", ":m '<-2<CR>gv=gv")
-- half page jumps
map.nnoremap("<C-k>", "<C-u>zz")
map.nnoremap("<C-j>", "<C-d>zz")
-- keep cursor in middle while search terms
map.nnoremap("n", "nzzzv")
map.nnoremap("N", "Nzzzv")
-- keep void buffer after pasting over
map.xnoremap("<leader>p", '"_dP')
-- Navigate between quick fix items
map.nnoremap("<leader>cn", "<cmd>cnext<CR>zz", { desc = "Forward qfixlist" })
map.nnoremap("<leader>cN", "<cmd>cprev<CR>zz", { desc = "Backward qfixlist" })
-- easy esc
map.inoremap("jj", "<ESC>")
