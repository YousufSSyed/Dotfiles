-- LazyNvim Setup
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
	{
		"serhez/bento.nvim",
		enabled = true,
		config = function()
			require("bento").setup({
				ordering_metric = "directory",
				ui = { floating = { minimal_menu = "full" } },
				highlights = { window_bg = "Normal" },
			})
			vim.keymap.set({ "n" }, ";", "<cmd>BentoToggle<cr>", keyopts)
			vim.api.nvim_set_hl(0, "BentoNormal", { bg = "NONE", ctermbg = "NONE" })
		end,
	},
})

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
