vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- LazyNvim Setup
fresh = function()
	return not (next(vim.fn.argv()) or vim.o.filetype == "man" or vim.env.KITTY_SCROLLBACK_NVIM)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	ui = {
		backdrop = 100, -- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
	},
	spec = {
		{ import = "plugins" },
	},
	change_detection = {
		enabled = false,
	},
})

require("keymaps")
require("pluginconfig")

-- wrap settings
vim.opt.whichwrap = "<,>,h,l,[,]"
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.laststatus = 0
vim.opt.cmdheight = 0

vim.opt.showmode = false
vim.opt.ttyfast = true
vim.opt.showmatch = true
local undo_dir = vim.fn.stdpath("cache") .. "/undo/"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.g.markdown_recommended_style = 0
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.g.have_nerd_font = true
vim.opt.nu = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.ignorecase = true
-- vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.shell = "/run/current-system/sw/bin/fish"
-- Digraph command
vim.cmd(":digr mr 772")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "▎ ", trail = "·", nbsp = "␣" }
vim.opt.joinspaces = false
-- Set <space> as the leader key, See `:help mapleader`, NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.opt.fillchars = "vert: ,horiz: ,horizup: ,horizdown: ,vertleft: ,vertright: ,verthoriz: "
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.diagnostic.config({ virtual_text = false })
vim.env.PATH = vim.env.PATH .. "/run/current-system/sw/bin/"

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- vim.g.markdown_folding = 1

-- Exit insert mode after being idle for 60 secs
vim.opt.updatetime = 60000
vim.cmd("au CursorHoldI * stopinsert")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.env.OBSIDIAN_REST_API_KEY = ""

vim.cmd([[
      autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
      autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

-- Neovide
vim.keymap.set("n", "<leader>s", function()
	vim.cmd(":source ~/.config/nvim/init.lua")
end)

if vim.g.neovide then
	vim.g.neovide_scroll_animation_length = 0.15
	vim.g.neovide_remember_window_size = true
	vim.g.experimental_layer_grouping = true
	vim.opt.winblend = 100
	vim.opt.pumblend = 100
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_floating_shadow = false
	vim.g.neovide_floating_blur_amount_x = 30
	vim.g.neovide_floating_blur_amount_y = 30
	vim.g.neovide_opacity = 0.8
	local function toggleAnimations(toggle)
		if toggle then
			vim.g.neovide_cursor_animation_length = 0.3
			vim.g.neovide_cursor_short_animation_length = 0.15
		else
			vim.g.neovide_cursor_animation_length = 0.0
			vim.g.neovide_cursor_short_animation_length = 0.0
		end
	end
	-- Disable Cursor VFX in insert mode
	vim.api.nvim_create_autocmd("ModeChanged", {
		callback = function(args)
			local from_mode, to_mode = args.match:match("([^:]+):([^:]+)")
			if to_mode ~= "i" then
				vim.g.neovide_cursor_vfx_mode = "railgun"
			else
				vim.g.neovide_cursor_vfx_mode = ""
			end
		end,
	})
	-- Disable Cursor animations and VFX in certain windows
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local ft = vim.bo[bufnr].filetype
			toggleAnimations(ft ~= "snipe-menu")
		end,
	})
end

vim.api.nvim_create_user_command("Redir", function(ctx)
	local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
	vim.cmd("new")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })
