opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v" }, "<C-d>", "5<C-d>")
vim.keymap.set({ "n", "v" }, "<C-u>", "5<C-u>")

-- Insert blank lines above & below
vim.keymap.set("n", "<leader>j", "o<esc><up>")
vim.keymap.set("n", "<leader>k", "O<esc><down>")

-- Window hotkeys
vim.keymap.set("n", "<leader>wh", "<C-w><C-h>")
vim.keymap.set("n", "<leader>wj", "<C-w><C-j>")
vim.keymap.set("n", "<leader>wk", "<C-w><C-k>")
vim.keymap.set("n", "<leader>wl", "<C-w><C-l>")
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>")
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>")

-- Digraph key
vim.keymap.set({ "i" }, "<D-k>", "<c-k>", { noremap = true })

-- Remap G and gg
vim.keymap.set({ "n", "v" }, "G", "G$", { silent = true })
vim.keymap.set({ "n", "v" }, "gg", "gg0", { silent = true })

-- Use Tab for indenting
vim.keymap.set("i", "<C-tab>", "<c-T>", { noremap = true })
vim.keymap.set("i", "<S-tab>", "<c-D>", { noremap = true })
vim.keymap.set("v", "<S-tab>", ">", { noremap = true })
vim.keymap.set("v", "<C-tab>", "<", { noremap = true })
vim.keymap.set("n", "<C-tab>", ">>", { noremap = true })
vim.keymap.set("n", "<S-tab>", "<<", { noremap = true })

-- leader [ ] for tab switching
vim.keymap.set({ "n" }, "<m-[>", "<cmd>tabprevious<cr>", opts)
vim.keymap.set({ "n" }, "<m-]>", "<cmd>tabnext<cr>", opts)

-- Hotkeys for buffer management
vim.keymap.set("n", "<leader>6", "<cmd>tabclose<cr>", opts)
vim.keymap.set({ "n", "v" }, "<D-w>", "<cmd>bprev<cr><cmd>bd#<cr>", opts)
vim.keymap.set({ "n", "v" }, "<leader>i", "<cmd>b#<cr>", opts)

-- Move lines up and down
vim.keymap.set({ "n", "v" }, "<M-k>", "X<up>P", { remap = true })
vim.keymap.set({ "n", "v" }, "<M-j>", "Xp", { remap = true })

-- Change down and up to gj and gk
vim.keymap.set("i", "<down>", "<C-o>gj", opts)
vim.keymap.set("i", "<up>", "<C-o>gk", opts)
vim.keymap.set({ "n", "v" }, "<down>", "gj", opts)
vim.keymap.set({ "n", "v" }, "<up>", "gk", opts)

-- Change some deleting and yanking motions
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true })
vim.keymap.set({ "n", "v" }, "D", '"_dd', { noremap = true })
vim.keymap.set({ "n", "v" }, "dd", '^"_d$', { noremap = true })
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true })
vim.keymap.set({ "n", "v" }, "x", "d", { noremap = true })
vim.keymap.set({ "n", "v" }, "xx", "^d$", { noremap = true })
vim.keymap.set({ "n", "v" }, "X", "dd", { noremap = true })
vim.keymap.set({ "n", "v" }, "<D-x>", "x", { noremap = true })
vim.keymap.set({ "n" }, "yy", "^y$", opts)
vim.keymap.set({ "n" }, "Y", "yy", opts)

-- Set CMD-V to paste
vim.keymap.set("n", "<D-v>", "<cmd>set paste<cr>p<cmd>set nopaste<cr>")
vim.keymap.set("i", "<D-v>", "<cmd>set paste<cr><c-O>p<cmd>set nopaste<cr>")
vim.keymap.set("c", "<D-v>", "<C-r>+")

vim.keymap.set({ "n" }, "<D-c>", "<cmd>silent %y+<cr>")
vim.keymap.set({ "n" }, "<D-x>", "<cmd>silent %d+<cr>")
vim.keymap.set({ "n" }, "<D-d>", "<cmd>silent %d_<cr>")

vim.keymap.set("n", "<S-BS>", "<cmd>execute 'silent !trash ' . shellescape(@%) | bprev | bd#<cr>")

vim.keymap.set({ "v", "n" }, "<D-n>", function()
	local directory = os.getenv("HOME") .. "/Assets/Scratchpad/"
	local filename
	while true do
		vim.ui.input({ prompt = "New file name: " }, function(i) filename = i end)
		if filename == "" then break end
		if not io.open(directory .. filename, "r") then
			vim.cmd(":edit " .. directory .. filename)
			return
		end
	end
	local filenumber = 0
	while true do
		local newfile = directory .. "Untitled-" .. filenumber .. ".md"
		if not io.open(newfile, "r") then
			vim.cmd(":edit " .. newfile)
			return
		end
		filenumber = filenumber + 1
	end
end)

