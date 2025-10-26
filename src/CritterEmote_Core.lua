-- CritterEmote Core Module
CritterEmote_SLUG, CritterEmote = ...
CritterEmote.ADDONNAME = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Title" )
CritterEmote.VERSION   = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Version" )
CritterEmote.AUTHOR    = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Author" )

CritterEmote.Colors = {
	print = "|cff00ff00",
	reset = "|r",
}
CritterEmote.Error = 1  -- Something wrong happened, cannot work around.  -- least verbose
CritterEmote.Warn  = 2  -- Something wrong happened, can work around.
CritterEmote.Info  = 3  -- You might want to know
CritterEmote.Debug = 4  -- Shows most everything  -- most verbose
CritterEmote.LogNames = { "Error", "Warn", "Info", "Debug" }

CritterEmote.Categories = {
	"General", "Silly", "Song", "Location", "Special", "PVP"
}

CritterEmote_Variables = { Categories = {} }
CritterEmote_CharacterVariables = {}
for _,v in pairs(CritterEmote.Categories) do
	CritterEmote_Variables.Categories[v] = true
end

CritterEmote_Variables.enabled = true
CritterEmote_Variables.randomEnabled = true
CritterEmote_Variables.baseInterval = 300
CritterEmote_Variables.minRange = 30
CritterEmote_Variables.maxRange = 400
CritterEmote_Variables.logLevel = CritterEmote.Error -- Set the default logLevel

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
	CritterEmoteFrame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")

	SLASH_CRITTEREMOTE1 = "/ce"
	SlashCmdList["CRITTEREMOTE"] = CritterEmote.SlashHandler
	CritterEmote.playerName = UnitName("player", false)
	CritterEmote.lastUpdate = 0
	CritterEmote.updateInterval = CritterEmote.CreateUpdateInterval()
end
function CritterEmote.LOADING_SCREEN_DISABLED()
	CritterEmote.lastUpdate = time()
	CritterEmote.AddEmoteCategoriesToCommandList()
	if not C_AddOns.IsAddOnLoaded("Blizzard_Calendar") then
		CritterEmote.Log(CritterEmote.Debug, "Blizzard_Calendar was not loaded.")
		UIParentLoadAddOn("Blizzard_Calendar")
	end
	C_Timer.After(2, function()
		CritterEmote.Log(CritterEmote.Debug, "Requesting calendar data...")
		C_Calendar.OpenCalendar()  -- trigger CALENDAR_UPDATE_EVENT_LIST
    end)
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
	CritterEmote.Log(CritterEmote.Debug, "petName: "..(petName or "nil")..", customName:"..(customName or "nil"))
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
-------
function CritterEmote.ParseCmd(msg)
	if msg then
		msg = string.lower(msg)
		local a,b,c = strfind(msg, "(%S+)")  --contiguous string of non-space characters
		if a then
			-- c is the matched string, strsub is everything after that, skipping the space
			return c, strsub(msg, b+2)
		else
			return ""
		end
	end
end
function CritterEmote.spairs( t, f )  -- This is an awesome function I found
	local a = {}
	for n in pairs( t ) do table.insert( a, n ) end
	table.sort( a, f ) -- @TODO: Look into giving a sort function here.
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
function CritterEmote.SlashHandler(msg)
	local cmd, param = CritterEmote.ParseCmd(msg)
	if CritterEmote.commandList[cmd] and CritterEmote.commandList[cmd].alias then
		cmd = CritterEmote.commandList[cmd].alias
	end
	local cmdFunc = CritterEmote.commandList[cmd]
	if cmdFunc and cmdFunc.func then
		cmdFunc.func(param)
	elseif msg=="" then
		CritterEmote.lastUpdate = 0
	else
		CritterEmote.DoCritterEmote(msg)
	end
end
function CritterEmote.PrintHelp()
	CritterEmote.Print(string.format(CritterEmote.L["%s (%s) by %s"], CritterEmote.ADDONNAME, CritterEmote.VERSION, CritterEmote.AUTHOR), false)
	for cmd, info in CritterEmote.spairs(CritterEmote.commandList) do
		if info.help then
			local cmdStr = cmd
			for c2, i2 in pairs(CritterEmote.commandList) do
				if i2.alias and i2.alias == cmd then
					cmdStr = string.format( "%s / %s", cmdStr, c2 )
				end
			end
			CritterEmote.Print(string.format("%s %s %s -> %s",
				SLASH_CRITTEREMOTE1, cmdStr, info.help[1], info.help[2]), false)
		end
	end
