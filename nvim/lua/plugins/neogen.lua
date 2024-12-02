return {
    'danymat/neogen',
    config = function()
        local neogen = require("neogen")
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>nf", function() neogen.generate({type = "func"}) end, opts)
        vim.keymap.set("n", "<Leader>nc", function() neogen.generate({type = "class"}) end, opts)
        vim.keymap.set("n", "<Leader>nF", function() neogen.generate({type = "file"}) end, opts)
        -- Could be better to switch pydocstyle to `reStructuredText` to align with PEP 287
        -- this might helps:
        -- https://www.reddit.com/r/neovim/comments/19en47b/treesitter_highlighting_python_docstring/
        -- neogen has support for this "reST"
    end,
}
