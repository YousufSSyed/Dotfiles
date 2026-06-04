return {
	{ "neovim/nvim-lspconfig" },
	{ "okuuva/auto-save.nvim" },
	{
		"OXY2DEV/helpview.nvim",
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
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
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({ symbol_in_winbar = { enable = false } })
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
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
	{ "nvim-pack/nvim-spectre" },
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				layout = {
					default_direction = "float",
					min_width = 0.8,
				},
			})
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
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"L3MON4D3/LuaSnip",
		version = "*",
		build = "make install_jsregexp",
	},
	{
		"gbprod/substitute.nvim",
		enabled = false,
	},
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
			keymap = { preset = "default" },
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
					thesaurus = {
						module = "blink-cmp-words.thesaurus",
						opts = {
							definition_pointers = { "!", "&", "^" },
							similarity_pointers = { "&", "^" },
							similarity_depth = 2,
						},
					},
					dictionary = {
						module = "blink-cmp-words.dictionary",
						opts = {
							dictionary_search_threshold = 3,
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
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		enabled = true,
		lazy = false,
		opts = {
			render_modes = { "n", "c", "t", "i" },
			bullet = { icons = { "-" } },
			link = { enabled = true },
			code = { left_pad = 1 },
			pipe_table = { preset = "heavy" },
			anti_conceal = { enabled = true, disabled_modes = { "n" } },
			-- Markdown styling
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
					cancelled = {
						highlight = "rainbow1",
						rendered = "􀃞 ",
						raw = "[-]",
					},
					incomplete = {
						highlight = "rainbow2",
						rendered = "􀃮 ",
						raw = "[/]",
					},
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
			workspaces = {
				{
					path = "/home/yousuf/Assets/Obsidian",
					name = "Obsidian",
				},
			},
			frontmatter = {
				func = function(note)
					local out = require("obsidian.builtin").frontmatter(note)
					if not out["Date Created"] then
						local time = vim.uv.fs_stat(note.path.filename)
						out["Date Created"] = time and time.birthtime.sec or os.date("%Y-%m-%d %H:%M", time)
					end
					out["Date Modified"] = out["Date Created"] and os.date("%Y-%m-%d %H:%M") or nil
					out["id"] = nil
					out["aliases"] = nil
					out["tags"] = nil
					return out
				end,
			},
			config = function()
				vim.api.create_autocmd("User", {
					pattern = "ObsidianNoteWritePost",
					callback = function(ev)
						local note = require("obsidian.note").from_buffer(ev.buf)
						require("obsidian.builtin").frontmatter.func(note)
					end,
				})
			end,
		},
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
		config = function()
			require("markdowny").setup()
		end,
	},
	{ "opdavies/toggle-checkbox.nvim" },
	{ "echasnovski/mini.nvim" },
	{ "chrisgrieser/nvim-rip-substitute" },
	{
		"chrisgrieser/nvim-various-textobjs",
		event = "UIEnter",
		opts = {
			keymaps = {
				useDefaultKeymaps = true,
			},
		},
	},
	{
		"olimorris/persisted.nvim",
		enabled = fresh(),
		lazy = false,
		event = "BufReadPre",
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				term_colors = true,
				auto_integrations = true,
				dim_inactive = {
					enabled = false,
				},
				integrations = {
					flash = true,
					aerial = true,
					grug_far = true,
					hop = true,
					treesitter_context = true,
					neogit = true,
					render_markdown = false,
					blink_pairs = true,
					telescope = { enabled = true },
					mini = { enabled = true },
					blink_cmp = {
						style = "bordered",
					},
					gitsigns = {
						enabled = true,
						transparent = false,
					},
					indent_blankline = {
						colored_indent_levels = true,
						enabled = true,
					},
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
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
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		opts = { db_version = "v2" },
	},
	{ "tpope/vim-eunuch" },
	{
		"smoka7/hop.nvim",
		opts = {
			keys = "etovxqpdygfblzhckisuran",
			case_insentitive = false,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		-- enabled = not vim.env.KITTY_SCROLLBACK_NVIM,
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
			require("lualine").setup({
				options = {
					theme = lineTheme,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
				tabline = {
					lualine_a = {
						function()
							return mode_map[vim.api.nvim_get_mode().mode] or "__"
						end,
					},
					lualine_b = {
						"branch",
						"diff",
						"diagnostics",
					},
					lualine_c = { "%=", "filename", "filetype" },
					lualine_y = {
						function()
							return vim.fn.wordcount().words .. " words"
						end,
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
			vim.go.laststatus = 0
			vim.go.cmdheight = 0
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
	{ "monaqa/dial.nvim" },
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
	{
		"ColinKennedy/cursor-text-objects.nvim",
		config = function()
			local down_description = "Operate from your current cursor to the end of some text-object."
			local up_description = "Operate from the start of some text-object to your current cursor."
			vim.keymap.set("o", "[", "<Plug>(cursor-text-objects-up)", { desc = up_description })
			vim.keymap.set("o", "]", "<Plug>(cursor-text-objects-down)", { desc = down_description })
			vim.keymap.set("x", "[", "<Plug>(cursor-text-objects-up)", { desc = up_description })
			vim.keymap.set("x", "]", "<Plug>(cursor-text-objects-down)", { desc = down_description })
		end,
		version = "v1.*",
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
		keys = {
			{ "<leader>ug", ":GhostTextStart<cr>", desc = "GhostTextStart", silent = true },
		},
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
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				multiwindow = true,
				line_numbers = false,
				multiline_threshold = 2,
			})
		end,
	},
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				";",
				function()
					require("snipe").open_buffer_menu()
				end,
			},
		},
		opts = {
			ui = {
				position = "center",
				text_align = "file-first",
				navigate = {
					cancel_snipe = "q",
				},
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
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},
	{ "stevearc/conform.nvim" },
	{
		"aidancz/paramo.nvim",
		enabled = false,
		config = function()
			require("paramo").setup({
				{
					type = "para0",
					backward = "{",
					forward = "}",
				},
				{
					type = "para1",
					backward = "(",
					forward = ")",
				},
				{
					type = "para2",
					backward = "<home>",
					forward = "<end>",
				},
			})
		end,
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
		lazy = true,
		cmd = {
			"KittyScrollbackGenerateKittens",
			"KittyScrollbackCheckHealth",
			"KittyScrollbackGenerateCommandLineEditing",
		},
		event = { "User KittyScrollbackLaunch" },
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
		config = function()
			vim.filetype.add({ pattern = { [".*tridactylrc"] = "vim" } })
		end,
	},
	{ "aaronik/treewalker.nvim" },
}
