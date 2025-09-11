-- Copied from: https://github.com/VonHeikemen/nvim-starter/blob/xx-user-plugins/lua/user/statusline.lua
-- and simplified a bit
local M = {}
local state = {}

local mode_higroups = {
    ['NORMAL'] = 'UserStatusMode_NORMAL',
    ['VISUAL'] = 'UserStatusMode_VISUAL',
    ['V-BLOCK'] = 'UserStatusMode_V_BLOCK',
    ['V-LINE'] = 'UserStatusMode_V_LINE',
    ['INSERT'] = 'UserStatusMode_INSERT',
    ['COMMAND'] = 'UserStatusMode_COMMAND',
}

-- mode_map copied from:
-- https://github.com/nvim-lualine/lualine.nvim/blob/5113cdb32f9d9588a2b56de6d1df6e33b06a554a/lua/lualine/utils/mode.lua
local mode_map = {
    ['n']     = 'NORMAL',
    ['no']    = 'O-PENDING',
    ['nov']   = 'O-PENDING',
    ['noV']   = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI']   = 'NORMAL',
    ['niR']   = 'NORMAL',
    ['niV']   = 'NORMAL',
    ['nt']    = 'NORMAL',
    ['v']     = 'VISUAL',
    ['vs']    = 'VISUAL',
    ['V']     = 'V-LINE',
    ['Vs']    = 'V-LINE',
    ['\22']   = 'V-BLOCK',
    ['\22s']  = 'V-BLOCK',
    ['s']     = 'SELECT',
    ['S']     = 'S-LINE',
    ['\19']   = 'S-BLOCK',
    ['i']     = 'INSERT',
    ['ic']    = 'INSERT',
    ['ix']    = 'INSERT',
    ['R']     = 'REPLACE',
    ['Rc']    = 'REPLACE',
    ['Rx']    = 'REPLACE',
    ['Rv']    = 'V-REPLACE',
    ['Rvc']   = 'V-REPLACE',
    ['Rvx']   = 'V-REPLACE',
    ['c']     = 'COMMAND',
    ['cv']    = 'EX',
    ['ce']    = 'EX',
    ['r']     = 'REPLACE',
    ['rm']    = 'MORE',
    ['r?']    = 'CONFIRM',
    ['!']     = 'SHELL',
    ['t']     = 'TERMINAL',
}

local fmt = string.format
local hi_pattern = '%%#%s#%s%%*'

function _G._statusline_component(name)
    return state[name]()
end

state.mode_group = mode_higroups['NORMAL']

function state.mode()
    local mode = vim.api.nvim_get_mode().mode
    local mode_name = mode_map[mode]
    local text = mode_name

    local higroup = mode_higroups[mode_name]

    if higroup then
        state.mode_group = higroup

        return fmt(hi_pattern, higroup, text)
    end

    state.mode_group = 'UserStatusMode_DEFAULT'
    text = fmt(' %s ', mode_name)
    return fmt(hi_pattern, state.mode_group, text)
end

function state.position()
    return fmt(hi_pattern, state.mode_group, ' %3l:%-2c ')
end

state.percent = fmt(hi_pattern, 'UserStatusBlock', ' %2p%% ')

state.full_status = {
    '%{%v:lua._statusline_component("mode")%} ',
    '%m',
    '%t',
    '%r',
    '%m',
    '%=',
    '%{&filetype} ',
    state.percent,
    '%{%v:lua._statusline_component("position")%}'
}

state.short_status = {
    state.full_status[1],
    '%=',
    state.percent,
    state.full_status[8]
}

state.inactive_status = {
    ' %t',
    '%r',
    '%m',
    '%=',
    '%{&filetype} |',
    ' %2p%% | ',
    '%3l:%-2c ',
}

function M.setup()
    local augroup = vim.api.nvim_create_augroup('statusline_cmds', { clear = true })
    local autocmd = vim.api.nvim_create_autocmd
    vim.opt.showmode = false

    local pattern = M.get_status('full')
    if pattern then
        vim.o.statusline = pattern
    end

    local lsp_attach_event = 'LspAttach'
    local lsp_attach_pattern

    if vim.lsp.start == nil then
        lsp_attach_event = 'User'
        lsp_attach_pattern = 'LspAttached'
    end

    autocmd(lsp_attach_event, {
        pattern = lsp_attach_pattern,
        group = augroup,
        desc = 'Show diagnostic sign',
        callback = function()
            vim.b.lsp_attached = 1
            state.show_diagnostic = true
        end
    })

    --    Apply coloring on colorscheme change
    --    autocmd('ColorScheme', {
    --        group = augroup,
    --        desc = 'Apply statusline highlights',
    --        callback = apply_hl
    --    })
    autocmd('FileType', {
        group = augroup,
        pattern = { 'netrw' },
        desc = 'Apply short statusline',
        callback = function()
            vim.w.status_style = 'short'
            vim.wo.statusline = M.get_status('short')
        end
    })
    autocmd('InsertEnter', {
        group = augroup,
        desc = 'Clear message area',
        command = "echo ''"
    })
    autocmd('WinEnter', {
        group = augroup,
        desc = 'Change statusline',
        callback = function()
            local winconfig = vim.api.nvim_win_get_config(0)
            if winconfig.relative ~= '' then
                return
            end

            local style = vim.w.status_style
            if style == nil then
                style = 'full'
                vim.w.status_style = style
            end

            vim.wo.statusline = M.get_status(style)

            local winnr = vim.fn.winnr('#')
            if winnr == 0 then
                return
            end

            local curwin = vim.api.nvim_get_current_win()
            local winid = vim.fn.win_getid(winnr)
            if winid == 0 or winid == curwin then
                return
            end

            if vim.api.nvim_win_is_valid(winid) then
                vim.wo[winid].statusline = M.get_status('inactive')
            end
        end
    })
end

function M.get_status(name)
    return table.concat(state[fmt('%s_status', name)], '')
end

function M.apply(name)
    vim.o.statusline = M.get_status(name)
end

function M.higroups()
    local res = vim.deepcopy(mode_higroups)
    res['DEFAULT'] = 'UserStatusMode_DEFAULT'
    res['STATUS-BLOCK'] = 'UserStatusBlock'
    return res
end

return M
