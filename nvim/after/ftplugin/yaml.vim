
"-- yaml indentation
"local mygroup = vim.api.nvim_create_augroup('vimrc', { clear = true })
"vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
"  pattern = '*.yaml',
"  group = mygroup,
"  command = 'setlocal ts=2 sts=2 sw=2 expandtab',
"})
"
setlocal expandtab
setlocal smarttab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal list lcs+=space:·
