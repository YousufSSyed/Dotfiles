keyopts = { noremap = true, silent = true }

-- Check the status of this issue: https://github.com/neovim/neovim/issues/39227
vim.keymap.set({ "n", "v" }, "u", ":silent undo<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "U", ":silent redo<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-r>", ":silent redo<cr>", { silent = true })

vim.keymap.set("n", "<leader><left>", "<C-w><C-h>") -- Window hotkeys
vim.keymap.set("n", "<leader><down>", "<C-w><C-j>")
vim.keymap.set("n", "<leader><up>", "<C-w><C-k>")
vim.keymap.set("n", "<leader><right>", "<C-w><C-l>")
vim.keymap.set("n", "<leader>h", "<cmd>vsplit<cr><C-w><C-h>")
vim.keymap.set("n", "<leader>j", "<cmd>split<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>split<cr><C-w><C-k>")
vim.keymap.set("n", "<leader>l", "<cmd>vsplit<cr>")

vim.keymap.set({ "n", "v" }, "G", "G$", { silent = true }) -- Remap G and gg
vim.keymap.set({ "n", "v" }, "gg", "gg0", { silent = true })

vim.keymap.set("i", "<C-tab>", "<c-T>", { noremap = true }) -- Use Tab for indenting
vim.keymap.set("i", "<S-tab>", "<c-D>", { noremap = true })
vim.keymap.set("v", "<S-tab>", ">", { noremap = true })
vim.keymap.set("v", "<C-tab>", "<", { noremap = true })
vim.keymap.set("n", "<C-tab>", ">>", { noremap = true })
vim.keymap.set("n", "<S-tab>", "<<", { noremap = true })

vim.keymap.set({ "n", "v" }, "<C-k>", "X<up>P", { remap = true }) -- Move lines up and down
vim.keymap.set({ "n", "v" }, "<C-j>", "Xp", { remap = true })

vim.keymap.set({ "n", "v" }, "<down>", "gj", keyopts) -- Change down and up to gj and gk
vim.keymap.set({ "n", "v" }, "<up>", "gk", keyopts)
vim.keymap.set("i", "<down>", "<C-o>gj", keyopts)
vim.keymap.set("i", "<up>", "<C-o>gk", keyopts)

-- Change some deleting and yanking motions
vim.keymap.set({ "n", "v" }, "d", '"_d', { noremap = true })
vim.keymap.set({ "n", "v" }, "D", '"_dd', { noremap = true })
vim.keymap.set({ "n", "v" }, "dd", '^"_d$', { noremap = true })
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true })
vim.keymap.set({ "n", "v" }, "x", "d", { noremap = true })
vim.keymap.set({ "n", "v" }, "xx", "^d$", { noremap = true })
vim.keymap.set({ "n", "v" }, "X", "dd", { noremap = true })
vim.keymap.set({ "n" }, "yy", "^y$", keyopts)
vim.keymap.set({ "n" }, "Y", "yy", keyopts)

-- Set CMD-V to paste
vim.keymap.set("n", "<C-v>", "<cmd>set paste<cr>p<cmd>set nopaste<cr>")
vim.keymap.set("i", "<C-v>", "<cmd>set paste<cr><c-O>p<cmd>set nopaste<cr>")
vim.keymap.set("c", "<C-v>", "<C-r>+")
vim.keymap.set({ "n" }, "<C-c>", "<cmd>silent %y+<cr>")
vim.keymap.set({ "n" }, "<C-x>", "<cmd>silent %d+<cr>")
vim.keymap.set({ "n" }, "<C-BS>", "<cmd>silent %d_<cr>")
vim.keymap.set("n", "<S-BS>", "<cmd>execute 'silent !trash ' . shellescape(@%) | bprev | bd#<cr>")

function mark(cmd)
	local count = vim.v.count > 0 and vim.v.count or ""
	vim.api.nvim_feedkeys("mz" .. count .. cmd .. "\27`z:delmarks z\13", "n", false)
end
vim.keymap.set({ "n", "v", "o" }, "<leader>[z", function() mark("[sz=") end)
vim.keymap.set({ "n", "v", "o" }, "<leader>]z", function() mark("]sz=") end)
vim.keymap.set({ "n", "v", "o" }, "<leader>[s", function() mark("[s1z=") end)
vim.keymap.set({ "n", "v", "o" }, "<leader>]s", function() mark("]s1z=") end)
vim.keymap.set({ "n", "v", "o" }, "<leader>[g", function() mark("[szg") end)
vim.keymap.set({ "n", "v", "o" }, "<leader>]g", function() mark("]szg") end)
vim.keymap.set("n", "<CR>", function() mark("o") end) -- Insert blank lines above & below
vim.keymap.set("n", "<S-CR>", function() mark("O") end)

vim.cmd("packadd nvim.undotree") -- Misc keymaps
vim.keymap.set("n", "<leader>u", require("undotree").open)
vim.keymap.set({ "n", "v" }, "<leader>w", "<cmd>bprev<cr><cmd>bd!#<cr>", keyopts)
vim.keymap.set({ "n", "v" }, "<leader>q", "<cmd>:q<cr>")
vim.keymap.set({ "n", "v" }, "<leader>r", "<cmd>:restart<cr>")
vim.keymap.set({ "n", "v", "i" }, "<C-s>", "<cmd>w!<cr>")
vim.keymap.set({ "n" }, "<C-d>", "<cmd>silent %d_<cr>")
vim.keymap.set({ "n", "v", "o" }, "'", "`") -- Swap ' and `
vim.keymap.set("n", "J", function() mark("J") end) -- Keep cursor in place when joining lines
vim.keymap.set("n", "ycc", "Ygccp", { remap = true }) -- Comment the current line then paste it below
vim.keymap.set({ "n" }, "A", "$", { noremap = true })

vim.keymap.set("n", "<Esc>", function()
	vim.defer_fn(function() vim.opt.cursorline = false end, 1000)
	vim.cmd("set cursorline | nohlsearch")
end)

vim.keymap.set({ "v", "n" }, "<c-n>", function()
	local directory = os.getenv("HOME") .. "/Sync/Scratchpad/"
	local filename
	while true do
		vim.ui.input({ prompt = "New file name: " }, function(i) filename = i end)
		if filename == "" then break end
		if not io.open(directory .. filename, "r") then
			vim.cmd("edit " .. directory .. filename)
			return
		end
	end
	local filenumber = 0
	while true do
		local newfile = directory .. "Untitled-" .. filenumber .. ".md"
		if not io.open(newfile, "r") then
			vim.cmd("edit " .. newfile)
			return
		end
		filenumber = filenumber + 1
	end
end)

vim.keymap.set({ "v", "n" }, "<C-t>", function()
	local output = vim.fn.system("ls")
	print(output)
end)
