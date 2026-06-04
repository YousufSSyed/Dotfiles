return {
	{
		"okuuva/auto-save.nvim",
		enabled = true,
		lazy = false,
		opts = { debounce_delay = 2000 },
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		enabled = true,
	},
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
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				cmdline = {
					format = {
						cmdline = { title = "" },
						search_down = { title = "" },
						search_up = { title = "" },
						filter = { title = "" },
						lua = { title = "" },
						help = { title = "" },
						input = { title = "" },
					},
					border = {
						style = "none",
						padding = { 0, 0 },
					},
				},
				messages = {
					-- NOTE: If you enable messages, then the cmdline is enabled automatically.
					-- This is a current Neovim limitation.
					enabled = false, -- enables the Noice messages UI
				},
				commands = {
					errors = {
						-- options for the message history that you get with `:Noice`
						view = "",
						opts = { enter = true, format = "details" },
						filter = { error = true },
						filter_opts = { reverse = true },
					},
				},
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		enabled = true,
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = {
					enable = false,
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = false,
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
		-- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
		-- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
		-- available after the first executing of it or after a keymap of text-case.nvim has been used.
		lazy = false,
	},
	{
		"nvim-pack/nvim-spectre",
		lazy = false,
	},
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
		wo = {
			winbar = false,
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
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
	{
		"gbprod/substitute.nvim",
		enabled = false,
	},

	-- cmp plugins
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = false,
	},
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-buffer" },
	-- Plugins for markdown
	{
		"jakewvincent/mkdnflow.nvim",
		config = function()
			require("mkdnflow").setup({
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
			})
		end,
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
		lazy = false,
		opts = {
			render_modes = { "n", "c", "t", "i" },
			link = {
				enabled = true,
			},
			heading = {
				icons = { "􀀺  # ", "􀀼  ## ", "􀀾  ### ", "􀁀  #### ", "􀁂  ##### ", "􀁄  ###### " },
				signs = { "" },
				backgrounds = {},
				position = "inline",
			},
			bullet = {
				icons = { "-" },
			},
			checkbox = {
				unchecked = { icon = "􀂒 " },
				checked = { icon = "􀃲 ", highlight = "rainbow4" },
				custom = {
					cancelled = {
						-- highlight = "RenderMarkdownCancelled",
						highlight = "rainbow1",
						rendered = "􀃞 ",
						raw = "[-]",
					},
					incomplete = {
						-- highlight = "RenderMarkdownIncomplete",
						highlight = "rainbow2",
						rendered = "􀃮 ",
						raw = "[/]",
					},
				},
			},
			quote = { icon = "▎", repeat_linebreak = true },
			anti_conceal = { enabled = true },
			-- callout = {
			-- 	tip = { raw = '[!TIP]', rendered = '󰌶', highlight = 'RenderMarkdownSuccess', border = true },
			-- },
			--
			-- 
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		lazy = false,
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					path = "/home/yousuf/Assets/Obsidian",
					name = "Obsidian",
				},
			},
			ui = {
				enable = false,
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
			daily_notes = {
				date_format = "YYYY-MM-DD MMMM Do YYYY dddd",
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
		config = function()
			require("markdown-toggle").setup()
		end,
	},
	{
		"antonk52/markdowny.nvim",
		config = function()
			require("markdowny").setup()
		end,
	},
	{
		"echasnovski/mini.nvim",
		lazy = false,
		version = "*",
	},
	{ "opdavies/toggle-checkbox.nvim" },
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		keys = {
			{
				"<leader>fs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
	},
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
					noice = true,
					render_markdown = false,
					gitsigns = {
						enabled = true,
						transparent = false,
					},
					indent_blankline = {
						enabled = true,
						scope_color = "",
						colored_indent_levels = true,
					},
					mini = {
						enabled = true,
						indentscope_color = "",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
			vim.cmd(":hi @markup.strong guifg=none")
			vim.cmd(":hi @markup.italic guifg=none")
			vim.cmd(":hi @lsp.type.decorator.markdown guifg=#8fefe7")
			vim.cmd(":hi @markup.link.label guifg=#8fefe7")
			vim.cmd(":hi @markup.quote guifg=none")
			vim.cmd(":hi RenderMarkdownQuote guifg=#00608b")
			vim.cmd(":hi @markup.list.unchecked guifg=none")
			vim.cmd(":hi @markup.list.checked guifg=#02ad96")
			vim.cmd(":hi RenderMarkdownCancelled guifg=#ff5252")
			vim.cmd(":hi RenderMarkdownIncomplete guifg=#ff9354")
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
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"jay-babu/project.nvim",
		-- "ahmedkhalf/project.nvim",
		lazy = false,
		enabled = false,
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				unset_autochdir = false,
				patterns = { "^/Users/yousuf/Desktop/Obsidian" },
				exclude_dirs = { "^/Users/yousuf/.config/nvim" },
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
		opts = {
			db_version = "v2",
		},
	},
	{
		"tpope/vim-eunuch",
	},
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
			lineTheme.normal.a = { bg = "None", fg = nil, gui = nil }
			-- lineTheme.normal.a = { bg = "#001240", fg = C.blue, gui = nil }
			-- lineTheme.insert.a = { bg = "#003400", fg = C.green, gui = nil }
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
					lualine_b = { "branch", "diff", "diagnostics" },
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
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = true,
		main = "ibl",
		config = function()
			require("ibl").setup({
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
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
	},
	{
		-- "ColinKennedy/cursor-text-objects.nvim",
		"ColinKennedy/test-cursor-text-objects.nvim",
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
				open_win_override = {
					title = "",
				},
			},
			---sort by path
			---@param buffers snipe.Buffer[]
			---@return snipe.Buffer[]
			-- sort = "default",
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
			require("grug-far").setup({
				-- options, see Configuration section below
				-- there are no required options atm
				-- engine = 'ripgrep' is default, but 'astgrep' can be specified
			})
		end,
	},
	{
		"stevearc/conform.nvim",
	},
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
		cmd = "Trouble",
		keys = {
			{
				"<D-t>",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		enabled = false,
		config = function()
			require("colorizer").setup({
				user_default_options = {
					css = true,
					css_fn = true,
					mode = "virtualtext",
					virtualtext_inline = true,
					virtualtext = "󱓻",
				},
			})
		end,
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
			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
			"folke/snacks.nvim", -- optional
		},
	},
	{
		"smjonas/live-command.nvim",
		-- live-command supports semantic versioning via Git tags
		-- tag = "2.*",
		config = function()
			require("live-command").setup()
		end,
	},
	{
		"tridactyl/vim-tridactyl",
	},
	{
		"aaronik/treewalker.nvim",
		-- optional (see options below)
		opts = { ... },
	},
}
