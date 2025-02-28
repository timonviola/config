--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

-- Check this + NVIM integration: https://github.com/joshmedeski/dotfiles/blob/main/.config/wezterm/utils/keys.lua#L29
-- TODO: Check this for more https://alexplescan.com/posts/2024/08/10/wezterm/


-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

--- Return True if HOME looks like as on Linux.
local function is_linux()
    return "/home/timon" == os.getenv("HOME")
end


-- This is where you actually apply your config choices
-- Font
config.font_size = 14
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.harfbuzz_features = {"zero" , "ss01", "cv05"}
config.line_height = 1.0
config.window_decorations = 'RESIZE'

if is_linux() then
    config.font_size = 12
    config.line_height = 1.0
    config.enable_wayland = true
    config.window_decorations = 'RESIZE'
end

config.ssh_domains = wezterm.default_ssh_domains()
for _, dom in ipairs(config.ssh_domains) do
    dom.assume_shell = 'Posix'
end
-- config.freetype_load_target = "Light"
--config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Helios (base16)' -- "Monokai Pro (Gogh)"
-- and finally, return the configuration to wezterm
config.window_background_opacity = 0.95
config.text_background_opacity = 0.3
config.macos_window_background_blur = 30
config.window_padding = {
    left = 20,
    right = 10,
    top = 60,
    bottom = 10,
}
-- General
--config.enable_tab_bar = false
config.native_macos_fullscreen_mode = false
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.debug_key_events = true
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode,
    },
    {
        -- Work in progress
        key = 'e',
        mods = 'LEADER',
        action = wezterm.action_callback(function(window, pane)
            -- We're going to dynamically construct the list and then
            -- show it.  Here we're just showing some numbers but you
            -- could read or compute data from other sources


            local domains = wezterm.default_ssh_domains()
            local choices = {}
            for _, dom in ipairs(domains) do
                table.insert(choices, { label = tostring(dom.name) })
            end

            window:perform_action(
                act.InputSelector {
                    action = wezterm.action_callback(function(window, pane, id, label)
                        if not id and not label then
                            wezterm.log_info 'cancelled'
                        else
                            wezterm.log_info('you selected ', id, label)
                            -- Since we didn't set an id in this example, we're
                            -- sending the label
                            wezterm.mux.spawn_window { domain = { DomainName = label } }
                        end
                    end),
                    title = 'I am title',
                    choices = choices,
                    alphabet = '123456789',
                    description = 'Write the number you want to choose or press / to search.',
                },
                pane
            )
        end),
    },
    {
        key = 'z',
        mods = 'LEADER',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = false },
    },
    {
        key = '%',
        mods = 'LEADER | SHIFT',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '"',
        mods = 'LEADER | SHIFT',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down'),
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up'),
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right'),
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left'),
    },
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    -- Sessonizer-ish
    --    {
    --        key = 's',
    --        mods = 'LEADER',
    --        action = wezterm.action.SpawnCommandInNewTab {
    --            args = { 'switch' },
    --        },
    --    },
    -- ssh-tab
    -- note: maybe I should use the same command for switch and 'ssh_spawn"
    --    {
    --        -- g as "go"
    --        key = 'g',
    --        mods = 'LEADER',
    --        action = wezterm.action.SpawnCommandInNewTab {
    --          args = { 'ssh_spawn' },
    --        },
    --    },
    -- Rename tab
    {
        key = 'r',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'New tab name:',
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    -- Ref: https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html
    {
        key = 'a',
        mods = 'LEADER',
        action = act.AttachDomain 'unix',
    },

    -- Detach from muxer
    {
        key = 'd',
        mods = 'LEADER',
        action = act.DetachDomain { DomainName = 'unix' },
    },
    {
        key = '$',
        mods = 'LEADER|SHIFT',
        action = act.PromptInputLine {
            description = 'Enter new name for session',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        wezterm.mux.rename_workspace(
                            window:mux_window():get_workspace(),
                            line
                        )
                    end
                end
            ),
        },
    },
    {
        key = 's',
        mods = 'LEADER',
        action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
    },

    {
        key = 's',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "save_session" }),
    },
    {
        key = 'L',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "load_session" }),
    },
    {
        key = 'R',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "restore_session" }),
    },
}

--TODO: https://github.com/wez/wezterm/discussions/4796#discussioncomment-8354795
-- More robust sessionizer functionality
--local fd = "/home/timon/.local/bin/fd"
--local rootPath = "/home/timon/Documents"

local function segments_for_right_status(window)
    return {
        window:active_workspace(),
        wezterm.strftime('%a %b %-d %H:%M'),
        wezterm.hostname(),
    }
end

wezterm.on('update-status', function(window, _)
    local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
    local segments = segments_for_right_status(window)

    local color_scheme = window:effective_config().resolved_palette
    -- Note the use of wezterm.color.parse here, this returns
    -- a Color object, which comes with functionality for lightening
    -- or darkening the colour (amongst other things).
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    -- Each powerline segment is going to be coloured progressively
    -- darker/lighter depending on whether we're on a dark/light colour
    -- scheme. Let's establish the "from" and "to" bounds of our gradient.
    local gradient_to, gradient_from = bg, bg
    if true then
        gradient_from = gradient_to:lighten(0.2)
    else
        gradient_from = gradient_to:darken(0.2)
    end

    -- Yes, WezTerm supports creating gradients, because why not?! Although
    -- they'd usually be used for setting high fidelity gradients on your terminal's
    -- background, we'll use them here to give us a sample of the powerline segment
    -- colours we need.
    local gradient = wezterm.color.gradient(
        {
            orientation = 'Horizontal',
            colors = { gradient_from, gradient_to },
        },
        #segments -- only gives us as many colours as we have segments.
    )

    -- We'll build up the elements to send to wezterm.format in this table.
    local elements = {}

    for i, seg in ipairs(segments) do
        local is_first = i == 1

        if is_first then
            table.insert(elements, { Background = { Color = 'none' } })
        end
        table.insert(elements, { Foreground = { Color = gradient[i] } })
        table.insert(elements, { Text = SOLID_LEFT_ARROW })

        table.insert(elements, { Foreground = { Color = fg } })
        table.insert(elements, { Background = { Color = gradient[i] } })
        table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end

    window:set_right_status(wezterm.format(elements))
end)

-- Tab bar settings
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local color_scheme = tabs.window:effective_config().resolved_palette
        -- Note the use of wezterm.color.parse here, this returns
        -- a Color object, which comes with functionality for lightening
        -- or darkening the colour (amongst other things).
        local bg = wezterm.color.parse(color_scheme.background)
        local fg = color_scheme.foreground
        local edge_background = '#24283b'
        local background = bg
        local foreground = fg

        if tab.is_active then
            background = '#24283b'
            foreground = '#c3e88d'
        elseif hover then
            background = color_scheme.selection_bg
            foreground = color_scheme.selection_fg
        end

        local edge_foreground = background

        local title = tab_title(tab)

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        title = wezterm.truncate_right(title, max_width - 2)

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = ' |' },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = ' |' },
        }
    end
)
-- Sessions
config.unix_domains = {
    {
        name = 'unix',
    },
}

-- Wezterm sessionizer
local session_manager = require 'wezterm-session-manager/session-manager'
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- Change opacity when I click away
--wezterm.on('window-focus-changed', function(window, pane)
--    local overrides = window:get_config_overrides() or {}
--
--    if window:is_focused() then
--        overrides.window_background_opacity = 0.9
--    else
--        overrides.window_background_opacity = 1
--    end
--
--    window:set_config_overrides(overrides)
--end)


return config
