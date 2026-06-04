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

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup() ]]
--

--substitute.nvim
--vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
--vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
--vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
--vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- LSP Config
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

local function check_codelens_support()
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	for _, c in ipairs(clients) do
		if c.server_capabilities.codeLensProvider then
			return true
		end
	end
	return false
end

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
	buffer = bufnr,
	callback = function()
		if check_codelens_support() then
			vim.lsp.codelens.refresh({ bufnr = 0 })
		end
	end,
})

-- trigger codelens refresh
vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })

-- An example nvim-lspconfig capabilities setting
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig").markdown_oxide.setup({
	-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
	-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
	capabilities = vim.tbl_deep_extend("force", capabilities, {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	}),
	on_attach = on_attach, -- configure your on attach config
})

require("gitsigns").setup()

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
	},
})

-- From: https://github.com/folke/edgy.nvim/blob/main/README.md
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"

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

local menu = {
	{
		name = "Finish Daily Note",
		cmd = function()
			os.execute("/home/yousuf/.config/nvim/FinishNote.fish '" .. vim.api.nvim_buf_get_name(0) .. "'")
		end,
		rtxt = "<D-p>",
	},
	{
		name = "Obsidian search",
		cmd = function()
			vim.cmd(":Obsidian quick_switch")
		end,
		rtxt = "s",
	},
	{
		name = "Telescope Frecency",
		cmd = function()
			vim.cmd(":Telescope frecency")
		end,
		rtxt = "f",
	},
}

vim.keymap.set("n", "<D-p>", function()
	require("menu").open(menu)
end, {})

require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
	-- skip autopair when next character is one of these
	skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
	-- skip autopair when the cursor is inside these treesitter nodes
	skip_ts = { "string" },
	-- skip autopair when next character is closing pair
	-- and there are more closing pairs than opening pairs
	skip_unbalanced = true,
	-- better deal with markdown code blocks
	markdown = true,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		MiniPairs.map_buf(0, "i", "*", { action = "closeopen", pair = "**" })
	end,
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("undo")

require("mini.pick").setup()

-- Misc plugin keymaps
vim.keymap.set({ "v", "n" }, "<leader>n", "<cmd>Noice dismiss<cr>", opts)
vim.keymap.set({ "v", "n" }, "<leader>r", "<cmd>RipSubstitute<cr>", opts)

require("catppuccin").setup({
	term_colors = true,
	dim_inactive = {
		enabled = false,
	},
	no_underline = false,
	integrations = {
		treesitter_context = true,
		treesitter = true,
	},
})

-- Synchornize Indent Blankline colors with rainbow delimiters
local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
require("ibl").setup({ indent = { highlight = highlight } })

-- Dial.nvim configuration
local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
	},
})
vim.keymap.set({ "n", "v", "i" }, "<C-j>", "<Plug>(dial-increment)")
vim.keymap.set({ "n", "v", "i" }, "<C-k>", "<Plug>(dial-decrement)")

-- Remove Telescope frecency message notification
-- From: https://github.com/rcarriga/nvim-notify/issues/114
local banned_messages = { "missing entries" }
vim.notify = function(msg, ...)
	for _, banned in ipairs(banned_messages) do
		if msg == banned then
			return
		end
	end
	require("notify")(msg, ...)
end

vim.api.nvim_command("highlight HopUnmatched guifg=none guibg=none guisp=none ctermfg=none")

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "maintained",
--   highlight = {
--     enable = true,
--   },
--   textobjects = {
--     select = {
--       enable = true,
--       lookahead = true,
--       keymaps = {
--         ["af"] = "@function.outer",
--         ["if"] = "@function.inner",
--         ["ac"] = "@class.outer",
--         ["ic"] = "@class.inner",
--       },
--     },
--   },
-- }
--
-- local ts_utils = require'nvim-treesitter.ts_utils'
-- local parsers = require'nvim-treesitter.parsers'
--
-- local function move_selection_to_bottom_of_section()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local parser = parsers.get_parser(bufnr)
--   local root = parser:parse()[1]:root()
--
--   local start_line, start_col = unpack(vim.fn.getpos("'<"))
--   local end_line, end_col = unpack(vim.fn.getpos("'>"))
--   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
--
--   local current_node = root:named_descendant_for_range(start_line - 1, 0, end_line, -1)
--   local section_end = current_node:end_()
--
--   vim.api.nvim_buf_set_lines(0, section_end, section_end, false, lines)
--   vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
-- end
--

-- local ts_utils = require'nvim-treesitter.ts_utils'
-- local parsers = require'nvim-treesitter.parsers'
--
-- local function move_selection_to_bottom_of_section()
--   local bufnr = vim.api.nvim_get_current_buf()
--   local parser = parsers.get_parser(bufnr)
--   local root = parser:parse()[1]:root()
--
--   local start_line, start_col = unpack(vim.fn.getpos("'<"))
--   local end_line, end_col = unpack(vim.fn.getpos("'>"))
--   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
--
--   local current_node = root:named_descendant_for_range(start_line - 1, 0, end_line, -1)
--   local section_end = current_node:end_()
--
--   vim.api.nvim_buf_set_lines(0, section_end, section_end, false, lines)
--   vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
-- end
--
-- vim.keymap.set({"v"}, "<m-j>", function() move_selection_to_bottom_of_section() end)

vim.keymap.set({ "n", "v" }, "<leader>a", ":Telescope aerial", opts)

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
vim.keymap.set({ "n", "v", "o" }, "w", "<cmd>HopWordCurrentLineAC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "b", "<cmd>HopWordCurrentLineBC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "e", function()
	require("hop").hint_words({ hint_position = require("hop.hint").HintPosition.END })
end, opts)
vim.keymap.set({ "n", "v", "o" }, "f", "<cmd>HopChar1AC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "F", "<cmd>HopChar1AC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "t", "<cmd>HopChar1BC<cr>", opts)
vim.keymap.set({ "n", "v", "o" }, "t", "<cmd>HopChar1BC<cr>", opts)
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
			require("persistence").select()
		end
	end,
	nested = true,
})

-- you can use the capture groups defined in textobjects.scm
require("nvim-treesitter.configs").setup({
	textobjects = {
		select = {
			enable = true,
			-- automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["aC"] = "@class.outer",
				["iC"] = { query = "@class.inner" },
				["ic"] = { query = "@comment.inner" },
				["ac"] = { query = "@comment.outer" },
				["ax"] = { query = "@statement.outer" }, -- There is not statement.inner
				["iP"] = "@parameter.inner",
				["aP"] = "@parameter.outer",
				-- You can also use captures from other query groups like `locals.scm`
				["aS"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
				["ia"] = "@assignment.inner",
				["aa"] = "@assignment.outer",
				["iA"] = "@attribute.inner",
				["aA"] = "@attribute.outer",
			},
			-- You can choose the select mode (default is charwise 'v')
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true or false
			include_surrounding_whitespace = true,
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
