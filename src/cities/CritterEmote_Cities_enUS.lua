local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.City_emotes = {
	["PickTable"] = function(self)
		CritterEmote.Log(CritterEmote.Debug, "Cities: "..GetZoneText())
		return self[GetZoneText()]  -- "Stormwind City", etc.
	end,
	["Stormwind City"] = {
		"looks at all the buildings.",
		"wants to explore the Mage Quarter.",
		"wonders if the King is home.",
		["dog"] = { "pees on the nearest tree." },
		["Uuna"] = { "wants to see her friends in the orphanage", },
	},
	["Silvermoon City"] = {
		"is amazed by the rebuilt Silvermoon City.",
		"is excited to see the shining towers of Silvermoon City.",
		"thinks the Light of Quel'Thalas's Sunwell feels different.",
	},
}
end