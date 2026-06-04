local dateFormat = "%Y-%m-%d %H:%M"

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = true,
		branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				buffers = {
					leave_dirs_open = true,
					bind_to_cwd = false,
					follow_current_file = {
						enabled = true,
						leave_dirs_open = true,
					},
				},
				use_libuv_file_watcher = true,
			})
		end,
	},
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
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local servers = {
						-- clangd = {},
						-- pyright = {},
						-- rust_analyzer = {},
						-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
						--
						-- Some languages (like typescript) have entire language plugins that can be useful:
						--    https://github.com/pmizio/typescript-tools.nvim
						--
						-- But for many setups, the LSP (`ts_ls`) will work just fine
						-- ts_ls = {},
						--
						gopls = {
							settings = {
								gopls = {
									gofumpt = true,
									codelenses = {
										gc_details = false,
										generate = true,
										regenerate_cgo = true,
										run_govulncheck = true,
										test = true,
										tidy = true,
										upgrade_dependency = true,
										vendor = true,
									},
									hints = {
										assignVariableTypes = true,
										compositeLiteralFields = true,
										compositeLiteralTypes = true,
										constantValues = true,
										functionTypeParameters = true,
										parameterNames = true,
										rangeVariableTypes = true,
									},
									analyses = {
										fieldalignment = true,
										nilness = true,
										unusedparams = true,
										unusedwrite = true,
										useany = true,
									},
									usePlaceholders = true,
									completeUnimported = true,
									staticcheck = true,
									directoryFilters = {
										"-.git",
										"-.vscode",
										"-.idea",
										"-.vscode-test",
										"-node_modules",
									},
									semanticTokens = true,
								},
							},
						},

						lua_ls = {
							-- cmd = { ... },
							-- filetypes = { ... },
							-- capabilities = {},
							settings = {
								Lua = {
									completion = {
										callSnippet = "Replace",
									},
									-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
									-- diagnostics = { disable = { 'missing-fields' } },
								},
							},
						},
					}
				end,
			})
		end,
	},
	{
		"OXY2DEV/helpview.nvim",
		enabled = true,
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"html",
				"help",
				"css",
				"lua",
				"luau",
				"markdown",
				"rust",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"python",
				"typescript",
				"tsx",
				"swift",
				"markdown_inline",
				"nix",
				"hyprlang",
			},
			auto_install = true,
		},
		lazy = false,
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
					-- only show help buffers
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
	{
		"RRethy/vim-illuminate",
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
	{ "mtoohey31/cmp-fish", ft = "fish" },
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
		enabled = false, -- Recommended
		-- ft = "markdown" -- If you decide to lazy-load anyway
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		opts = {
			link = {
				enabled = false,
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
				unchecked = {
					icon = "􀂒 ",
				},
			},
			-- callout = {
			-- 	tip = { raw = '[!TIP]', rendered = '󰌶', highlight = 'RenderMarkdownSuccess', border = true },
			-- },
		},
	},
	-- {
	--     'altermo/ultimate-autopair.nvim',
	--     event={'InsertEnter','CmdlineEnter'},
	--     branch='v0.6', --recommended as each new version will have breaking changes
	--     opts={
	-- 				{'*,','*',ft={"markdown"}}
	--     },
	-- },
	-- {
	--     'windwp/nvim-autopairs',
	-- 		enabled = true,
	--     event = "InsertEnter",
	--     config = true
	--     -- use opts = {} for passing setup options
	--     -- this is equivalent to setup({}) function
	-- },
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			daily_notes = {
				date_format = "%Y-%m-%d",
			},
			dir = "~/Assets/Personal-Vault",
			templates = {
				folder = "(1) Obsidian Notes & Files",
				date_format = dateFormat,
			},
			ui = {
				enable = false,
			},
			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				-- Toggle check-boxes.
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},
			---@return table
			note_frontmatter_func = function(note)
				local out = {}
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,
			callbacks = {
				-- Runs right before writing the buffer for a note.
				---@param client obsidian.Client
				---@param note obsidian.Note
				---@diagnostic disable-next-line: unused-local
				pre_write_note = function(client, note)
					return -- this function is disabled for now
						note:add_field("Date Modified", os.date(dateFormat))
				end,
			},
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
		"oflisback/obsidian-bridge.nvim",
		config = function()
			require("obsidian-bridge").setup({
				scroll_sync = true,
			})
		end,
		event = {
			"BufReadPre *.md",
			"BufNewFile *.md",
		},
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
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
		"zbirenbaum/neodim",
		event = "LspAttach",
		config = function()
			require("neodim").setup({
				alpha = 0.75,
				blend_color = "#000000",
				hide = {
					underline = true,
					virtual_text = true,
					signs = true,
				},
				regex = {
					"[uU]nused",
					"[nN]ever [rR]ead",
					"[nN]ot [rR]ead",
				},
				priority = 128,
				disable = {},
			})
		end,
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
		"Gelio/cmp-natdat",
		config = function()
			require("cmp_natdat").setup({
				cmp_kind_text = "NatDat",
				highlight_group = "Red",
			})
		end,
	},
	{
		"folke/persistence.nvim",
		enabled = fresh(),
		event = "BufReadPre",
		opts = {},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
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
				patterns = { "^/Users/yousuf/Desktop/Personal-Vault" },
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
		enabled = not vim.env.KITTY_SCROLLBACK_NVIM,
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
	{ "nvchad/menu", lazy = true, dependencies = { "nvchad/volt" } },
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = true,
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		config = function()
			require("ibl").setup({})
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
		"mbbill/undotree",
	},
	{
		"debugloop/telescope-undo.nvim",
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
	{ "napisani/nvim-github-codesearch", build = "make" },
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
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				-- vim.cmd.colorscheme("catppuccin-latte")
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
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
	{ "Tastyep/structlog.nvim" },
	{
		"mikesmithgh/kitty-scrollback.nvim",
		lazy = true,
		cmd = {
			"KittyScrollbackGenerateKittens",
			"KittyScrollbackCheckHealth",
			"KittyScrollbackGenerateCommandLineEditing",
		},
		event = { "User KittyScrollbackLaunch" },
		config = function()
			require("kitty-scrollback").setup({
				{
					paste_window = {
						yank_register_enabled = false,
					},
					status_window = {
						autoclose = false, -- <-- set this to false
					},
				},
			})
		end,
	},
}
