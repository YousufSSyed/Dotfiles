return {
	{ "neovim/nvim-lspconfig" },
	{ "okuuva/auto-save.nvim" },
	{ "OXY2DEV/helpview.nvim", lazy = false },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").install({ "all" })
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
				require("nvim-treesitter-textobjects.select").select_textobject(
					query,
					group or "textobjects"
				)
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
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@function.outer",
						"textobjects"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]]",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@class.outer",
						"textobjects"
					)
				end
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
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@local.scope",
						"locals"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"]z",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
				end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"]M",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end(
						"@function.outer",
						"textobjects"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"][",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end(
						"@class.outer",
						"textobjects"
					)
				end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[m",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@function.outer",
						"textobjects"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[[",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@class.outer",
						"textobjects"
					)
				end
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[M",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end(
						"@function.outer",
						"textobjects"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[]",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end(
						"@class.outer",
						"textobjects"
					)
				end
			)

			-- Go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			vim.keymap.set(
				{ "n", "x", "o" },
				"]d",
				function()
					require("nvim-treesitter-textobjects.move").goto_next(
						"@conditional.outer",
						"textobjects"
					)
				end
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"[d",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous(
						"@conditional.outer",
						"textobjects"
					)
				end
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
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
			},
		},
	},
	{
		"saghen/blink.pairs",
		enabled = true,
		version = "*",
		build = "nix run .#build-plugin",
		opts = {
			mappings = { enabled = false },
			highlights = {
				enabled = true,
				cmdline = true,
				unmatched_group = "BlinkPairsUnmatched",
				matchparen = {
					enabled = true,
					include_surrounding = true,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
				groups = {
					"BlinkPairsRed",
					"BlinkPairsYellow",
					"BlinkPairsBlue",
					"BlinkPairsOrange",
					"BlinkPairsGreen",
					"BlinkPairsPurple",
					"BlinkPairsCyan",
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
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			layout = {
				default_direction = "float",
				min_width = 0.8,
			},
		},
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>Telescope aerial<cr>", opts)
			vim.keymap.set({ "n", "v" }, "<leader>A", "<cmd>AerialOpen<cr>", opts)
		end,
	},
	{
		"folke/edgy.nvim",
		enabled = true,
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
		priority = 998,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",
			},
		},
		config = function()
			vim.keymap.set("n", "<leader>b", function()
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
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		config = function() require("telescope").load_extension("fzf") end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "*",
		build = "make install_jsregexp",
	},
	-- {
	-- 	"gbprod/substitute.nvim",
	-- 	config = function()
	-- 		vim.keymap.set("n", "s", require("substitute").operator)
	-- 		vim.keymap.set("n", "ss", require("substitute").line)
	-- 		vim.keymap.set("n", "S", require("substitute").eol)
	-- 		vim.keymap.set("x", "s", require("substitute").visual)
	-- 	end,
	-- },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"xzbdmw/colorful-menu.nvim",
			"archie-judd/blink-cmp-words",
			"onsails/lspkind.nvim",
		},
		opts_extend = { "sources.default" },
		build = "nix run .#build-plugin",
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
								text = function(ctx)
									return require("lspkind").symbol_map[ctx.kind] or ""
								end,
							},
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
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
				-- Setup completion by filetype
				per_filetype = {
					text = { "dictionary", "thesaurus" },
					markdown = { "dictionary", "thesaurus" },
				},
				providers = {
					-- Use the thesaurus source
					thesaurus = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.thesaurus",
						-- All available options
						opts = {
							-- A score offset applied to returned items.
							-- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
							score_offset = 0,

							-- Default pointers define the lexical relations listed under each definition,
							-- see Pointer Symbols below.
							-- Default is as below ("antonyms", "similar to" and "also see").
							definition_pointers = { "!", "&", "^" },

							-- The pointers that are considered similar words when using the thesaurus,
							-- see Pointer Symbols below.
							-- Default is as below ("similar to", "also see" }
							similarity_pointers = { "&", "^" },

							-- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
							-- 2 is similar words of similar words, etc. Increasing this may slow results.
							similarity_depth = 2,
						},
					},

					-- Use the dictionary source
					dictionary = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.dictionary",
						-- All available options
						opts = {
							-- The number of characters required to trigger completion.
							-- Set this higher if completion is slow, 3 is default.
							dictionary_search_threshold = 3,

							-- See above
							score_offset = 0,

							-- See above
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
				MkdnTableNextCell = { "i", "<D-tab>" },
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
			config = function()
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
				icons = {
					"􀀺  # ",
					"􀀼  ## ",
					"􀀾  ### ",
					"􀁀  #### ",
					"􀁂  ##### ",
					"􀁄  ###### ",
				},
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
			-- callout = {
			-- 	tip = { raw = '[!TIP]', rendered = '󰌶', highlight = 'RenderMarkdownSuccess', border = true },
			-- }, 
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		lazy = false,
		opts = {
			ui = { enable = false },
			legacy_commands = false,
			daily_notes = { date_format = "YYYY-MM-DD MMMM Do YYYY dddd" },
			workspaces = { { path = "/home/yousuf/Assets/Obsidian", name = "Obsidian" } },
			frontmatter = {
				func = function(note)
					local out = require("obsidian.builtin").frontmatter(note)
					if not out["Date Created"] or out["Date Created"] == vim.NIL then
						local time = vim.uv.fs_stat(note.path.filename)
						out["Date Created"] =
							os.date("%Y-%m-%d %H:%M", time and time.birthtime.sec or nil)
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
			vim.api.create_autocmd("User", {
				pattern = "ObsidianNoteWritePost",
				callback = function(ev)
					local note = require("obsidian.note").from_buffer(ev.buf)
					require("obsidian.builtin").frontmatter.func(note)
				end,
			})
			vim.keymap.set({ "n" }, "<leader>os", "<cmd>Obsidian quick_switch<cr>", opts)
			vim.keymap.set({ "n" }, "<leader>ot", "<cmd>Obsidian today<cr>", opts)
			vim.keymap.set(
				{ "n" },
				"<leader>oo",
				function() vim.api.nvim_feedkeys(":Obsidian today ", "n", false) end,
				opts
			)
			vim.keymap.set({ "n" }, "<D-p>", function()
				local result = vim.system({
					"/home/yousuf/.config/nvim/FinishNote.fish",
					vim.api.nvim_buf_get_name(0),
				}, { text = true }):wait()
				if result.code ~= 0 then
					local filepath =
						vim.cmd("<cmd>edit " .. vim.trim(result.stdout) .. "<cr><cmd>bd#<cr>")
				end
			end, opts)
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
					vim.keymap.set({ "n", "v" }, "<D-l>", toggle.list_dot, opts)
					vim.keymap.set("n", "<D-k>", toggle.checkbox_dot, opts)
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
			require("mini.cursorword").setup()
			require("mini.ai").setup()
			require("mini.pairs").setup({ mappings = { ["`"] = false } })
			require("mini.splitjoin").setup({ mappings = { toggle = "gs" } })
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
					C = {
						input = { "`.-?\n().-()\n`.-" },
						output = { left = "````\n", right = "\n````" },
					},
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-rip-substitute",
		config = function() vim.keymap.set({ "v", "n" }, "<C-f>", "<cmd>RipSubstitute<cr>", opts) end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		event = "UIEnter",
		opts = { keymaps = { useDefaultKeymaps = true } },
	},
	{
		"olimorris/persisted.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		enabled = fresh(),
		lazy = false,
		priority = 999,
		event = "BufReadPre",
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
				blink_pairs = true,
				telescope = { enabled = true },
				mini = { enabled = true },
				blink_cmp = { style = "bordered" },
				gitsigns = {
					enabled = true,
					transparent = false,
				},
				indent_blankline = {
					colored_indent_levels = true,
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-nvim")
			vim.cmd(":hi @markup.strong guifg=none")
			vim.cmd(":hi @markup.italic guifg=none")
			vim.cmd(":hi @markup.quote guifg=none")
			vim.cmd(":hi @spell.markdown guifg=#d1f1ff")
			vim.cmd(":hi @lsp.type.decorator.markdown guifg=#8fefe7")
			vim.cmd(":hi @markup.link.label guifg=#8fefe7")
			vim.cmd(":hi RenderMarkdownQuote guifg=#00608b")
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>y", "<cmd>Yazi<cr>" },
		},
		opts = {
			open_for_directories = true,
			keymaps = {
				show_help = "<f1>",
			},
			yazi_floating_window_winblend = vim.g.neovide and 50 or 0,
			yazi_floating_window_border = vim.g.neovide and "none" or "rounded",
		},
	},
	{
		"jay-babu/project.nvim",
		lazy = false,
		enabled = false,
		config = function()
			require("project_nvim").setup({
				unset_autochdir = false,
				patterns = { os.getenv("HOME") .. "/Assets/Obsidian" },
				exclude_dirs = { os.getenv("HOME") .. "/.local/share/chezmoi/dot_config/nvim" },
			})
		end,
	},
	{
		"natecraddock/workspaces.nvim",
		enabled = false,
		auto_dir = false,
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
			vim.keymap.set({ "n" }, "<leader>f", "<cmd>Telescope frecency<cr>", opts)
		end,
		opts = { db_version = "v2" },
	},
	{ "tpope/vim-eunuch" },
	{
		"smoka7/hop.nvim",
		opts = { keys = "etovxqpdygfblzhckisuran", case_insentitive = false },
		config = function()
			require("hop").setup()
			vim.cmd("highlight HopUnmatched guifg=none guibg=none")
			local function process_previous_word(command)
				vim.cmd(":norm mz")
				vim.cmd("HopWordBC")
				vim.cmd('call feedkeys("", "n")')
				vim.cmd(":norm " .. command)
				vim.cmd(":norm 'z")
			end

			vim.keymap.set({ "n", "i" }, "<M-d>", function() process_previous_word("daw") end, opts)
			vim.keymap.set({ "n", "i" }, "<M-c>", function() process_previous_word("caw") end, opts)

			-- Replace w b e f j k with hop.nvim search
			vim.keymap.set({ "n", "v", "o" }, "e", "<cmd>HopWord<cr>", opts)
			vim.keymap.set({ "n", "v", "o" }, "f", "<cmd>HopChar1<cr>", opts)
			-- vim.keymap.set({ "n", "v", "o" }, "F", "<cmd>HopNodes<cr>", opts)
			vim.keymap.set({ "n", "v" }, "j", "<cmd>HopVertical<cr>", opts)
			vim.keymap.set({ "o" }, "j", "V<cmd>HopVertical<cr>", opts) -- Note the V<cmd>
			-- vim.keymap.set({ "n", "v", "o" }, "B", "<cmd>HopWordCurrentLineBC<cr>", opts)
			vim.keymap.set(
				{ "n", "v", "o" },
				"E",
				function()
					require("hop").hint_words({
						hint_position = require("hop.hint").HintPosition.END,
					})
				end,
				opts
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
			vim.keymap.set({ "n", "v", "i" }, "F", function() require("tsht").nodes() end, opts)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		-- enabled = not vim.env.KITTY_SCROLLBACK_NVIM,
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
				disabled_filetypes = { -- Filetypes to disable lualine for.
					statusline = { ".*" },
				},
				tabline = {
					lualine_a = {
						function() return mode_map[vim.api.nvim_get_mode().mode] or "__" end,
					},
					lualine_b = {
						"branch",
						"diff",
						"diagnostics",
					},
					lualine_c = { "%=", "filename", "filetype" },
					lualine_y = {
						function() return vim.fn.wordcount().words .. " words" end,
					},
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
				typescript = {
					augend.constant.new({
						elements = { "let", "const" },
						word = true,
						cyclic = true,
					}),
				},
				javascript = {
					augend.constant.new({
						elements = { "let", "const" },
						word = true,
						cyclic = true,
					}),
				},
				css = {
					augend.constant.new({
						elements = { ";", "!important;" },
						word = true,
						cyclic = true,
					}),
				},
			})
			vim.keymap.set(
				{ "n", "v", "i" },
				"<C-j>",
				function() require("dial.map").manipulate("increment", "normal") end
			)
			vim.keymap.set(
				{ "n", "v", "i" },
				"<C-k>",
				function() require("dial.map").manipulate("decrement", "normal") end
			)
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},
	{ "sindrets/diffview.nvim" },
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
		"serhez/bento.nvim",
		enabled = false,
		config = function()
			require("bento").setup({
				ordering_metric = "directory",
				ui = { floating = { minimal_menu = "full" } },
			})
			vim.keymap.set({ "n" }, "<leader>;", "<cmd>BentoToggle<cr>", opts)
		end,
	},
	{
		"leath-dub/snipe.nvim",
		keys = { { ";", function() require("snipe").open_buffer_menu() end } },
		opts = {
			ui = {
				position = "center",
				text_align = "file-first",
				navigate = { cancel_snipe = "q" },
				open_win_override = { title = "" },
			},
			sort = function(buffers)
				local buffers_with_dir = vim.tbl_map(function(buf)
					buf.dirname = vim.fs.dirname(buf.name)
					return buf
				end, buffers)
				table.sort(buffers_with_dir, function(a, b)
					if a.dirname == b.dirname then
						return a.name < b.name
					else
						return a.dirname < b.dirname
					end
				end)
				return buffers_with_dir
			end,
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
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
		-- 		"<D-t>",
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
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
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
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
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
}
