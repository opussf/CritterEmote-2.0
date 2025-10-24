-- CritterEmote Core Module
CritterEmote_SLUG, CritterEmote = ...
CritterEmote.ADDONNAME = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Title" )
CritterEmote.VERSION   = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Version" )
CritterEmote.AUTHOR    = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Author" )

CritterEmote.Colors = {
	print = "|cff00ff00",
	reset = "|r",
}
CritterEmote.Error = 1
CritterEmote.Warn  = 2
CritterEmote.Info  = 3
CritterEmote.Debug = 4
CritterEmote.LogNames = { "Error", "Warn", "Info", "Debug" }

CritterEmote.Categories = {
	"General", "Silly", "Song", "Location", "Special", "PVP"
}

CritterEmote_Variables = {}
CritterEmote_CharacterVariables = {}

CritterEmote_Variables.Categories = {
  General = true,
  Silly = true,
  Song = true,
  Location = true,
  Special = true,
  PVP = true,
}
CritterEmote_Variables.enabled = true
CritterEmote_Variables.randomEnabled = true
CritterEmote_Variables.baseInterval = 300
CritterEmote_Variables.minRange = 30
CritterEmote_Variables.maxRange = 400
CritterEmote_Variables.logLevel = CritterEmote.Debug -- Set the default logLevel

function CritterEmote.Print(msg, showName)
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = CritterEmote.Colors.print..CritterEmote.ADDONNAME.."> "..CritterEmote.Colors.reset..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end
function CritterEmote.Log(level, msg)
	if level <= CritterEmote_Variables.logLevel then
		CritterEmote.Print(CritterEmote.LogNames[level]..": "..msg)
	end
end
--Any formating functions for displaying the emote
function CritterEmote.DisplayEmote(message)
	-- this adds the players name to message and sets emoteToSend
	CritterEmote.Log(CritterEmote.Debug, "DisplayEmote("..message..")")
	local nameAdd = string.sub(CritterEmote.playerName, -1) == "s" and ' ' or ': '
	CritterEmote.emoteToSend = nameAdd..message
end
function CritterEmote.OnLoad()
	hooksecurefunc("DoEmote", CritterEmote.OnEmote)
	CritterEmoteFrame:RegisterEvent("LOADING_SCREEN_DISABLED")

	SLASH_CRITTEREMOTE1 = "/ce"
	SlashCmdList["CRITTEREMOTE"] = CritterEmote.SlashHandler
	CritterEmote.playerName = UnitName("player", false)
	CritterEmote.lastUpdate = 0
	CritterEmote.updateInterval = CritterEmote.CreateUpdateInterval()
end
function CritterEmote.LOADING_SCREEN_DISABLED()
	CritterEmote.lastUpdate = time()
