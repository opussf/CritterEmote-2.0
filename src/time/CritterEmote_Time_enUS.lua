local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Time_emotes = {
	["PickTable"] = function(self)
		local month = tonumber(date("%m"))
		print(month, self[month])
		return self[month] or self
	end,
	[1] = {
		"would like to mentor the next generation of pets.",
		"gave blood, and not in combat.",
	}
	[4] = {
		"hides the book of poems they are reading.",
	},
	[9] = {
		"wants to head to the library to get their library card.",
	},
	[10] = {
		"has a book picked out for National Book Month.",
	},
	[11] = {
		"starts to think about how to work this into their memoir.",
		"ponders if they could actually finish that novel this month.",
		"just wants to curl up next to the fire with a good book.",

	},
	"asks what is this month's national event?",
}
end
