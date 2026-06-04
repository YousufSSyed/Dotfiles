-- ~/.config/yazi/init.lua
-- require("bookmarks"):setup({
-- 	last_directory = { enable = false, persist = false },
-- 	persist = "all",
-- 	desc_format = "full",
-- 	file_pick_mode = "hover",
-- 	notify = {
-- 		enable = false,
-- 		timeout = 1,
-- 		message = {
-- 			new = "New bookmark '<key>' -> '<folder>'",
-- 			delete = "Deleted bookmark in '<key>'",
-- 			delete_all = "Deleted all bookmarks",
-- 		},
-- 	},
-- })

-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	time = os.date("%y-%m-%d %I:%M%p", time)
	local size = self._file:size()
	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end

-- require("folder-rules"):setup()
-- require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })
--
-- require("zoxide"):setup({
-- 	update_db = true,
-- })
