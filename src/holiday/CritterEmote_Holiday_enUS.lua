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
		CritterEmote.Log(CritterEmote.Debug, "Call to GetCurrentActiveHolidays()")
		CritterEmote.activeHolidays = CritterEmote.GetCurrentActiveHolidays()
		for i,_ in ipairs(CritterEmote.Holiday_emotes) do -- clear possible emotes
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
		"chases a floating candy corn as if it were a deadly foe.",
		"lets out a terrifying \“boo!\” that's only slightly adorable.",
		"hides under a pumpkin, convinced it's the perfect disguise.",
		"sniffs the air and shivers — something spooky this way comes.",
		"tries to howl at the moon… but it comes out as a squeak.",
		"bats at a ghostly wisp, clearly winning the fight.",
		"jumps at its own shadow and pretends it was just practicing.",
		"proudly wears a leaf on its head — it's a costume now.",
		"attempts to carve a pumpkin... with questionable results.",
		"sneezes glittering bat wings into the air. Where did those come from?",
		"cackles quietly to itself. That's... probably fine.",
		"drops a candy wrapper and looks innocent.",
		"eyes your candy bucket with suspicious intensity.",
		"stares at an empty corner and growls. You see nothing there.",
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