end
function CritterEmote.OnEmote(emote, target)
	CritterEmote.Log(CritterEmote.Debug, "OnEmote( "..emote..", "..(target or "nil").." - "..(target and #target or "nil")..")")
	if target and #target < 1 then
		if CritterEmote.GetTargetPetsOwner() then
			-- since this returns truthy on if the pet is the player's, no reason to store a value.
			-- debug, if desired, can use CritterEmote.playerName
			CritterEmote.Log(CritterEmote.Info, "Trigger an emote response.")
			CritterEmote.DoCritterEmote(emote, true)
		end
	end
end
function CritterEmote.OnUpdate(elapsed)
	if CritterEmote_Variables.enabled then
		if CritterEmote.emoteToSend then
			CritterEmote.emoteTimer = CritterEmote.emoteTimer and CritterEmote.emoteTimer + elapsed or elapsed
			if CritterEmote.emoteTimer > 0.5 then
				SendChatMessage(CritterEmote.emoteToSend, "EMOTE")
				CritterEmote.emoteToSend = nil
				CritterEmote.emoteTimer = nil
			end
		end
		if CritterEmote_Variables.randomEnabled then
			if (CritterEmote.lastUpdate + CritterEmote.updateInterval < time() and
					not UnitAffectingCombat("player") ) then
				CritterEmote.Log(CritterEmote.Info, "Random interval time elapsed.")
				CritterEmote.DoCritterEmote()
				CritterEmote.lastUpdate = time()
			end
		end
	end
end
function CritterEmote.GetTargetPetsOwner()
	-- this is probably misnamed, should probably be IsPetOwnedByPlayer() and return truthy values.  Though, returning the name would be true.
	CritterEmote.Log(CritterEmote.Debug, "Call to GetTargetPetsOwner()")
	if UnitExists("target") and not UnitIsPlayer("target") then
		local creatureType = UnitCreatureType("target")
		CritterEmote.Log(CritterEmote.Debug, "creatureType: "..creatureType.."==?"..CritterEmote.L["Wild Pet"])
		if creatureType == CritterEmote.L["Wild Pet"] or creatureType == CritterEmote.L["Non-combat Pet"] then
			local tooltipData = C_TooltipInfo.GetUnit("target")
			if tooltipData and tooltipData.lines then
				for _, line in ipairs(tooltipData.lines) do
					if line.leftText then
						-- print(line.leftText, CritterEmote.playerName)
						-- print(string.find(line.leftText, CritterEmote.playerName))
						if string.find(line.leftText, CritterEmote.playerName) then
							-- this keeps it simple as a find, not a match, and keeps the text returned as the playername from GetUnitName
							CritterEmote.Log(CritterEmote.Info, "Pet belongs to player.")
							return CritterEmote.playerName
						end
					end
				end
			end
		end
	else
		CritterEmote.Log(CritterEmote.Info, "Nothing is targeted, or is targeting a player.")
	end
	-- returning nothing is the same as returning nil.
end
function CritterEmote.DoCritterEmote(msg, isEmote)
	-- isEmote is a flag to say that this is an emote.
	-- false means that msg is text to use.
	CritterEmote.Log(CritterEmote.Debug, "Call to DoCritterEmote( "..(msg or "nil")..", "..(isEmote and "True" or "False")..")")
	local petName, customName = CritterEmote.GetActivePet()
	CritterEmote.Log(CritterEmote.Debug, "petName: "..petName..", customName:"..(customName or "nil"))
	if petName then -- a pet is summoned
		if isEmote or msg == nil then
			msg = CritterEmote.GetEmoteMessage(msg, petName, customName)
		end
		if msg and petName then
			CritterEmote.DisplayEmote((customName or petName).." "..msg)
		end
	end
end
function CritterEmote.GetActivePet()
	-- returns pet name and custom name.  Custom Name is nil if not given.
	CritterEmote.Log(CritterEmote.Debug, "Call to GetActivePet()")
	local petid = C_PetJournal.GetSummonedPetGUID()
	if petid then
		local petInfo = {C_PetJournal.GetPetInfoByPetID(petid)} -- {} wraps the multiple return values into a table.
		return petInfo[8], petInfo[2]
	end
end
function CritterEmote.GetPetPersonality(petName)
	-- @TODO: Should this also handle 'customName'?  What if a named pet has a different personality?
	return CritterEmote.Personalities[petName] or "default"
end
function CritterEmote.GetEmoteMessage(emoteIn, petName, customName)
	CritterEmote.Log(CritterEmote.Debug, "Call to GetEmoteMessage("..(emoteIn or "nil")..", "..petName..", "..(customName or "nil")..")")
	CritterEmote.Log(CritterEmote.Debug, " Getting Emote Table for "..(emoteIn or "nil") )

	local petPersonality = CritterEmote.GetPetPersonality(petName)
	emoteIn = CritterEmote.EmoteMap[emoteIn]

	-- get the table
	local emoteList = {}
	local emoteTable = CritterEmote.EmoteResponses[emoteIn]
	if emoteTable then
		emoteList = emoteTable[customName] or
		            emoteTable[petName] or
		            emoteTable[petPersonality] or
		            emoteTable["default"]
		-- for cat, enabled in pairs(CritterEmote_Variables.Categories) do
		-- 	-- this seems the wrong place / time to do this?
		--  -- should this be done if no entries are found?
		-- 	search_name = petPersonality_silly
		-- end
		return CritterEmote.GetRandomTableEntry(emoteList)
	else
		return CritterEmote.GetRandomEmote()
	end
end
function CritterEmote.GetRandomEmote()
	-- not totally random.
	-- random emotes are pulled from the enabled categories
	CritterEmote.Log(CritterEmote.Debug, "Call to GetRandomEmote()")
	CritterEmote.RandomEmoteTable = {}   -- add this to the addon table to keep from making new tables all the time.
	local categoryEmote = ""
	for category, enabled in pairs(CritterEmote_Variables.Categories) do
		CritterEmote.Log(CritterEmote.Debug, "Emote category: "..category.." is "..(enabled and "enabled." or "disabled."))
		if enabled and CritterEmote[category.."_emotes"] then
			CritterEmote.Log(CritterEmote.Debug, "Get a random emote from: "..category.."_emotes ("..#CritterEmote[category.."_emotes"]..")" )
			categoryEmote = CritterEmote.GetRandomTableEntry( CritterEmote[category.."_emotes"] or {})
			CritterEmote.Log(CritterEmote.Debug, "categoryEmote: "..(categoryEmote or "nil"))
			table.insert(CritterEmote.RandomEmoteTable, categoryEmote)
		else
			CritterEmote.Log(CritterEmote.Debug, "No "..category.." emote added to list to choose from.")
		end
	end
	return CritterEmote.GetRandomTableEntry(CritterEmote.RandomEmoteTable)
end
function CritterEmote.GetRandomTableEntry(myTable)
	if myTable and #myTable>0 then
		return(myTable[random(1, #myTable)])
	end
end
function CritterEmote.CreateUpdateInterval()
	return CritterEmote_Variables.baseInterval +
			random(CritterEmote_Variables.minRange, CritterEmote_Variables.maxRange)
end
