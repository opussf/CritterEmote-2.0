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
CritterEmote.LogNames = { "Error", "Warn", "Info" }

CritterEmote_Variables = {}
CritterEmote_CharacterVariables = {}

CritterEmote_Variables.Categories = {
  Normal = true,
  Silly = true,
  Song = true,
  Locations = true,
  Special = true,
  PVP = true,
}
CritterEmote_Variables.enabled = true
CritterEmote_Variables.randomEnabled = true
CritterEmote_Variables.baseInterval = 300
CritterEmote_Variables.minRange = 30
CritterEmote_Variables.maxRange = 400
CritterEmote_Variables.logLevel = 3 -- Info

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
	CritterEmote.Log(CritterEmote.Info, "DisplayEmote("..message..")")
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
end
function CritterEmote.OnEmote(emote, target)
	CritterEmote.Log(CritterEmote.Info, "OnEmote( "..emote..", "..(target or "nil").." - "..(target and #target or "nil")..")")
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
				local petName = CritterEmote.GetActivePet()

				CritterEmote.DoCritterEmote()
			end
		end
	end
end
function CritterEmote.GetTargetPetsOwner()
	-- this is probably misnamed, should probably be IsPetOwnedByPlayer() and return truthy values.  Though, returning the name would be true.
	CritterEmote.Log(CritterEmote.Info, "Call to GetTargetPetsOwner()")
	if UnitExists("target") and not UnitIsPlayer("target") then
		local creatureType = UnitCreatureType("target")
		-- print("creatureType: "..creatureType.."==?"..CritterEmote.L["Wild Pet"])
		-- print(CritterEmote.L["Wild Pet"], CritterEmote.L["Non-combat Pet"])
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
	CritterEmote.Log(CritterEmote.Info, "Call to DoCritterEmote( "..(msg or "nil")..", "..(doemote and "True" or "False")..")")
	local petName, customName = CritterEmote.GetActivePet()
	-- print(petName, customName)
	if isEmote then
		msg = CritterEmote.GetEmoteMessage(msg, petName, customName)
	end
	if msg and petName then
		CritterEmote.DisplayEmote((customName or petName).." "..msg)
	end
end
function CritterEmote.GetActivePet()
	-- returns pet name and custom name.  Custom Name is nil if not given.
	CritterEmote.Log(CritterEmote.Info, "Call to GetActivePet()")
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
	CritterEmote.Log(CritterEmote.Info, "Call to GetEmoteMessage("..emoteIn..", "..petName..", "..(customName or "nil")..")")

	local petPersonality = CritterEmote.GetPetPersonality(petName)
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
	end
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

function CritterEmote_GetEmoteMessage1(msg,petName,customName)
	emo=nil;
	emoT=nil;
  tmp_table=nil;
  search_name=nil;
  emoPT = CritterEmote_TableSearch(CritterEmote_Personalities, petName);
  if(emoPT == nil) then
    emoPT = " " ; -- HACK to make sure table search is ok.
  end
  if(customName == nil ) then
    customName = " " ;
  end
  --See if pet exists in table
  CritterEmote_printDebug("Call to GetEmoteMessage");
  CritterEmote_printDebug(" Getting Emote Table for " .. msg);
  emoT = CritterEmote_TableSearch(CritterEmote_ResponseDb, msg);
  CritterEmote_printDebug("  emoT: " )
  test.dump(emoT)
  --Found emote table
  if(emoT) then
    CritterEmote_printDebug("  Found the table" .. msg);
    emo=CritterEmote_TableSearch(emoT, customName)
    if( emo ) then
      CritterEmote_printDebug("  Found custom name " .. customName);
      search_name=customName;
    else
      emo=CritterEmote_TableSearch(emoT, petName)
      if( emo ) then
        CritterEmote_printDebug("  Found pet name " .. petName);
        search_name=petName;
      else
        emo=CritterEmote_TableSearch(emoT, emoPT)
        if( emo ) then
          CritterEmote_printDebug("  Found pet type " .. emoPT);
          search_name=emoPT;
        else
          emo=CritterEmote_TableSearch(emoT, "default")
          if( emo ) then
            CritterEmote_printDebug("  Found default ");
            search_name="default";
          end
        end
      end
    end
    if(emo) then --Found the exact pet
      CritterEmote_printDebug("  Found pet: " .. petName);
      for k, v in pairs(CritterEmote_Cats) do
        if(v==true) then
          CritterEmote_printDebug("    Searching for " .. k);
          tmp_table = CritterEmote_TableSearch(emoT, search_name .. "_" .. k)
          if(type(tmp_table) == "table" )  then
            CritterEmote_printDebug("    Found " .. k);
            emo = CE_array_concat(emo, tmp_table);
          end
        end
      end
      if( type(emo) == "table" ) then
        CritterEmote_printDebug("Returning random entry for " .. search_name);
        return CritterEmote_GetRandomTableEntry(emo);
      end
    end
    CritterEmote_printDebug("Could not find table entry for ".. msg);
    return nil;
  end --ifemoT
  CritterEmote_printDebug("Could not find table for ".. msg);
  return nil;
end
function CritterEmote_testThingy()
	z = 5
	a,b = table.unpack(z==6 and {1,2} or {3})
	print(a, b)
end
--Search an incomplete lua table and return found node
function CritterEmote_TableSearch(mytable, search)
        CritterEmote_printDebug("TableSearch=> Call to Table Search with " .. search);
        for k,v in pairs(mytable) do
                if(k == search) then
                        CritterEmote_printDebug("TableSearch=> Found " .. k);
                        return v;
                end
        end
        return nil;
end
function CritterEmote_printDebug(txt)
	print(txt)
end
function CritterEmote_GetRandomTableEntry(myTable)
	--print("Call to Random Table");
	test.dump(myTable)
	return(myTable[random(1, #myTable)]);
end

-- function GetEmoteResponse(msg, petName)
--     local emoteToken = GetEmoteKey(msg)
--     if not emoteToken then
--         print("|cffff0000[CritterEmote]|r ERROR: Could not identify emote from message:", msg)
--         return nil
--     end

--     -- Check if response exists in CritterEmote_Response_enUS.lua
--     local possibleResponses =
--         (CritterEmote_Response_enUS[emoteToken] and CritterEmote_Response_enUS[emoteToken][petName]) or
--         (CritterEmote_Response_enUS[emoteToken] and CritterEmote_Response_enUS[emoteToken]["default"])

--     if possibleResponses then
--         return possibleResponses[math.random(#possibleResponses)]
--     else
--         print("|cffff0000[CritterEmote]|r ERROR: No response found for emote:", emoteToken)
--         return nil
--     end
-- end

-- local function GetTargetEmote()
--     if not UnitExists("target") then return nil end  -- No target, no emote.

--     local targetName = UnitName("target") or "someone"
--     local petType = GetPetPersonality(CritterEmote_GetActivePet() or "default")

--     -- Pick from the appropriate category (or default if none exists)
--     local emoteList = TargetEmotes[petType] or TargetEmotes["default"]
--     if not emoteList then return nil end  -- No valid emote list found.

--     -- Pick a random emote and replace %t with the target's name
--     local emote = emoteList[math.random(#emoteList)]
--     return string.gsub(emote, "%%t", targetName)
-- end

-- -- Function to Process Emotes
-- function CritterEmote_HandleEmote(msg, sender)
--     if not UnitExists("target") then return end -- Ensure a valid target exists

--     local petName = UnitName("target") -- Get the pet's name
--     local activePet = CritterEmote_GetActivePet() -- Get player's active pet

--     if petName ~= activePet then return end -- Ignore if target is not player's summoned pet

--     -- Get the correct emote name
--     local emote = GetEmoteKey(msg)
--     if not emote then
--         print("|cffff0000[CritterEmote]|r ERROR: Could not identify emote from message:", msg)
--         return
--     end

--     -- Get the pet's personality
--     local petType = GetPetPersonality(petName)
--     local response = GetEmoteResponse(emote, petName)
--     or GetEmoteResponse(emote, CritterEmote_GetActivePet(1))
--     or GetTargetEmote()

--     if response then
--         local formattedResponse = string.format("%s %s", petName, response)
--         SendChatMessage(formattedResponse, "EMOTE")
--     else
--         print("|cffff0000[CritterEmote]|r ERROR: No response found for emote:", emote)
--     end
-- end
