return {
	{ "neovim/nvim-lspconfig" },
	{ "okuuva/auto-save.nvim", lazy = false, opts = {} },
	{ "OXY2DEV/helpview.nvim", lazy = false },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { multiwindow = true, line_numbers = false, multiline_threshold = 2 },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		opts = {
			select = {
				lookahead = true,
				include_surrounding_whitespace = true,
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
			},
		},
		config = function()
			local function sel(query, group)
				require("nvim-treesitter-textobjects.select").select_textobject(query, group or "textobjects")
			end
			vim.keymap.set({ "x", "o" }, "af", function() sel("@function.outer") end)
			vim.keymap.set({ "x", "o" }, "if", function() sel("@function.inner") end)
			vim.keymap.set({ "x", "o" }, "aC", function() sel("@class.outer") end)
			vim.keymap.set({ "x", "o" }, "iC", function() sel("@class.inner") end)
			vim.keymap.set({ "x", "o" }, "ic", function() sel("@comment.inner") end)
			vim.keymap.set({ "x", "o" }, "ac", function() sel("@comment.outer") end)
			vim.keymap.set({ "x", "o" }, "ax", function() sel("@statement.outer") end)
			vim.keymap.set({ "x", "o" }, "iP", function() sel("@parameter.inner") end)
			vim.keymap.set({ "x", "o" }, "aP", function() sel("@parameter.outer") end)
			vim.keymap.set({ "x", "o" }, "aS", function() sel("@local.scope", "locals") end)
			vim.keymap.set({ "x", "o" }, "ia", function() sel("@assignment.inner") end)
			vim.keymap.set({ "x", "o" }, "aa", function() sel("@assignment.outer") end)
			vim.keymap.set({ "x", "o" }, "iA", function() sel("@attribute.inner") end)
			vim.keymap.set({ "x", "o" }, "aA", function() sel("@attribute.outer") end)
			-- keymaps
			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set(
				{ "n", "x", "o" },
				"]m",
				function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]]",
				function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end
			)
			-- You can also pass a list to group multiple queries.
			vim.keymap.set(
				{ "n", "x", "o" },
				"]o",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						{ "@loop.inner", "@loop.outer" },
						"textobjects"
					)
				end
			)
			-- You can also use captures from other query groups like `locals.scm` or `folds.scm`
			vim.keymap.set(
				{ "n", "x", "o" },
				"]s",
				function() require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]z",
				function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"]M",
				function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"][",
				function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[m",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[[",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
				end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[M",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[]",
				function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end
			)

			-- Go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			vim.keymap.set(
				{ "n", "x", "o" },
				"]d",
				function() require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[d",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
				end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[P",
				function() require("nvim-treesitter-textobjects.move").goto_previous("@parameter.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]P",
				function() require("nvim-treesitter-textobjects.move").goto_next("@parameter.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]a",
				function() require("nvim-treesitter-textobjects.move").goto_next("@assignment.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[a",
				function() require("nvim-treesitter-textobjects.move").goto_previous("@assignment.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[A",
				function() require("nvim-treesitter-textobjects.move").goto_previous("@attribute.outer", "textobjects") end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]A",
				function() require("nvim-treesitter-textobjects.move").goto_next("@attribute.outer", "textobjects") end
			)
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		enabled = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
			"catppuccin/nvim",
		},
		opts = {
			-- kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			symbol_in_winbar = { enable = false },
		},
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { indent = { highlight = rainbowgroup } } },
	{
		"saghen/blink.pairs",
		enabled = true,
		version = "*",
		build = function() require("blink.pairs").build():pwait(60000) end,
		opts = {
			mappings = { enabled = false },
			highlights = {
				enabled = true,
				cmdline = true,
				groups = rainbowgroup,
				unmatched_group = "BlinkPairsUnmatched",
				matchparen = {
					enabled = true,
					include_surrounding = true,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
		},
	},
	{ "lewis6991/gitsigns.nvim" },
	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("textcase").setup({})
			require("telescope").load_extension("textcase")
		end,
		keys = {
			"ga", -- Default invocation prefix
			{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
			{ "gl", "<cmd>TextCaseOpenTelescopeLSPChange<CR>", mode = { "n", "x" }, desc = "LSP" },
		},
		cmd = {
			-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
			"Subs",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseStartReplacingCommand",
		},
		lazy = false,
	},
	{
		"stevearc/aerial.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			require("aerial").setup({ opts })
			require("telescope").load_extension("aerial")
			vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>Telescope aerial<cr>", keyopts)
			vim.keymap.set({ "n", "v" }, "<leader>A", "<cmd>AerialOpen<cr>", keyopts)
		end,
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		wo = { winbar = false },
		opts = {
			bottom = {
				{
					ft = "help",
					size = { height = 20 },
					filter = function(buf) return vim.bo[buf].buftype == "help" end,
				},
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
		config = function()
			vim.keymap.set("n", "<leader>gg", function()
				require("telescope.builtin").live_grep({
					search_dirs = { vim.fn.expand("%:p") },
					attach_mappings = function(prompt_bufnr, map)
						map({ "n", "i" }, "<CR>", function()
							require("telescope.actions").send_to_qflist(prompt_bufnr)
							require("telescope.actions").open_qflist(prompt_bufnr)
							vim.cmd("wincmd k")
						end)
						return true
					end,
				})
			end)
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		cmd = { "AdvancedGitSearch" },
		config = function()
			-- optional: setup telescope before loading the extension

			require("telescope").load_extension("advanced_git_search")
		end,
		dependencies = {
			--- See dependencies
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below

			-- bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			-- explorer = { enabled = true },
			-- indent = { enabled = true },
			-- input = { enabled = true },
			-- picker = { enabled = true },
			-- notifier = { enabled = true },
			-- quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scroll = { enabled = true },
			-- statuscolumn = { enabled = true },
			-- words = { enabled = true },
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		config = function() require("telescope").load_extension("fzf") end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "*",
		build = "make install_jsregexp",
	},
	{
		"saghen/blink.cmp",
		-- version = "1.*",
		dependencies = {
			"saghen/blink.lib",
			"rafamadriz/friendly-snippets",
			"xzbdmw/colorful-menu.nvim",
			"archie-judd/blink-cmp-words",
			"onsails/lspkind.nvim",
		},
		build = function() require("blink.cmp").build():pwait(60000) end,
		opts_extend = { "sources.default" },
		opts = {
			keymap = { preset = "default", ["<S-CR>"] = { "accept" } },
			appearance = { nerd_font_variant = "normal" },
			signature = { enabled = true },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 0 },
				trigger = { show_on_backspace_in_keyword = true },
				keyword = { range = "full" },
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							kind_icon = {
								text = function(ctx) return require("lspkind").symbol_map[ctx.kind] or "" end,
							},
							label = {
								text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
			},

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},
			sources = {
				default = { "lsp", "path", "buffer" },
				per_filetype = {
					text = { "dictionary", "thesaurus" },
					markdown = { "dictionary", "thesaurus", "lsp" },
				},
				providers = {
					thesaurus = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.thesaurus",
						opts = {
							score_offset = 0,
							definition_pointers = { "!", "&", "^" },
							similarity_pointers = { "&", "^" },
							similarity_depth = 2,
						},
					},
					dictionary = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.dictionary",
						opts = {
							dictionary_search_threshold = 3,
							score_offset = 0,
							definition_pointers = { "!", "&", "^" },
						},
					},
				},
			},
		},
	},

	-- Plugins for markdown
	{
		"jakewvincent/mkdnflow.nvim",
		enabled = true,
		opts = {
			mappings = {
				MkdnFoldSection = false,
				MkdnUnfoldSection = false,
				MkdnCreateLinkFromClipboard = false,
				MkdnTableNewRowBelow = { "n", "<leader>mr" },
				MkdnTableNewRowAbove = { "n", "<leader>mR" },
				MkdnTableNewColAfter = { "n", "<leader>mc" },
				MkdnTableNewColBefore = { "n", "<leader>mC" },
				MkdnTableNextCell = { "i", "<C-tab>" },
				MkdnEnter = false,
			},
			modules = { conceal = false },
			to_do = {
				statuses = {
					not_started = { marker = " " },
					in_progress = { marker = "/" },
					complete = { marker = "x" },
				},
			},
			config = function(_, opts)
				require("mkdnflow").setup(opts)
				vim.keymap.set({ "n", "v" }, "<leader>p", "<cmd>MkdnCreateLinkFromClipboard<cr>")
			end,
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		enabled = false,
		-- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			headings = {
				heading_1 = {
					sign_hl = "MarkviewHeading1Sign",
					icon = "󰼏  ",
					hl = "MarkviewHeading1",
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		enabled = true,
		lazy = false,
		opts = {
			render_modes = { "n", "c", "t", "i" },
			bullet = { icons = { "-" } },
			link = { enabled = true, wiki = { conceal_destination = false } },
			code = { left_pad = 1 },
			pipe_table = { preset = "heavy" },
			anti_conceal = { enabled = true, disabled_modes = { "n" } },
			heading = {
				icons = { "􀀺  # ", "􀀼  ## ", "􀀾  ### ", "􀁀  #### ", "􀁂  ##### ", "􀁄  ###### " },
				signs = { "" },
				backgrounds = {},
				position = "inline",
			},
			checkbox = {
				unchecked = { icon = "􀂒 ", highlight = "rainbow5" },
				checked = { icon = "􀃲 ", highlight = "rainbow4" },
				custom = {
					cancelled = { highlight = "rainbow1", rendered = "􀃞 ", raw = "[-]" },
					incomplete = { highlight = "rainbow2", rendered = "􀃮 ", raw = "[/]" },
				},
			},
			quote = { icon = "▎", repeat_linebreak = true },
			callout = {
				example = { raw = "[!EXAMPLE]", rendered = "􀫗  ", highlight = "CalloutExample", border = false },
				chat = { raw = "[!Chat]", rendered = "􀌲  ", highlight = "CalloutChat", border = false },
				info = { raw = "[!Info]", rendered = "􀅴  ", highlight = "CalloutInfo", border = false },
				bug = { raw = "[!Bug]", rendered = "􀌚 ", highlight = "CalloutBug", border = false },
				spoiler = { raw = "[!Spoiler]", rendered = "􀋯  ", highlight = "CalloutSpoiler", border = false },
				tip = { raw = "[!Tip]", rendered = "􁎦 ", highlight = "CalloutTip", border = false },
				warning = { raw = "[!Warning]", rendered = "􀁞  ", highlight = "CalloutWarning", border = false },
				failure = { raw = "[!Failure]", rendered = "􀆄 ", highlight = "CalloutFailure", border = false },
				success = { raw = "[!Success]", rendered = "􀆅 ", highlight = "CalloutSuccess", border = false },
				question = { raw = "[!Question]", rendered = "􀁜  ", highlight = "CalloutQuestion", border = false },
				danger = { raw = "[!Danger]", rendered = "􀋧  ", highlight = "CalloutDanger", border = false },
				abstract = { raw = "[!Abstract]", rendered = "􀌀  ", highlight = "CalloutAbstract", border = false },
				nsfw = { raw = "[!NSFW]", rendered = "􀌀  ", highlight = "CalloutNSFW", border = false },
				note = { raw = "[!Note]", rendered = "􀧵  ", highlight = "CalloutNote", border = false },
				todo = { raw = "[!Todo]", rendered = "􀃲  ", highlight = "CalloutTodo", border = false },
				warningblur = {
					raw = "[!WarningBlur]",
					rendered = "􀇾  ",
					highlight = "CalloutWarningBlur",
					border = false,
				},
			},
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		version = "*",
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
			vim.keymap.set({ "n" }, "<leader>old", function() obsidian("") end, keyopts)
			vim.keymap.set({ "n" }, "<leader>od", function() obsidian("-") end, keyopts)
			vim.keymap.set({ "n" }, "<leader>os", "<cmd>Obsidian quick_switch<cr>", keyopts)
			vim.keymap.set({ "n" }, "<leader>ot", "<cmd>Obsidian today<cr>", keyopts)
			vim.keymap.set({ "n" }, "<C-p>", function()
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
	{
		"roodolv/markdown-toggle.nvim",
		enabled = false,
		config = function()
			require("markdown-toggle").setup({ use_default_keymaps = true })
			vim.api.nvim_create_autocmd("FileType", {
				desc = "markdown-toggle.nvim keymaps",
				pattern = { "markdown", "markdown.mdx" },
				callback = function(args)
					local opts = { silent = true, noremap = true, buffer = args.buf }
					local toggle = require("markdown-toggle")
					-- Keymap configurations will be added here for each feature
					opts.expr = true -- required for dot-repeat in Normal mode
					vim.keymap.set({ "n", "v" }, "<C-l>", toggle.list_dot, opts)
					vim.keymap.set("n", "<C-k>", toggle.checkbox_dot, opts)
					opts.expr = false -- required for Visual mode
					vim.keymap.set("x", "<C-l>", toggle.list, opts)
					vim.keymap.set("x", "<S-l>", toggle.checkbox, opts)
				end,
			})
		end,
	},
	{
		"antonk52/markdowny.nvim",
		enabled = false,
	},
	{ "opdavies/toggle-checkbox.nvim" },
	{
		"echasnovski/mini.nvim",
		config = function()
			-- require("mini.git").setup()
			require("mini.cursorword").setup()
			require("mini.ai").setup()
			require("mini.pairs").setup({ mappings = { ["`"] = false } })
			require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })
			require("mini.diff").setup({ view = { style = "number" } })
			vim.keymap.set({ "n", "v", "o" }, "<leader>d", function() MiniDiff.toggle_overlay() end)
			require("mini.operators").setup({
				exchange = { prefix = "gx", reindent_linewise = true },
				replace = { prefix = "S", reindent_linewise = true },
				sort = { prefix = "", func = nil },
			})
			require("mini.surround").setup({
				custom_surroundings = {
					b = { input = { "%*%*().-()%*%*" }, output = { left = "**", right = "**" } },
					s = { input = { "~~().-()~~" }, output = { left = "~~", right = "~~" } },
					c = { input = { "`().-()`" }, output = { left = "`", right = "`" } },
					C = { input = { "`.-?\n().-()\n`.-" }, output = { left = "````\n", right = "\n````" } },
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-rip-substitute",
		config = function() vim.keymap.set({ "v", "n" }, "<C-f>", "<cmd>RipSubstitute<cr>", keyopts) end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		event = "UIEnter",
		opts = { keymaps = { useDefaultKeymaps = true } },
	},
	{
		"olimorris/persisted.nvim",
		lazy = false,
		enabled = fresh(),
		config = function()
			if vim.o.filetype == "lazy" then vim.cmd.close() end
			vim.schedule(function() vim.cmd("Persisted select") end)
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			term_colors = true,
			auto_integrations = true,
			dim_inactive = { enabled = false },
			integrations = {
				flash = true,
				aerial = true,
				hop = true,
				treesitter_context = true,
				neogit = true,
				render_markdown = true,
				markview = true,
				telescope = { enabled = true },
				mini = { enabled = true },
				blink_cmp = { style = "bordered" },
				gitsigns = { enabled = true, transparent = false },
				indent_blankline = { colored_indent_levels = true, enabled = true },
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-nvim")
			vim.cmd("hi @markup.strong guifg=none")
			vim.cmd("hi @markup.italic guifg=none")
			vim.cmd("hi @markup.quote guifg=none")
			-- vim.cmd("hi @spell.markdown guifg=#d1f1ff")
			vim.cmd("hi @lsp.type.decorator.markdown guifg=#8fefe7")
			vim.cmd("hi @markup.link.label guifg=#8fefe7")
			vim.cmd("hi RenderMarkdownQuote guifg=#00608b")

			vim.cmd("hi CalloutExample guibg=#211235 guifg=#9653EE")
			vim.cmd("hi CalloutChat guibg=#002C17 guifg=#00C767")
			vim.cmd("hi CalloutBug guibg=#310A00 guifg=#DB2C00")
			vim.cmd("hi CalloutInfo guibg=#021831 guifg=#086CDD")
			vim.cmd("hi CalloutTip guibg=#002A29 guifg=#00BDBA")
			vim.cmd("hi CalloutWarning guibg=#34220E guifg=#E9973F")
			vim.cmd("hi CalloutFailure guibg=#381011 guifg=#FB464C")
			vim.cmd("hi CalloutWarningBlur guibg=#381011 guifg=#FB464C")
			vim.cmd("hi CalloutSuccess guibg=#022912 guifg=#08BA4F")
			vim.cmd("hi CalloutQuestion guibg=#341A00 guifg=#EB7500")
			vim.cmd("hi CalloutDanger guibg=#340A0F guifg=#E92F45")
			vim.cmd("hi CalloutAbstract guibg=#00231E guifg=#009E89")
			vim.cmd("hi CalloutSpoiler guibg=#1C1139 guifg=#7C4DFF")
			vim.cmd("hi CalloutNSFW guibg=#390F1D guifg=#FF4281")
			vim.cmd("hi CalloutNote guibg=#291333 guifg=#B856E6")
			vim.cmd("hi CalloutTodo guibg=#392012 guifg=#FF9152")
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = { { "<leader>y", "<cmd>Yazi<cr>" } },
		opts = {
			open_for_directories = true,
			keymaps = { show_help = "<f1>" },
			yazi_floating_window_border = "none",
		},
	},
	{
		"xiaoshihou514/squirrel.nvim",
		lazy = false,
		config = function() vim.keymap.set({ "n", "x" }, "gt", require("squirrel.hop").hop) end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
			vim.keymap.set({ "n" }, "<leader>f", "<cmd>Telescope frecency<cr>", keyopts)
		end,
	},
	{ "tpope/vim-eunuch" },
	{
		"smoka7/hop.nvim",
		opts = { keys = "etovxqpdygfblzhckisuran", case_insentitive = false },
		config = function()
			require("hop").setup()
			vim.cmd("highlight HopUnmatched guifg=none guibg=none")
			local function process_previous_word(command)
				vim.cmd("norm mz")
				vim.cmd("HopWordBC")
				vim.cmd('call feedkeys("", "n")')
				vim.cmd("norm " .. command)
				vim.cmd("norm 'z")
			end
			vim.keymap.set({ "n", "i" }, "<M-d>", function() process_previous_word("daw") end, keyopts)
			vim.keymap.set({ "n", "i" }, "<M-c>", function() process_previous_word("caw") end, keyopts)
			-- Replace w b e f j k with hop.nvim search
			vim.keymap.set({ "n", "v", "o" }, "f", "<cmd>HopChar1<cr>", keyopts)
			-- vim.keymap.set({ "n", "v", "o" }, "F", "<cmd>HopNodes<cr>", opts)
			vim.keymap.set({ "n", "v" }, "j", "<cmd>HopVertical<cr>", keyopts)
			vim.keymap.set({ "o" }, "j", "V<cmd>HopVertical<cr>", keyopts) -- Note the V<cmd>
			vim.keymap.set({ "n", "v", "o" }, "W", "<cmd>HopWord<cr>", keyopts)
			vim.keymap.set({ "n", "v", "o" }, "B", "<cmd>HopWord<cr>", keyopts)
			vim.keymap.set(
				{ "n", "v", "o" },
				"E",
				function()
					require("hop").hint_words({
						hint_position = require("hop.hint").HintPosition.END,
					})
				end,
				keyopts
			)
		end,
	},
	{
		"aaronik/treewalker.nvim",
		-- optional (see options below)
		opts = { ... },
		config = function()
			vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })
		end,
	},
	{
		"gsuuon/tshjkl.nvim",
		config = true,
	},
	{
		"mfussenegger/nvim-treehopper",
		enabled = true,
		config = function()
			vim.keymap.set({ "n", "v" }, "F", function() require("tsht").nodes() end, keyopts)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		-- enabled = not vim.env.KITTY_SCROLLBACK_NVIM,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- enabled = false,
		lazy = false,
		config = function()
			local lineTheme = require("catppuccin.utils.lualine")()
			local C = require("catppuccin.palettes").get_palette(flavour)
			lineTheme = {
				normal = {
					c = { bg = transparent_bg, fg = C.text },
				},
				insert = {
					a = { bg = nil, fg = C.green },
					b = { bg = transparent_bg, fg = C.text },
					z = { bg = transparent_bg, fg = C.text },
				},
				terminal = {
					a = { bg = nil, fg = C.green },
					b = { bg = transparent_bg, fg = C.text },
					z = { bg = transparent_bg, fg = C.text },
				},
				command = {
					a = { bg = nil, fg = C.peach },
					b = { bg = transparent_bg, fg = C.text },
					z = { bg = transparent_bg, fg = C.text },
				},
				visual = {
					a = { bg = nil, fg = C.mauve },
					b = { bg = transparent_bg, fg = C.text },
					z = { bg = transparent_bg, fg = C.text },
				},
				replace = {
					a = { bg = nil, fg = C.red },
					b = { bg = transparent_bg, fg = C.text },
					z = { bg = transparent_bg, fg = C.text },
				},
				inactive = {
					a = { bg = transparent_bg, fg = C.blue },
					b = { bg = transparent_bg, fg = C.surface1 },
					c = { bg = transparent_bg, fg = C.overlay0 },
				},
			}
			local mode_map = {
				["n"] = "􀉅 ",
				["no"] = "􀅶  ",
				["nov"] = "􀅶  ",
				["noV"] = "􀅶  ",
				["no�"] = "􀅶  ",
				["niI"] = "􀉅 ",
				["niR"] = "􀉅 ",
				["niV"] = "􀉅 ",
				["nt"] = "􀉅 ",
				["v"] = "􀑠 ",
				["vs"] = "􀑠 ",
				["V"] = "􀑠 􀌀 ",
				["Vs"] = "􀑠 􀌀 ",
				["�"] = "􀑠 􀂒 ",
				["�s"] = "􀑠 􀂒 ",
				["s"] = "SELECT",
				["S"] = "S-LINE",
				["�"] = "S-BLOCK",
				["i"] = "􀦇 ",
				["ic"] = "􀦇 ",
				["ix"] = "􀦇 ",
				["R"] = "REPLACE",
				["Rc"] = "REPLACE",
				["Rx"] = "REPLACE",
				["Rv"] = "V-REPLACE",
				["Rvc"] = "V-REPLACE",
				["Rvx"] = "V-REPLACE",
				["c"] = ">_",
				["cv"] = "EX",
				["ce"] = "EX",
				["r"] = "REPLACE",
				["rm"] = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				["t"] = ">_",
			}
			vim.go.laststatus = 3
			require("lualine").setup({
				sections = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
				globalstatus = false,
				options = {
					theme = lineTheme,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				disabled_filetypes = { statusline = { ".*" } },
				tabline = {
					lualine_a = { function() return mode_map[vim.api.nvim_get_mode().mode] or "__" end },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "%=", "filename", "filetype" },
					lualine_y = { function() return vim.fn.wordcount().words .. " words" end },
					lualine_z = {
						"location",
						function()
							local buf = vim.api.nvim_get_current_buf()
							local line_count = vim.api.nvim_buf_line_count(buf)
							return "/ " .. line_count
						end,
					},
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		enabled = true,
		event = "VeryLazy",
		modes = { char = { enabled = false } },
		---@type Flash.Config
		-- opts = {},
		-- stylua: ignore
		keys = {
			-- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			-- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = { augend.integer.alias.decimal, augend.integer.alias.hex, augend.constant.alias.bool },
			})
			require("dial.config").augends:on_filetype({
				typescript = { augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }) },
				javascript = { augend.constant.new({ elements = { "let", "const" }, word = true, cyclic = true }) },
				css = { augend.constant.new({ elements = { ";", "!important;" }, word = true, cyclic = true }) },
			})
			vim.keymap.set(
				{ "n", "v", "i" },
				"<M-j>",
				function() require("dial.map").manipulate("increment", "normal") end
			)
			vim.keymap.set(
				{ "n", "v", "i" },
				"<M-k>",
				function() require("dial.map").manipulate("decrement", "normal") end
			)
		end,
	},
	{
		"dlyongemallo/diffview-plus.nvim",
		config = function()
			vim.keymap.set({ "n", "v", "o" }, "<leader>v", "<cmd>:DiffviewFileHistory % --pin-local<cr>")
		end,
	},
	{
		"subnut/nvim-ghost.nvim",
		name = "nvim_ghost",
		enabled = false,
		lazy = false,
		config = function()
			vim.api.nvim_create_autocmd("User", {
				group = "nvim_ghost_user_autocommands",
				pattern = "http*",
				command = "setfiletype markdown",
			})
		end,
		keys = { { "<leader>ug", ":GhostTextStart<cr>", silent = true } },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- "serhez/bento.nvim",
		"YousufSSyed/bento.nvim",
		branch = "no_blending",
		enabled = true,
		config = function()
			require("bento").setup({
				ordering_metric = "directory",
				ui = { floating = { minimal_menu = "full", position = "bottom-right", label_padding = 0 } },
			})
			vim.keymap.set({ "n" }, "<leader>;", "<cmd>BentoToggle<cr>", keyopts)
			-- vim.api.nvim_set_hl(0, "BentoNormal", { bg = "NONE", ctermbg = "NONE" })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				fish = { "fish_indent" },
				javascript = { "biome-check" },
				json = { "biome-check" },
				lua = { "stylua" },
				nix = { "nixfmt" },
			},
			format_on_save = function()
				local pwd = vim.fn.getcwd()
				for line in io.lines(os.getenv("HOME") .. "/Sync/Misc/other_repos.txt") do
					if line == pwd then return end
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
		},
	},
	{
		"aidancz/paramo.nvim",
		enabled = false,
		opts = {
			{ type = "para0", backward = "{", forward = "}" },
			{ type = "para1", backward = "(", forward = ")" },
			{ type = "para2", backward = "<home>", forward = "<end>" },
		},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		enabled = false,
		cmd = "Trouble",
		-- keys = {
		-- 	{
		-- 		"<C-t>",
		-- 		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		-- 		desc = "Buffer Diagnostics (Trouble)",
		-- 	},
		-- },
	},
	{
		"uga-rosa/ccc.nvim",
		config = function()
			require("ccc").setup({
				highlight_mode = "virtual",
				virtual_symbol = "󱓻 ",
				highlighter = { auto_enable = true, lsp = true },
			})
		end,
	},
	{
		"mikesmithgh/kitty-scrollback.nvim",
		cmd = {
			"KittyScrollbackGenerateKittens",
			"KittyScrollbackCheckHealth",
			"KittyScrollbackGenerateCommandLineEditing",
		},
		event = { "User KittyScrollbackLaunch" },
		opts = {
			{
				keymaps_enabled = false,
				paste_window = { yank_register_enabled = false },
				status_window = { autoclose = false },
			},
		},
		config = function()
			local autocmds = require("kitty-scrollback.autocommands")
			autocmds.set_term_enter_autocmd = function(_) end
			autocmds.set_yank_post_autocmd = function() end
		end,
	},
	{ "tpope/vim-fugitive" },
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function() vim.keymap.set("n", "<leader>n", "<cmd>Neogit<cr>", keyopts) end,
	},
	{
		"tridactyl/vim-tridactyl",
		config = function() vim.filetype.add({ pattern = { [".*tridactylrc"] = "vim" } }) end,
	},
	{ "kevinhwang91/nvim-bqf" },
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
	},
	{ "folke/todo-comments.nvim" },
	{
		"chrisgrieser/nvim-tinygit",
		enabled = false,
		-- dependencies = "nvim-telescope/telescope.nvim", -- only for interactive staging
	},
	{
		"tanvirtin/vgit.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		-- Lazy loading on 'VimEnter' event is necessary.
		event = "VimEnter",
		config = function() require("vgit").setup() end,
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		-- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
		-- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
		-- spec defers loading until a <leader>a* mapping is pressed and the commands
		-- would not exist yet.
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeSelectModel",
			"ClaudeCodeAdd",
			"ClaudeCodeSend",
			"ClaudeCodeTreeAdd",
			"ClaudeCodeStatus",
			"ClaudeCodeStart",
			"ClaudeCodeStop",
			"ClaudeCodeOpen",
			"ClaudeCodeClose",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
			"ClaudeCodeCloseAllDiffs",
		},
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
