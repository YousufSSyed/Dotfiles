-- hyprland.lua (converted from hyprland.conf, Hyprland >= 0.55)

local scripts = "/home/yousuf/.local/share/chezmoi/scripts"
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-----------------
-- KEYBINDINGS --
-----------------

-- Window positioning keybinds
hl.bind("CTRL + SUPER + ALT + G", hl.dsp.exec_cmd("rofimoji"))
hl.bind("CTRL + SUPER + ALT + M", hl.dsp.exec_cmd(scripts .. "/window_resize.fish")) -- Maximize screen
hl.bind("ALT + SHIFT + H", hl.dsp.exec_cmd(scripts .. "/window_resize.fish 1")) -- Left half of screen
hl.bind("ALT + SHIFT + L", hl.dsp.exec_cmd(scripts .. "/window_resize.fish 2")) -- Right half of screen
hl.bind("CTRL + ALT + SHIFT + L", hl.dsp.exec_cmd(scripts .. "/window_resize.fish 3")) -- 2/3 width, right side
hl.bind("CTRL + ALT + SHIFT + H", hl.dsp.exec_cmd(scripts .. "/window_resize.fish 4")) -- 2/3 width, left side
hl.bind("ALT + Tab", hl.dsp.window.cycle_next()) -- NOTE: verify dispatcher name on the wiki

-- App switching keybinds
-- hl.bind("SUPER + ALT + F", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c zen-beta -a zen"))
hl.bind("SUPER + ALT + F", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c firefox -a firefox"))
hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c org.kde.dolphin -a dolphin"))
hl.bind("SUPER + ALT + T", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c kitty -a kitty"))
hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c vesktop -a vesktop"))
hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c neovide -a neovide"))
hl.bind("SUPER + ALT + O", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c obsidian -a obsidian"))
hl.bind(
	"SUPER + ALT + R",
	hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c org.vinegarhq.Sober -a 'flatpak run org.vinegarhq.Sober'")
)
-- hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c eu.betterbird.Betterbird -a 'flatpak run eu.betterbird.Betterbird'"))
-- hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c thudnerbird -a thunderbird"))
hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c mpv -a echo"))
hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd(scripts .. "/window_switch.fish -c cursor -a 'cursor'"))

hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd('grim -c -g "$(slurp $SLURP_ARGS)" - | tesseract - - | wl-copy'))
hl.bind(
	"CTRL + ALT + K",
	hl.dsp.exec_cmd('grimblast save area "/home/yousuf/Downloads/$(date +%Y-%m-%d\\ %I-%M-%S%p) Screenshot.png"')
)
hl.bind(
	"CTRL + ALT + period",
	hl.dsp.exec_cmd('grimblast save screen "/home/yousuf/Downloads/$(date +%Y-%m-%d\\ %I-%M-%S%p) Screenshot.png"')
)
hl.bind("ALT + Tab", hl.dsp.exec_cmd("hyprfloat alttab next"))
hl.bind("SHIFT + ALT + F", hl.dsp.exec_cmd("hyprfloat alttab next"))

hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call launcher toggle"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("kitten quick-access-terminal"))

-- Original had `bind = $mainMod, R, exec, $menu`, but $menu was never defined.
-- Set it and uncomment if you want it:
-- local menu = "hyprlauncher"
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with ALT + LMB/RMB and dragging
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 1%+"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 1%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

----------------------
-- STARTUP PROGRAMS --
----------------------

hl.on("hyprland.start", function()
	-- hl.exec_cmd("hyprshell run")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd(scripts .. "/wallpaper_cycle.fish")
	hl.exec_cmd("qs -c noctalia-shell")
	hl.exec_cmd("sleep 3; uwsm app -- aw-qt")
	-- hl.exec_cmd("uwsm app -- aw-watcher-window-wayland")
	hl.exec_cmd("awww-daemon")
	-- hl.exec_cmd("flatpak run eu.betterbird.Betterbird")
	-- hl.exec_cmd("birdtray")
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprctl setcursor macOS 28")
end)

--------------
-- MONITORS --
--------------

hl.monitor({
	output = "desc:ASUSTek COMPUTER INC XG32UCDS T8LMQV072805",
	mode = "3840x2160@165",
	position = "0x0",
	scale = 1.5,
	bitdepth = 10,
	cm = "dcip3",
})

hl.monitor({
	output = "desc:Microstep MPG321UX OLED 0x01010101",
	mode = "3840x2160@239.99",
	position = "0x0",
	scale = 2,
	bitdepth = 10,
	cm = "dcip3",
})

---------------------------
-- ENVIRONMENT VARIABLES --
---------------------------

-- Note: XCURSOR_SIZE was set twice in the original (28, then 96); the later value wins.
hl.env("XCURSOR_SIZE", "28")
hl.env("XCURSOR_SIZE", "96")
hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("QT_CURSOR_SIZE", "96")
hl.env("HYPRCURSOR_SIZE", "96")

-------------------
-- LOOK AND FEEL --
-------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = { top = 62.5, right = 15, bottom = 15, left = 15 },
		border_size = 0,
		col = {
			active_border = "rgba(255,255,255,0.1)",
			-- active_border = "rgba(0,0,0,0.25)",
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
	},

	decoration = {
		rounding = 6,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 40,
			render_power = 3,
			-- ignore_window = false,
			offset = { 0, 5 },
			scale = 0.99,
			color = "rgba(1a1a1a80)",
		},

		blur = {
			xray = true,
			enabled = true,
			size = 50,
			passes = 3,
			noise = 0,
			vibrancy_darkness = 1,
			vibrancy = 0.75, -- original set 0 then 0.75; the later value wins
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- My custom animations
hl.animation({ leaf = "windows", enabled = true, speed = 1.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "linear", style = "popin 50%" })

-----------
-- RULES --
-----------

hl.window_rule({
	name = "float-everything",
	match = { class = ".*" },
	float = true,
	persistent_size = true,
})

-- The original had two layerrules; the second had a malformed match
-- (`.* ^(noctalia-background)(.*)$`), so they're merged into one rule.
-- Layer rules match on namespace in Lua (the old `class` prop).
hl.layer_rule({
	name = "noctalia-background",
	match = { namespace = "^(noctalia-background)(.*)$" },
	blur = true,
	ignore_alpha = 0.15,
})

-- hl.window_rule({ match = { class = "^(  )$", title = "^(  )$" }, size = "1000 1000" })

----------
-- MISC --
----------

hl.config({
	misc = {
		force_default_wallpaper = 1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
		focus_on_activate = true,
	},
})

-----------
-- INPUT --
-----------

hl.config({
	input = {
		-- Keyboard
		kb_layout = "us",
		repeat_rate = 50,
		repeat_delay = 200,
		kb_options = "compose:caps",

		-- Mouse
		follow_mouse = 0, -- 0 - Don't change window focus with mouse movement alone.
		float_switch_override_focus = 0,
		-- sensitivity = 0.35,
		-- sensitivity = 0.65,
		sensitivity = 0.9, -- Mouse sensitivity.
		accel_profile = "adaptive",

		touchpad = {
			-- disable_while_typing = false, -- I may want it set to false while playing games (WASD and mouse).
		},
	},
})

------------
-- RENDER --
------------

hl.config({
	render = {
		cm_enabled = true,
	},

	cursor = {
		no_hardware_cursors = 1,
	},
})
