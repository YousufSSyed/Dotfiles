mp.observe_property("pause", "bool", function()
	mp.command("write-watch-later-config")
end)
