-- cmp.nvim config
cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	-- cmp keymappings
	mapping = cmp.mapping.preset.cmdline({
		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "c" }),
		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "c" }),
	}),
	sources = cmp.config.sources({
		{
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		},
		{ name = "natdat" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "fish" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

--substitute.nvim
--vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
--vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
--vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
--vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

local autocmds = require("kitty-scrollback.autocommands")
autocmds.set_term_enter_autocmd = function(_) end
autocmds.set_yank_post_autocmd = function() end
require("kitty-scrollback").setup({
	{
		keymaps_enabled = false,
		paste_window = {
			yank_register_enabled = false,
		},
		status_window = {
			autoclose = false, -- <-- set this to false
		},
	},
})

require("gitsigns").setup()

require("markdown-toggle").setup({
	use_default_keymaps = true,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "markdown-toggle.nvim keymaps",
	pattern = { "markdown", "markdown.mdx" },
	callback = function(args)
		local opts = { silent = true, noremap = true, buffer = args.buf }
		local toggle = require("markdown-toggle")
		-- Keymap configurations will be added here for each feature

		opts.expr = true -- required for dot-repeat in Normal mode
		vim.keymap.set({ "n", "v" }, "<D-l>", toggle.list_dot, opts)
		vim.keymap.set("n", "<D-k>", toggle.checkbox_dot, opts)

		opts.expr = false -- required for Visual mode
		vim.keymap.set("x", "<C-l>", toggle.list, opts)
		vim.keymap.set("x", "<S-l>", toggle.checkbox, opts)
	end,
})

-- Luasnip config
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
-- Snippets
local mdCodeBlock = s(
	{ trig = "````", name = "Codeblock" },
	fmt(
		[[
````{}
{}
````
    ]],
		{
			i(1),
			i(2),
		}
	)
)
local customSpan = s({ trig = "sspan", name = "Custom Span" }, fmt('<span style="{}">{}</span>', { i(1), i(2) }))
local mdBold = s({ name = "MDBold" }, fmt("**{}**", { i(1) }))
local tagParagraph = s({ name = "TagParagraph" }, fmt("#{} #{}.", { i(1), i(1) }))
local InsertCallout = s(
	{ name = "InsertCallout" },
	fmt(
		[[[!{}]
! ]],
		{ i(1) }
	)
)
ls.add_snippets("all", { mdCodeBlock, customSpan, mdBold, tagParagraph, InsertCallout })

vim.keymap.set({ "i" }, "<m-l>l", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<m-k>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<m-j>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "n" }, "<leader>`", function()
	require("luasnip").snip_expand(mdCodeBlock)
end)
vim.keymap.set({ "i" }, "<D-t>", function()
	require("luasnip").snip_expand(tagParagraph)
end)

vim.keymap.set({ "i" }, "<D-b>", function()
	require("luasnip").snip_expand(mdBold)
end)

vim.keymap.set({ "n" }, "<D-b>", "saiwb", { remap = false })
vim.keymap.set({ "v" }, "<D-b>", "sab", { remap = false })
vim.keymap.set({ "n" }, "<D-i>", "saiwi", { remap = false })
vim.keymap.set({ "v" }, "<D-i>", "sai", { remap = false })

require("mini.cursorword").setup()
require("mini.pick").setup()

require("mini.surround").setup({
	custom_surroundings = {
		b = {
			input = { "%*%*().-()%*%*" },
			output = { left = "**", right = "**" },
		},
		i = {
			input = { "%*().-()%*" },
			output = { left = "*", right = "*" },
		},
		s = {
			input = { "~~().-()~~" },
			output = { left = "~~", right = "~~" },
		},
		c = {
			input = { "`().-()`" },
			output = { left = "`", right = "`" },
		},
		C = {
			input = { "`.-?\n().-()\n`.-" },
			output = { left = "````\n", right = "\n````" },
		},
	},
})

require("telescope").load_extension("fzf")

vim.keymap.set({ "n" }, "<leader>f", "<cmd>Telescope frecency<cr>", opts)
vim.keymap.set({ "n" }, "<leader>os", "<cmd>Obsidian quick_switch<cr>", opts)

vim.keymap.set({ "n" }, "<leader>oo", function()
	vim.api.nvim_feedkeys(":Obsidian today ", "n", false)
end, opts)
vim.keymap.set({ "n" }, "<leader>ot", "<cmd>Obsidian today<cr>", opts)

vim.keymap.set({ "n" }, "<D-p>", function()
	local result = vim.system(
		{ "/home/yousuf/.config/nvim/FinishNote.fish", vim.api.nvim_buf_get_name(0) },
		{ text = true }
	)
		:wait()
	if result.code ~= 0 then
		local filepath = vim.cmd("<cmd>edit " .. vim.trim(result.stdout) .. "<cr><cmd>bd#<cr>")
	end
end, opts)

vim.keymap.set({ "v", "n" }, "<leader>n", "<cmd>Noice dismiss<cr>", opts)
vim.keymap.set({ "v", "n" }, "<C-f>", "<cmd>RipSubstitute<cr>", opts)

require("lspsaga").setup({
	ui = {
		kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
	},
})

-- Dial.nvim configuration
local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
	},
})
require("dial.config").augends:on_filetype({
	typescript = { augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }) },
	javascript = { augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }) },
	css = { augend.constant.new({ elements = { ";", "!important;" }, word = true, cyclic = true }) },
})
vim.keymap.set({ "n", "v", "i" }, "<C-j>", function()
	require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set({ "n", "v", "i" }, "<C-k>", function()
	require("dial.map").manipulate("decrement", "normal")
end)

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>Telescope aerial<cr>", opts)
vim.keymap.set({ "n", "v" }, "<leader>A", "<cmd>AerialOpen<cr>", opts)

vim.api.nvim_command("highlight HopUnmatched guifg=none guibg=none guisp=none ctermfg=none")
local function process_previous_word(command)
	vim.cmd(":norm mz")
	vim.cmd("HopWordBC")
	vim.cmd('call feedkeys("", "n")')
	vim.cmd(":norm " .. command)
	vim.cmd(":norm 'z")
end

vim.keymap.set({ "n", "i" }, "<M-d>", function()
	process_previous_word("daw")
end, { remap = true, silent = true })

vim.keymap.set({ "n", "i" }, "<M-c>", function()
	process_previous_word("caw")
end, { remap = true, silent = true })

vim.keymap.set({ "n", "v", "o" }, "<D-t>", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)

-- Replace w b e f j k with hop.nvim search
vim.keymap.set({ "n", "v", "o" }, "W", "<cmd>HopWordCurrentLineAC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "B", "<cmd>HopWordCurrentLineBC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "E", function()
	require("hop").hint_words({ hint_position = require("hop.hint").HintPosition.END })
end, opts)

-- vim.keymap.set({ "n", "v", "o" }, "f", "<cmd>HopChar1AC<cr>", opts)
-- vim.keymap.set({ "n", "v", "o" }, "F", "<cmd>HopChar1AC<cr>", opts)
-- vim.keymap.set({ "n", "v", "o" }, "t", "<cmd>HopChar1BC<cr>", opts)
-- vim.keymap.set({ "n", "v", "o" }, "t", "<cmd>HopChar1BC<cr>", opts)

for _, key in ipairs({ "j", "k" }) do
	vim.keymap.set({ "n", "v" }, key, "<cmd>HopVertical<cr>", opts)
	vim.keymap.set({ "o" }, key, "V<cmd>HopVertical<cr>", opts) -- Note the V<cmd>
end

-- vim.keymap.set("n", "<leader>a", function()
-- 	vim.cmd([[vimgrep /\v#region/ % | Telescope quickfix]])
-- end, { desc = "find #region (regions) in current file" })

vim.api.nvim_create_autocmd("vimenter", {
	pattern = "*",
	callback = function()
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
		end
		if fresh() then
			require("telescope").load_extension("persisted")
			vim.cmd(":Telescope persisted")
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				pattern = "*",
				callback = function()
					vim.cmd(":Persisted save")
				end,
			})
		end
	end,
	nested = true,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<c-v>", -- blockwise
		},
		include_surrounding_whitespace = true,
	},
})
local function sel(query, group)
	require("nvim-treesitter-textobjects.select").select_textobject(query, group or "textobjects")
end

vim.keymap.set({ "x", "o" }, "af", function()
	sel("@function.outer")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	sel("@function.inner")
end)
vim.keymap.set({ "x", "o" }, "aC", function()
	sel("@class.outer")
end)
vim.keymap.set({ "x", "o" }, "iC", function()
	sel("@class.inner")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	sel("@comment.inner")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	sel("@comment.outer")
end)
vim.keymap.set({ "x", "o" }, "ax", function()
	sel("@statement.outer")
end)
vim.keymap.set({ "x", "o" }, "iP", function()
	sel("@parameter.inner")
end)
vim.keymap.set({ "x", "o" }, "aP", function()
	sel("@parameter.outer")
end)
vim.keymap.set({ "x", "o" }, "aS", function()
	sel("@local.scope", "locals")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
	sel("@assignment.inner")
end)
vim.keymap.set({ "x", "o" }, "aa", function()
	sel("@assignment.outer")
end)
vim.keymap.set({ "x", "o" }, "iA", function()
	sel("@attribute.inner")
end)
vim.keymap.set({ "x", "o" }, "aA", function()
	sel("@attribute.outer")
end)

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
		javascript = { "biome-check" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
