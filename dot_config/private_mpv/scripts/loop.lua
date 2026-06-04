if mp.get_property_native("options/script-opts")["loop"] == "yes" then
	local msg = require("mp.msg")
	local utils = require("mp.utils")
	local JSON_FILE = "/home/yousuf/Assets/Misc/video_info.json"
	package.path = mp.command_native({ "expand-path", "/home/yousuf/.config/mpv/script-modules/?.lua;" })
		.. package.path
	local json = require("dkjson")

	local function read_json()
		local file = io.open(JSON_FILE, "r")
		if not file then
			return {}
		end

		local content = file:read("*all")
		file:close()
		if content == "" then
			return {}
		end

		local data = utils.parse_json(content)
		return data or {}
	end

	local function write_json(data)
		local file = io.open(JSON_FILE, "w")
		file:write(json.encode(data, { indent = true }))
		file:close()
		return true
	end

	function record_info(name, value)
		if
			(not value or math.abs(value - data[filename].endtime) >= 1)
			or (data[filename].lastwatched and os.time(os.date("!*t")) - data[filename].lastwatched <= 2)
		then
			return
		end

		data = read_json()
		data[filename].lastwatched = os.time(os.date("!*t"))
		data[filename].watchcount = (data[filename].watchcount or 0) + 1
		data[filename].firstwatched = data[filename].firstwatched or os.time(os.date("!*t"))
		msg.info(write_json(data) and "repeat count: " .. data[filename].watchcount or "File not saved.")
	end

	mp.set_property("resume-playback", "no")
	mp.set_property("loop-file", "yes")
	data = read_json()
	filename = nil
	starttime = mp.get_property_number("ab-loop-a")
	endtime = mp.get_property_number("ab-loop-b")

	mp.register_event("file-loaded", function()
		filename = mp.get_property("filename/no-ext")
		data[filename] = data[filename] or {}
		data[filename].starttime = starttime or data[filename].starttime or "0"
		data[filename].endtime = endtime or data[filename].endtime or tostring(mp.get_property("duration"))
		write_json(data)
		mp.set_property("ab-loop-a", data[filename].starttime)
		mp.set_property("ab-loop-b", data[filename].endtime)
		mp.commandv("seek", data[filename].starttime, "absolute", "exact")
		mp.observe_property("time-pos", "number", record_info)
	end)
end
