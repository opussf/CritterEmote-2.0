local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Holiday_emotes = {
	["init"] = function()
		if not C_AddOns.IsAddOnLoaded("Blizzard_Calendar") then
			CritterEmote.Log(CritterEmote.Debug, "Blizzard_Calendar was not loaded.")
			UIParentLoadAddOn("Blizzard_Calendar")
		end
		C_Timer.After(10, function()
			CritterEmote.Log(CritterEmote.Debug, "Requesting calendar data...")
			C_Calendar.OpenCalendar()  -- trigger CALENDAR_UPDATE_EVENT_LIST
		end)
		CritterEmote.EventCallback("CALENDAR_UPDATE_EVENT_LIST", CritterEmote.Holiday_emotes.BuildActiveHolidays)
	end,
	["BuildActiveHolidays"] = function()
		CritterEmote.Log(CritterEmote.Error, "Call to GetCurrentActiveHolidays()")
		CritterEmote.activeHolidays = CritterEmote.GetCurrentActiveHolidays()
		for i,_ in ipairs(CritterEmote.Holiday_emotes) do -- clear possible emotes
			print(i,_)
			CritterEmote[i] = nil
		end
		for holiday, _ in pairs(CritterEmote.activeHolidays) do
			if CritterEmote.Holiday_emotes[holiday] then
				for _, emote in pairs(CritterEmote.Holiday_emotes[holiday]) do
					CritterEmote.Log(CritterEmote.Debug, "Adding to Holiday_emotes: "..emote)
					table.insert(CritterEmote.Holiday_emotes, emote)
				end
			end
		end
	end,
	["PickTable"] = function(self)
		if CritterEmote.activeHolidays then
			-- for k,_ in pairs( CritterEmote.activeHolidays ) do
			-- 	print("> "..k)
			-- end
			return self
		else
			C_Calendar.OpenCalendar()
		end
	end,
	["Feast of Winter Veil"] = {
		"dances around the festive tree.",
		"throws snowballs joyfully.",
		"sips hot cocoa.",
	},
	["Midsummer Fire Festival"] = {
		"jumps over the bonfire.",
		"dances around the flame.",
		"lights fireworks.",
	},
	["Brewfest"] = {
		"takes a deep drink from a mug of ale.",
		"stumbles around happily.",
		"cheers loudly.",
	},
	["Hallow's End"] = {
		"carves a pumpkin.",
		"laughs maniacally.",
		"spooks everyone around.",
	},
	["Love is in the Air"] = {
		"hands out love tokens.",
		"blows a kiss.",
		"throws rose petals.",
	},
	["Noblegarden"] = { },

	-- Add more holidays here...
}
end
