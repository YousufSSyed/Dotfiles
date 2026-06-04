vim.keymap.set({ "n", "v" }, "<leader>`", function()
	local s_pos = vim.fn.getpos("v")
	local e_pos = vim.fn.getpos(".") -- Note: getregion handles the order of positions and visual mode types automatically
	vim.snippet.expand(
		"````${1:lang}\n" .. table.concat(vim.fn.getregion(s_pos, e_pos)) .. "\n````"
	)
end)

-- Luasnip config
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
ls.setup({ store_selection_keys = "<tab>" })
local fmt = require("luasnip.extras.fmt").fmt

-- Snippets

local mdCodeBlock = s(
	{ trig = "````", name = "Codeblock" },
	fmt(
		[[
    ````{}
		$TM_SELECTED_TEXT
    ````
    ]],
		{ i(1) }
	)
)

local customSpan =
	s({ trig = "sspan", name = "Custom Span" }, fmt('<span style="{}">{}</span>', { i(1), i(2) }))
local mdBold = s({ name = "MDBold" }, fmt("**{}**", { i(1) }))
local tagParagraph = s({ name = "TagParagraph" }, fmt("#{} #{}.", { i(1), i(1) }))
local InsertCallout = s(
	{ name = "InsertCallout" },
	fmt(
		[[[!{}]
> ]],
		{ i(1) }
	)
)
ls.add_snippets("all", { mdCodeBlock, customSpan, mdBold, tagParagraph, InsertCallout })

vim.keymap.set({ "i" }, "<m-l>l", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<m-k>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<m-j>", function() ls.jump(-1) end, { silent = true })

-- vim.keymap.set({ "n" }, "<leader>`", function()
-- 	require("luasnip").snip_expand(mdCodeBlock)
-- end)

vim.keymap.set({ "i" }, "<D-t>", function() require("luasnip").snip_expand(tagParagraph) end)
vim.keymap.set({ "i" }, "<D-b>", function() require("luasnip").snip_expand(mdBold) end)
vim.keymap.set({ "n" }, "<leader>c", function() require("luasnip").snip_expand(InsertCallout) end)

vim.api.nvim_create_autocmd("vimenter", {
	pattern = "*",
	callback = function()
		if vim.o.filetype == "lazy" then vim.cmd.close() end
		require("telescope").load_extension("persisted")
		vim.cmd(":Telescope persisted")
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			pattern = "*",
			callback = function() vim.cmd(":Persisted save") end,
		})
	end,
	nested = true,
})