-- Misc Keymaps
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)
vim.keymap.set({ "n", "v" }, "<leader>q", "<cmd>:q<cr>")
vim.keymap.set({ "n", "v" }, "<leader>r", "<cmd>:restart<cr>")
vim.keymap.set({ "n", "v", "i" }, "<D-s>", "<cmd>w!<cr>")
vim.keymap.set({ "n" }, "<D-d>", "<cmd>silent %d_<cr>")
vim.keymap.set({ "n", "v", "o" }, "'", "`", { remap = false }) -- Swap ' and `
vim.keymap.set({ "n", "v", "o" }, "<C-g>u<Esc>[s1z=gi<C-g>u", "1z=", { remap = false })
vim.keymap.set("n", "ycc", "Ygccp", { remap = true })

-- [[ Basic Keymaps ]], See `:help vim.keymap.set()`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Diagnostic keymaps
vim.keymap.set(
	"n",
	"[d",
	vim.diagnostic.goto_prev,
	{ desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set(
	"n",
	"<leader>e",
	vim.diagnostic.open_float,
	{ desc = "Show diagnostic [E]rror messages" }
)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set("n", "J", "mzJ`z:delmarks z<cr>") -- Keep cursor in place when joining lines

-- Task hotkeys
local function changeTask(character)
	local firstline = vim.fn.line("v")
	local lastline = vim.fn.line(".")
	if firstline > lastline then
		firstline, lastline = lastline, firstline
	end
	vim.cmd(firstline .. "," .. lastline .. "s/\\(^\\s*- \\[\\).\\]/\\1" .. character .. "\\]")
end

vim.keymap.set({ "n", "v" }, "<leader>t", function() require("toggle-checkbox").toggle() end, opts)
vim.keymap.set({ "n", "v" }, "<leader>x", function() changeTask("x") end, opts)
vim.keymap.set({ "n", "v" }, "<leader>-", function() changeTask("-") end, opts)
vim.keymap.set({ "n", "v" }, "<leader>/", function() changeTask("\\/") end, opts)

-- Quote Hotkeys
local function quote(callout)
	local firstline = vim.fn.line("v")
	local lastline = vim.fn.line(".")
	local quotes = string.match(vim.fn.getline("."), "^[>%s]*")
	quotes = quotes and quotes .. "> " or "> "
	if firstline > lastline then
		firstline, lastline = lastline, firstline
	end
	pcall(vim.cmd, firstline .. "," .. lastline .. "s/^\\(>\\|\\s\\)\\+//")
	vim.cmd(firstline .. "," .. lastline .. "s/^/" .. quotes .. "/")
	if callout then
		vim.ui.input({ prompt = "Callout Title: " }, function(i) calloutTitle = i end)
		vim.fn.append(firstline - 1, quotes .. "[!" .. calloutTitle .. "]")
	end
	vim.cmd("noh")
end

local function unquote()
	local firstline = vim.fn.line("v")
	local lastline = vim.api.nvim_win_get_cursor(0)[1]
	if firstline > lastline then
		firstline, lastline = lastline, firstline
	end
	local r = vim.fn.winsaveview()
	vim.cmd(firstline .. "," .. lastline .. [[g/>\s\+\[!/d]])
	if firstline == lastline then
		vim.cmd("s/^> //")
	else
		vim.cmd(firstline .. "," .. lastline .. "s/^> //")
	end
	vim.fn.winrestview(r)
end

vim.keymap.set({ "v", "n" }, "<M-b>", function() quote(false) end, opts)
vim.keymap.set({ "v", "n" }, "<M-q>", function() unquote() end, opts)

--- Create callout
vim.keymap.set({ "v", "n" }, "<M-z>", function() quote(true) end)

vim.keymap.set({ "n", "v" }, "<leader>p", "<cmd>MkdnCreateLinkFromClipboard<cr>")

vim.keymap.set(
	{ "x" },
	"[n",
	function() require("vim.treesitter._select").select_prev(vim.v.count1) end,
	{ desc = "Select previous treesitter node" }
)

vim.keymap.set(
	{ "x" },
	"]n",
	function() require("vim.treesitter._select").select_next(vim.v.count1) end,
	{ desc = "Select next treesitter node" }
)

vim.keymap.set({ "x", "o" }, "an", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "x", "o" }, "in", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
