local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Faction_emotes = {
	["Init"] = function(self)
		local localizedFaction = select(2, UnitFactionGroup("player"))
		for _, e in pairs( self[localizedFaction] ) do
			table.insert(self, e)
		end
	end,
	Horde = {
		"yells, \"FOR THE HORDE!\"",
		"yells, \"Lok'tar Ogar!\"",
		"yells, \"The Horde endures!\"",
		"yells, \"Zug zug!\"",
		"yells, \"For the Warchief!\"",
		"yells, \"Strength and honor!\"",
	},
	Alliance = {
		"yells, \"FOR THE ALLIANCE!\"",
		"yells, \"FOR AZEROTH!\"",
		"yells, \"For Lordaeron!\"",
		"yells, \"For Stormwind!\"",
		"yells, \"For the King!\"",
	},
}
end
