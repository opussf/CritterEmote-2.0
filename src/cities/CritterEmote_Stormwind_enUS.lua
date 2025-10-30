local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Stormwind_emotes = {
	["PickTable"] = function(self)
		if GetZoneText() == "Stormwind City" then
			return self
		end
	end,
	"looks at all the buildings.",
	"wants to explore the Mage Quarter.",
	"wonders if the King is home.",
	["Uuna"] = { "wants to see her friends in the orphanage", },
}
end