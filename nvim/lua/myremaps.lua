-- some more remaps (e.g. telescop/lsp specific) are scattered in other places
local telescope = require("telescope")
-- remaps
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
-- find files
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files(
    themes.get_ivy()
    -- {layout_strategy = 'vertical', layout_config={height=0.5}}
  )
end)
-- find git
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
-- find string
vim.keymap.set("n", "<leader>fs", function()
  builtin.grep_string({ search = vim.fn.input("Grep 🔍> ") })
end)
-- find resume
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume telescope search" })

vim.keymap.set("n", "<leader>lg", function()
  builtin.live_grep({ layout_strategy = "vertical" })
end)

vim.keymap.set("n", "<leader>mc", telescope.extensions.metals.commands)

--map("n", "gds", require("telescope.builtin").lsp_document_symbols)
--map("n", "gws", require("telescope.builtin").lsp_dynamic_workspace_symbols)

-- select color
vim.keymap.set("n", "<leader>sc", builtin.colorscheme)
-- show definition
vim.keymap.set("n", "<leader>sd", builtin.lsp_definitions)

-- highlight

vim.keymap.set("n", "<leader><leader>hl", vim.show_pos)
