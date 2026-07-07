local function tail_split()
  vim.cmd("15split")
  vim.cmd("terminal tail -f " .. vim.fn.shellescape("/Users/TIVI/.cache/nvim/nvim-metals/nvim-metals.log"))
  vim.bo.filetype = "log"
end

vim.api.nvim_create_user_command("TailMetalsLog", tail_split, {})