end
function CritterEmote.ShowInfo()
	CritterEmote.Print(string.format(CritterEmote.L["%s (%s) by %s"], CritterEmote.ADDONNAME, CritterEmote.VERSION, CritterEmote.AUTHOR), false)
	if CritterEmote_Variables.enabled then
		CritterEmote.Print(CritterEmote.L["Critter Emote is now enabled. Party Time, critters!"])
	else
		CritterEmote.Print(CritterEmote.L["Critter Emote is now disabled. The critters are sad."])
	end
	for _, category in pairs(CritterEmote.Categories) do
		CritterEmote.Print(CritterEmote.L["%s is %s with %i emotes."],
				category,
				(CritterEmote_Variables.Categories[category] and CritterEmote.L["ENABLED"] or CritterEmote.L["DISABLED"]),
				(CritterEmote[category.."_emotes"] and #CritterEmote[category.."_emotes"] or "no")
		)
	end
end
CritterEmote.commandList = {
	["debug"] = {  -- keep this as debug, no help will keep it from showing in help.  This keeps it 'hidden'
		["func"] = function()
			CritterEmote_Variables.logLevel = CritterEmote.Debug
			CritterEmote.Print("Log level is now set to "..CritterEmote.LogNames[CritterEmote_Variables.logLevel])
		end,
	},
	["test"] = {  -- no help will keep it hidden.  Shows some test data.
		["func"] = function()
			local guid = C_PetJournal.GetSummonedPetGUID()
			print("Summoned pet GUID: "..(guid or "none"))
			local owner = CritterEmote.GetTargetPetsOwner()
			if owner then
				print("Target pet belongs to: " .. owner)
			else
				print("No valid pet target or companion owner text found.")
			end
			local petName, customName = CritterEmote.GetActivePet()
			print(petName..(customName and " ("..customName..") " or "").." is a "..CritterEmote.GetPetPersonality(petName))
			if CritterEmote.activeHolidays then
				print("Active holidays:")
				for k,_ in pairs( CritterEmote.activeHolidays ) do
					print("> "..k)
				end
			end
		end,
	},
	[CritterEmote.L["verbose"]] = {
		["help"] = {"", CritterEmote.L["change the verbosity level"]},
		["func"] = function()
			CritterEmote_Variables.logLevel = CritterEmote_Variables.logLevel + 1
			if CritterEmote_Variables.logLevel >= CritterEmote.Debug then
				CritterEmote_Variables.logLevel = 1
			end
			CritterEmote.Print("Log level is now set to "..CritterEmote.LogNames[CritterEmote_Variables.logLevel])
		end,
	},
	[CritterEmote.L["help"]] = {
		["help"] = {"", CritterEmote.L["show the command help"]},
		["func"] = CritterEmote.PrintHelp,
	},
	[CritterEmote.L["off"]] = {
		["help"] = {"", CritterEmote.L["turns the emotes off"]},
		["func"] = function()
			CritterEmote_Variables.enabled = false
			CritterEmote.Print(CritterEmote.L["Critter Emote is now disabled. The critters are sad."])
		end,
	},
	[CritterEmote.L["on"]] = {
		["help"] = {"", CritterEmote.L["turns the emotes on"]},
		["func"] = function()
			CritterEmote_Variables.enabled = true
			CritterEmote.Print(CritterEmote.L["Critter Emote is now enabled. Party Time, critters!"])
		end,
	},
	[CritterEmote.L["info"]] = {
		["help"] = {"", CritterEmote.L["displays Critter Emote information"]},
		["func"] = CritterEmote.ShowInfo,
	},

	[CritterEmote.L["random"]] = {
		["help"] = {CritterEmote.L["on"].."|"..CritterEmote.L["off"],
				CritterEmote.L["turns the periodic emotes on or off"]},
		["func"] = function(flag)
			-- flag will be "" if it is not given.
			if flag==CritterEmote.L["on"] then
				CritterEmote_Variables.randomEnabled = true
			elseif flag==CritterEmote.L["off"] then
				CritterEmote_Variables.randomEnabled = false
			end
			if CritterEmote_Variables.randomEnabled then
				CritterEmote.Print(CritterEmote.L["Random Emotes are enabled! Time for nom."])
			else
				CritterEmote.Print(CritterEmote.L["Random Emotes are disabled! The little dudes are sad."])
			end
		end,
	},
}
function CritterEmote.AddEmoteCategoriesToCommandList()
	for _, category in pairs(CritterEmote.Categories) do
		local c = CritterEmote.L[string.lower(category)]
		CritterEmote.commandList[c] = {
			["help"] = {"", CritterEmote.L["toggle inclusion of "..CritterEmote.L[category].." emotes"]},
			["func"] = function()
				CritterEmote.ToggleCategory(category)
				CritterEmote.Print(CritterEmote.L["%s is %s with %i emotes."],
						category,
						(CritterEmote_Variables.Categories[category] and CritterEmote.L["ENABLED"] or CritterEmote.L["DISABLED"]),
						(CritterEmote[category.."_emotes"] and #CritterEmote[category.."_emotes"] or "no")
				)
			end,
		}
	end
end
function CritterEmote.ToggleCategory(cat)
	CritterEmote_Variables.Categories[cat] = not CritterEmote_Variables.Categories[cat]
end
function CritterEmote.CALENDAR_UPDATE_EVENT_LIST()
	CritterEmote.Log(CritterEmote.Debug, "Call to CALENDAR_UPDATE_EVENT_LIST()")
	CritterEmote.activeHolidays = CritterEmote.GetCurrentActiveHolidays()
	CritterEmote.Special_emotes = {}
	for holiday, _ in pairs(CritterEmote.activeHolidays) do
		if CritterEmote.Holiday_emotes[holiday] then
			for _, emote in pairs( CritterEmote.Holiday_emotes[holiday] ) do
				CritterEmote.Log(CritterEmote.Debug, "Adding to Special_emotes: "..emote)
				table.insert(CritterEmote.Special_emotes, emote)
			end
		end
	end
end
--[[

local function CritterEmote_SlashHandler(msg, editbox)
        if (msg == 'critter' or msg == "battle pet") then
                print('I love to talk!');


  elseif(msg == "options" ) then
          CritterEmote_DisplayOptions();

end]]
