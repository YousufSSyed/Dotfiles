local opts = { noremap = true, silent = true }

--  CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<leader>h", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<leader>j", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<leader>k", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<leader>l", "<C-w><C-l>", { desc = "Move focus to the right window" })

-- Digraph key
vim.keymap.set({ "i" }, "<D-k>", "<c-k>", { noremap = true })

-- Remap G and gg
vim.keymap.set({ "n", "v" }, "G", "G$", { silent = true })
vim.keymap.set({ "n", "v" }, "gg", "gg0", { silent = true })

-- Use Tab and CMD-[ or ] for indenting
vim.keymap.set("i", "<tab>", "<c-T>", { noremap = true })
vim.keymap.set("i", "<D-[>", "<c-T>", { noremap = true })
vim.keymap.set("i", "<D-]>", "<c-D>", { noremap = true })
vim.keymap.set("v", "<D-]>", ">", { noremap = true })
vim.keymap.set("v", "<D-[>", "<", { noremap = true })
vim.keymap.set("n", "<D-[>", ">>", { noremap = true })
vim.keymap.set("n", "<D-]>", "<<", { noremap = true })

-- leader [ ] for tab switching
vim.keymap.set({ "n" }, "<m-[>", "<cmd>tabprevious<cr>", opts)
vim.keymap.set({ "n" }, "<m-]>", "<cmd>tabnext<cr>", opts)

-- Hotkeys for buffer management
vim.keymap.set("n", "<leader>6", "<cmd>tabclose<cr>", opts)
vim.keymap.set({ "n", "v" }, "<D-w>", "<cmd>bprev<cr><cmd>bd#<cr>", opts)
vim.keymap.set({ "n", "v" }, "<D-e>", "<cmd>bnext<cr><cmd>bd#<cr>", opts)
vim.keymap.set({ "n", "v" }, "<leader>u", "<cmd>bprev<cr>", opts)
vim.keymap.set({ "n", "v" }, "<leader>i", "<cmd>bnext<cr>", opts)

-- Change down and up to gj and gk
vim.keymap.set({ "i" }, "<down>", "<C-o>gj", opts)
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

-- CMD-C to copy whole file
vim.keymap.set({ "n" }, "<D-c>", "<cmd>silent %y+<cr>")
vim.keymap.set({ "n" }, "<D-x>", "<cmd>silent %d+<cr>")

-- Delete-Backspace to move the current file to trash
vim.keymap.set("n", "<D-BS>", ":execute 'silent !trash ' . shellescape(@%) | bprev | bd#")

-- CTRL-J to create line breaks in normal mode
vim.keymap.set("n", "<c-j>", "i<cr><esc>h")

vim.keymap.set({ "v", "n" }, "<D-n>", function()
	local directory = os.getenv("HOME") .. "/Assets/Scratchpad/"
	local filename
	while true do
		vim.ui.input({ prompt = "New file name: " }, function(i)
			filename = i
		end)
		if filename == "" then
			break
		end
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
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>q", "<cmd>:close<cr>")
vim.keymap.set({ "n", "v", "i" }, "<D-s>", "<cmd>w!<cr>")

-- Swap ' and `
vim.keymap.set({ "n", "v", "o" }, "'", "`", { remap = false })
vim.keymap.set({ "n", "v", "o" }, "`", "'", { remap = false })

-- [[ Basic Keymaps ]], See `:help vim.keymap.set()`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Task hotkeys
local function changeTask(character)
	local firstline = vim.fn.line("v")
	local lastline = vim.fn.line(".")
	if firstline > lastline then
		firstline, lastline = lastline, firstline
	end
	vim.cmd(firstline .. "," .. lastline .. "s/\\(^\\s*- \\[\\).\\]/\\1" .. character .. "\\]")
end

vim.keymap.set("n", "<leader>t", function()
	require("toggle-checkbox").toggle()
end, opts)
vim.keymap.set({ "n", "v" }, "<leader>x", function()
	changeTask("x")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>-", function()
	changeTask("-")
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>/", function()
	changeTask("\\/")
end, { noremap = true, silent = true })

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
		vim.ui.input({ prompt = "Callout Title: " }, function(i)
			calloutTitle = i
		end)
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

vim.keymap.set({ "v", "n" }, "<M-b>", function()
	quote(false)
end, opts)
vim.keymap.set({ "v", "n" }, "<M-q>", unquote, opts)
--- Create callout
vim.keymap.set({ "v", "n" }, "<M-z>", function()
	quote(true)
end, opts)

vim.keymap.set("n", "<leader>p", "<cmd>MkdnCreateLinkFromClipboard<cr>")

-- <leader>p to put links in selection, taken from https://linkarzu.com/posts/neovim/markdown-setup-2024/
-- vim.keymap.set("v", "<leader>p", function()
-- 	vim.cmd("let @a = getreg('+')")
-- 	vim.cmd("normal d")
-- 	vim.cmd("startinsert")
-- 	vim.api.nvim_put({ "[]() " }, "c", true, true)
-- 	vim.cmd("normal F[pf(")
-- 	vim.cmd("call setreg('+', @a)")
-- 	vim.cmd("normal p")
-- 	vim.cmd("stopinsert")
-- end, { desc = "[P]Convert to link" })
