vim.g.mapleader = " "
vim.g.maplocalleader = " "
rainbowgroup = { "Rainbow1", "Rainbow2", "Rainbow3", "Rainbow4", "Rainbow5", "Rainbow6" }
fresh = function() return not (next(vim.fn.argv()) or vim.o.filetype == "man" or vim.env.KITTY_SCROLLBACK_NVIM) end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- LazyNvim Setup
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
	change_detection = { enabled = false },
	spec = { { import = "plugins" } },
	ui = { backdrop = 100 },
})

require("keymaps")

local undo_dir = vim.fn.stdpath("cache") .. "/undo/"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.opt.whichwrap = "<,>,h,l,[,]"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ttyfast = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.nu = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.shell = "/run/current-system/sw/bin/fish"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.list = true
vim.opt.joinspaces = false
vim.opt.fillchars = "vert: ,horiz: ,horizup: ,horizdown: ,vertleft: ,vertright: ,verthoriz: "
vim.opt.listchars = { tab = "┃ ", trail = "·", nbsp = "␣" }
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.spellfile = os.getenv("HOME") .. "/.local/share/chezmoi/dot_config/nvim/spell/en.utf-8.add"
vim.opt.splitkeep = "screen"
vim.opt.updatetime = 60000
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.shortmess:append("I")
vim.g.markdown_recommended_style = 0 -- vim.g & vim.env
vim.g.have_nerd_font = true
vim.env.PATH = vim.env.PATH .. "/run/current-system/sw/bin/"

vim.cmd("autocmd TextYankPost * call v:lua.vim.hl.on_yank()") -- briefly highlight yanked text
vim.cmd("au FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif")
vim.cmd("au CursorHoldI * stopinsert") -- stop insert after a certain amount of time
vim.cmd("autocmd QuickFixCmdPost [^l]* cwindow") -- auto open quickfix list
vim.cmd(":digr mr 772") -- Digraph command

if vim.g.neovide then
	vim.opt.winblend = 100
	vim.opt.pumblend = 100
	vim.g.neovide_scroll_animation_length = 0.3
	vim.g.neovide_remember_window_size = true
	vim.g.experimental_layer_grouping = true
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_floating_shadow = false
	vim.g.neovide_floating_blur_amount_x = 30
	vim.g.neovide_floating_blur_amount_y = 30
	if require("jit").os ~= "OSX" then vim.g.neovide_opacity = 0.8 end
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
	vim.g.neovide_cursor_vfx_opacity = 500
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.*.tmpl",
	callback = function()
		local ft = vim.fn.expand("%:t"):match(".+%.(.+)%.tmpl")
		if ft then vim.bo.filetype = ft end
	end,
})

-- vim.lsp.inlay_hint.enable(true) vim.lsp.codelens.enable(true)
vim.lsp.enable({ "lua_ls", "gopls", "rust_analyzer", "markdown_oxide", "nixd", "vtsls" })
require("vim._core.ui2").enable({ enable = true })
vim.schedule(function() vim.opt.cmdheight = 0 end)
