local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Faction_emotes = {
	["Init"] = function(self)
		local localizedFaction = select(2, UnitFactionGroup("player"))
		for _, e in pairs( self[localizedFaction] ) do
			table.insert(self, e)
		end
	end,
	Horde = { "yells, \"FOR THE HORDE!\"", },
	Alliance = { "yells, \"FOR THE ALLIANCE!\"", },
}
end
