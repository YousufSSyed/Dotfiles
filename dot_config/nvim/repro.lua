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
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		version = "3.16.1",
		lazy = false,
		opts = {
			ui = { enable = false },
			legacy_commands = false,
			daily_notes = { date_format = "YYYY-MM-DD MMMM Do YYYY dddd", folder = "Daily Notes/" },
			workspaces = { { path = os.getenv("HOME") .. "/Sync/Obsidian", name = "Obsidian" } },
			frontmatter = {
				func = function(note)
					local out = require("obsidian.builtin").frontmatter(note)
					if not out["Date Created"] or out["Date Created"] == vim.NIL then
						local time = vim.uv.fs_stat(note.path.filename)
						out["Date Created"] = os.date("%Y-%m-%d %H:%M", time and time.birthtime.sec or nil)
					end
					out["Date Modified"] = out["Date Created"] and os.date("%Y-%m-%d %H:%M") or nil
					out["id"] = nil
					out["aliases"] = nil
					out["tags"] = nil
					return out
				end,
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)
			vim.api.nvim_create_autocmd("User", {
				pattern = "ObsidianNoteWritePost",
				callback = function(ev)
					local note = require("obsidian.note").from_buffer(ev.buf)
					require("obsidian.builtin").frontmatter.func(note)
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "ObsidianNoteEnter",
				callback = function()
					vim.keymap.del("n", "<CR>", { buffer = true })
					vim.keymap.set("n", "gx", require("obsidian.api").smart_action, { buffer = true })
				end,
			})
			function obsidian(text) vim.api.nvim_feedkeys(":Obsidian dailies " .. text, "n", false) end
			vim.keymap.set("n", "<leader>old", function() obsidian("") end, keyopts)
			vim.keymap.set("n", "<leader>od", function() obsidian("-") end, keyopts)
			vim.keymap.set("n", "<leader>os", "<cmd>Obsidian quick_switch<cr>", keyopts)
			vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", keyopts)
			vim.keymap.set("n", "<C-p>", function()
				vim.system({
					os.getenv("HOME") .. "/.local/share/chezmoi/scripts/finish_note.fish",
					vim.api.nvim_buf_get_name(0),
				}, function(result)
					vim.schedule(function()
						if result.code == 0 then vim.cmd("bd") end
					end)
				end)
			end, keyopts)
		end,
	},
})

require("keymaps")
