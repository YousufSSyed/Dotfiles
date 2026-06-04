-- Task hotkeys
local function changeTask(character)
  local firstline = vim.fn.line("v")
  local lastline = vim.fn.line(".")
  if firstline > lastline then firstline, lastline = lastline, firstline end
  vim.cmd(firstline .. "," .. lastline .. "s/\\(^\\s*- \\[\\).\\]/\\1"..character.."\\]")
end

vim.api.nvim_buf_set_keymap(0, "n", "<leader>t", ":lua require('toggle-checkbox').toggle()<CR>")
vim.api.nvim_buf_set_keymap(0, {'n', 'v'}, '<leader>x', function() changeTask("x") end, { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, {'n', 'v'}, '<leader>-', function() changeTask("-") end, { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, {'n', 'v'}, '<leader>/', function() changeTask("\\/") end, { noremap = true, silent = true })

-- Quote Hotkeys
local function quote(callout)
  local firstline = vim.fn.line("v")
  local lastline = vim.fn.line(".")
  local quotes = string.match(vim.fn.getline("."), "^[>%s]*")
  quotes = quotes and quotes.."> " or "> "
  if firstline > lastline then firstline, lastline = lastline, firstline end
  pcall(vim.cmd, firstline .. "," .. lastline .. "s/^\\(>\\|\\s\\)\\+//")
  vim.cmd(firstline .. "," .. lastline .. "s/^/"..quotes.."/")
  if callout then vim.fn.append(firstline - 1, quotes.."[!"..vim.ui.input("Callout Title: ").."]") end
  vim.cmd("noh")
end

local function unquote()
  local firstline = vim.fn.line("v")
  local lastline = vim.api.nvim_win_get_cursor(0)[1]
  if firstline > lastline then firstline, lastline = lastline, firstline end
  local r = vim.fn.winsaveview()
  vim.cmd(firstline .. "," .. lastline .. [[g/>\s\+\[!/d]])
  if firstline == lastline then
    vim.cmd("s/^> //")
  else
    vim.cmd(firstline .. "," .. lastline .. "s/^> //")
  end
  vim.fn.winrestview(r)
end

vim.api.nvim_buf_set_keymap(0, {"v", "n"}, "<M-b>", function() quote(false) end, opts)
vim.api.nvim_buf_set_keymap(0, {"v", "n"}, "<M-q>", unquote, opts)
--- Create callout
vim.api.nvim_buf_set_keymap(0, {"v", "n"}, "<M-z>", function() quote(true) end, opts)

-- <leader>p to put links in selection, taken from https://linkarzu.com/posts/neovim/markdown-setup-2024/
vim.api.nvim_buf_set_keymap(0, "v", "<leader>p", function()
  vim.cmd("let @a = getreg('+')")
  vim.cmd("normal d")
  vim.cmd("startinsert")
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  vim.cmd("normal F[pf(")
  vim.cmd("call setreg('+', @a)")
  vim.cmd("normal p")
  vim.cmd("stopinsert")
end, { desc = "[P]Convert to link" })


-- CTRL Markdown keymaps 
vim.api.nvim_buf_set_keymap(0, {"i", "n"}, "<D-b>", function() vim.cmd(":i sab") end)
vim.api.nvim_buf_set_keymap(0, {"i", "n"}, "<D-i>", function() vim.cmd(":i **") vim.cmd(":i **") end)
