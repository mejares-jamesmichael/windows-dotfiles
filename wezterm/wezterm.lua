local wezterm = require("wezterm")
local act = wezterm.action

local pwsh_path =
	"C:\\Program Files\\PowerShell\\7\\pwsh.exe"

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { pwsh_path, "-NoProfileLoadTime", "-NoLogo" }
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- UI
config.window_decorations = "RESIZE"
config.color_scheme = "tokyonight"
config.window_background_opacity = 0.95
-- config.win32_system_backdrop = "Acrylic"
-- config.front_end = "WebGpu"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.inactive_pane_hsb = { -- Dim inactive panes
	saturation = 0.8,
	brightness = 0.6,
}

config.quick_select_patterns = {
	'https?://\\S+',
	'\\b\\w+@[\\w.-]+\\b',
}

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 10

-- Cursor
config.default_cursor_style = "SteadyBar"
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- Keybindings
-- Leader = CTRL+SPACE (like <leader> in nvim - dedicated, no terminal conflicts)
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Passthrough CTRL+SPACE to terminal if needed (double-tap)
	{ key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },

	-- Command palette & copy mode (nvim-like)
	{ key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },         -- <leader>v = visual/copy

	-- Clipboard
	{ key = "y", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "p", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	-- Search (like nvim /)
	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },

	-- Pane splits (like nvim :split / :vsplit)
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Pane navigation (hjkl like nvim)
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Also support CTRL+hjkl for faster pane switching without leader
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },

	-- Pane zoom toggle (like nvim <C-w>z)
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Close pane (like nvim :q)
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Rotate panes
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Resize mode (like nvim <C-w> resize submode)
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Tab management
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "H", mods = "LEADER", action = act.ActivateTabRelative(-1) },    -- like nvim H (prev)
	{ key = "L", mods = "LEADER", action = act.ActivateTabRelative(1) },     -- like nvim L (next)
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Rename Tab:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Workspace fuzzy finder
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- <leader>1-9 to jump to tab (like nvim buffer numbers)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	-- hjkl resize (like nvim <C-w> +/-/</>)
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 2 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 2 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 2 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

wezterm.on("format-window-title", function()
	return "WezTerm"
end)

-- Tab bar (retro style to preserve status bar)
config.use_fancy_tab_bar = false
config.integrated_title_buttons = { "Close" }
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

-- Tokyonight colors
local tab_bg       = "#1a1b26"
local active_bg    = "#7aa2f7"
local active_fg    = "#1a1b26"
local inactive_bg  = "#24283b"
local inactive_fg  = "#565f89"
local hover_bg     = "#3b4261"
local hover_fg     = "#a9b1d6"

config.colors = {
	tab_bar = {
		background = tab_bg,
		active_tab = { bg_color = active_bg, fg_color = active_fg, intensity = "Bold" },
		inactive_tab = { bg_color = inactive_bg, fg_color = inactive_fg },
		inactive_tab_hover = { bg_color = hover_bg, fg_color = hover_fg, italic = true },
		new_tab = { bg_color = inactive_bg, fg_color = inactive_fg },
		new_tab_hover = { bg_color = hover_bg, fg_color = hover_fg, italic = true },
	},
}

-- Powerline arrow separators via format-tab-title event
local arrow_right = wezterm.nerdfonts.pl_right_hard_divider -- 
local arrow_left = wezterm.nerdfonts.pl_left_hard_divider -- 

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local bg = inactive_bg
	local fg = inactive_fg
	local edge_bg = tab_bg

	if tab.is_active then
		bg = active_bg
		fg = active_fg
	elseif hover then
		bg = hover_bg
		fg = hover_fg
	end

	local title = tab.active_pane.title
	if tab.tab_title and #tab.tab_title > 0 then
		title = tab.tab_title
	end
	title = " " .. title .. " "

	return {
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = arrow_right },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = arrow_left },
	}
end)

wezterm.on("update-status", function(window, pane)
	local stat = window:active_workspace()
	local stat_color = "#f7768e"
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = "#bb9af7"
	end

	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			cwd = basename(cwd.file_path)
		else
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""

	local time = wezterm.strftime("%H:%M")
	local date = wezterm.strftime("%a %d %b")

	-- Battery
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local pct = math.floor(b.state_of_charge * 100)
		local icon
		if b.state == "Charging" then
			icon = wezterm.nerdfonts.md_battery_charging
		elseif pct >= 90 then
			icon = wezterm.nerdfonts.md_battery
		elseif pct >= 70 then
			icon = wezterm.nerdfonts.md_battery_80
		elseif pct >= 50 then
			icon = wezterm.nerdfonts.md_battery_60
		elseif pct >= 30 then
			icon = wezterm.nerdfonts.md_battery_40
		elseif pct >= 10 then
			icon = wezterm.nerdfonts.md_battery_20
		else
			icon = wezterm.nerdfonts.md_battery_alert
		end
		bat = icon .. "  " .. pct .. "% "
	end

	-- Left status
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " |" },
	}))

	-- Right status
	local right = {
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Foreground = { Color = "#9ece6a" } },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. date .. "  " .. time },
	}
	if bat ~= "" then
		table.insert(right, "ResetAttributes")
		table.insert(right, { Text = " | " })
		table.insert(right, { Foreground = { Color = "#f7768e" } })
		table.insert(right, { Text = bat })
	end
	table.insert(right, { Text = " " })
	window:set_right_status(wezterm.format(right))
end)

return config
