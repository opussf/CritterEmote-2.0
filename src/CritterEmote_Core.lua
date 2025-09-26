-- CritterEmote Core Module
CritterEmote_SLUG, CritterEmote = ...
CritterEmote.ADDONNAME = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Title" )
CritterEmote.VERSION   = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Version" )
CritterEmote.AUTHOR    = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Author" )

CritterEmote.Colors = {
	print = "|cff00ff00",
	reset = "|r",
}
CritterEmote.Info  = 1
CritterEmote.Warn  = 2
CritterEmote.Error = 3
CritterEmote.LogNames = { "Info", "Warn", "Error" }

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

CritterEmote_Variables.logLevel = 3 -- ERROR


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
        if (string.sub(UnitName("player"), string.len(UnitName("player"))) == "s") then
                nameAdd = ' ';
        else
                nameAdd = ': ';
        end
        CritterEmote_EmoteToSend = nameAdd  .. message;
end
function CritterEmote.OnLoad()
	hooksecurefunc("DoEmote", CritterEmote.OnEmote)
	CritterEmoteFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	CritterEmoteFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
	CritterEmoteFrame:RegisterEvent("CHAT_MSG_EMOTE")

	SLASH_CRITTEREMOTE1 = "/ce"
	SlashCmdList["CRITTEREMOTE"] = CritterEmote.SlashHandler
	CritterEmote.playerName = UnitName("player", false)
end
function CritterEmote.LOADING_SCREEN_DISABLED()
end
function CritterEmote.CHAT_MSG_TEXT_EMOTE( a, b, c, d )
	print( "Chat_msg_TEXT_EMOTE" )
	print(a)
	print(b)
	print(c)
	print(d)
end
function CritterEmote.CHAT_MSG_EMOTE( a, b, c, d )
	print( "Chat_msg_EMOTE" )
	print(a)
	print(b)
	print(c)
	print(d)
end
function CritterEmote.OnEmote(emote, target)
	CritterEmote.Log(CritterEmote.Info, "OnEmote( "..emote..", "..(target or "nil").." ("..(target and #target or "nil")..")")
	if target and #target < 1 then
		if CritterEmote.GetTargetPetsOwner() then
			-- since this returns truthy on if the pet is the player's, no reason to store a value.
			-- debug, if desired, can use CritterEmote.playerName
			print("Pet belongs to you")
			CritterEmote.DoCritterEmote(emote, true)
		end
	end
end
function CritterEmote.OnUpdate()
end

function CritterEmote.GetTargetPetsOwner()
	-- this is probably misnamed, should probably be IsPetOwnedByPlayer() and return truthy values.  Though, returning the name would be true.
	print("GetTargetPetsOwner()")
	if UnitExists("target") and not UnitIsPlayer("target") then
		local creatureType = UnitCreatureType("target")
		print("creatureType: "..creatureType.."==?"..CritterEmote.L["Wild Pet"])
		print(CritterEmote.L["Wild Pet"], CritterEmote.L["Non-combat Pet"])
		if creatureType == CritterEmote.L["Wild Pet"] or creatureType == CritterEmote.L["Non-combat Pet"] then
			local tooltipData = C_TooltipInfo.GetUnit("target")
			if tooltipData and tooltipData.lines then
				for _, line in ipairs(tooltipData.lines) do
					if line.leftText then
						print(line.leftText, CritterEmote.playerName)
						print(string.find(line.leftText, CritterEmote.playerName))
						if string.find(line.leftText, CritterEmote.playerName) then
							-- this keeps it simple as a find, not a match, and keeps the text returned as the playername from GetUnitName
							print("Return: "..CritterEmote.playerName)
							return CritterEmote.playerName
						end
					end
				end
			end
		end
	end
	-- returning nothing is the same as returning nil.
end
function CritterEmote.DoCritterEmote(msg, isEmote)
	-- isEmote is a flag to say that this is an emote.
	-- false means that msg is text to use.
	CritterEmote.Log(CritterEmote.Info, "Call to DoCritterEmote( "..msg..", "..(doemote and "True" or "False")..")")
	local petName, customName = CritterEmote.GetActivePet()
	print(petName, customName)
	if isEmote then
		msg = CritterEmote.GetEmoteMessage(msg, petName, customName)
	end
	if petName then
		CritterEmote.DisplayEmote((customName or petName).." "..msg)
	end


        -- local emo=nil;
        -- local petName = CritterEmote_GetActivePet(nil);
        -- local customName = CritterEmote_GetActivePet(1);
        -- --local tableRef = CritterEmote.ResponseDb[petName][WOW BattlePet API]
        -- if(petName ~= nil) then
        --         if( doemote ) then
        --                 emo = CritterEmote_GetEmoteMessage(msg,petName,customName);
        --                 if(emo) then
        --                 		if(customName) then
        --                 			CritterEmote_DisplayEmote(customName .. " " .. emo);
        --                 		else
        --                         	CritterEmote_DisplayEmote(petName .. " " .. emo);
        --                         end
        --                 --else
        --                 --      CritterEmote_DisplayEmote(petName .. " responds to your " .. msg .. ".");
        --                 end
        --         else
        --                 if(type(msg) == "string") then
        --                 		if(customName) then
        --                         	CritterEmote_DisplayEmote(customName .. " " .. msg);
        --                         else
        --                             CritterEmote_DisplayEmote(petName .. " " .. msg);
        --                         end
        --                 else
        --                         --Catch all should really never be here.
        --                         CritterEmote_DisplayEmote(petName .. " moons you.");
        --                 end
        --         end
        -- else
        --         CritterEmote_Message("You do not have an active critter out.");
        -- end
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
function CritterEmote.GetEmoteMessage(emoteIn, petName, customName)
	CritterEmote.Log(CritterEmote.Info, "Call to GetEmoteMessage("..emoteIn..", "..petName..", "..(customName or "nil")..")")

	local petPersonality = CritterEmote.Personalities[petName]  -- @TODO: Should this also handle 'customName'?  What if a named pet has a different personality?
	print(petPersonality)
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
	return(myTable[random(1, #myTable)]);
end


--[[
bpid=C_PetJournal.GetSummonedPetGUID();
bpt={C_PetJournal.GetPetInfoByPetID(bpid)};
print(string.format("%s is a %s(%s)", bpt[8],PET_TYPE_SUFFIX[bpt[10] ],C_PetJournal.GetPetInfoBySpeciesID(bpt[1])))

]]


-- --Searches the emote table for an appropriate emote
-- --msg = predefined emote type
-- --petName = the pet you have out
-- function CritterEmote_GetEmoteMessage(msg,petName,customName)
--   emo=nil;
--   emoT=nil;
--   tmp_table=nil;
--   search_name=nil;
--   emoPT = CritterEmote_TableSearch(CritterEmote_Personalities, petName);
--   if(emoPT == nil) then
--     emoPT = " " ; -- HACK to make sure table search is ok.
--   end
--   if(customName == nil ) then
--   	customName = " " ;
--   end
--   --See if pet exists in table
--   CritterEmote_printDebug("Call to GetEmoteMessage");
--   CritterEmote_printDebug(" Getting Emote Table for " .. msg);
--   emoT = CritterEmote_TableSearch(CritterEmote_ResponseDb, msg);
--   --Found emote table
--   if(emoT) then
--     CritterEmote_printDebug("  Found the table" .. msg);
--     emo=CritterEmote_TableSearch(emoT, customName)
--     if( emo ) then
--    		CritterEmote_printDebug("  Found custom name " .. customName);
--     	search_name=customName;
--     else
-- 	emo=CritterEmote_TableSearch(emoT, petName)
-- 	if( emo ) then
-- 		CritterEmote_printDebug("  Found pet name " .. petName);
-- 		search_name=petName;
-- 	else
-- 	emo=CritterEmote_TableSearch(emoT, emoPT)
-- 	if( emo ) then
-- 		CritterEmote_printDebug("  Found pet type " .. emoPT);
-- 		search_name=emoPT;
-- 	else
-- 	emo=CritterEmote_TableSearch(emoT, "default")
-- 	if( emo ) then
-- 		CritterEmote_printDebug("  Found default ");
-- 		search_name="default";
-- 	end
-- 	end
-- 	end
--     end
--     if(emo) then --Found the exact pet
--       --CritterEmote_printDebug("  Found pet: " .. petName);
--       for k, v in pairs(CritterEmote_Cats) do
--         if(v==true) then
--           CritterEmote_printDebug("    Searching for " .. k);
--           tmp_table = CritterEmote_TableSearch(emoT, search_name .. "_" .. k)
--           if(type(tmp_table) == "table" )  then
--             CritterEmote_printDebug("    Found " .. k);
--             emo = CE_array_concat(emo, tmp_table);
--           end
--         end
--       end
--       if( type(emo) == "table" ) then
--         CritterEmote_printDebug("Returning random entry for " .. search_name);
--         return CritterEmote_GetRandomTableEntry(emo);
--       end
--     end
--     CritterEmote_printDebug("Could not find table entry for ".. msg);
-- 	return nil;
--   end --ifemoT
--   CritterEmote_printDebug("Could not find table for ".. msg);
--   return nil;
-- end



----------------------------------------------------------


-- Steps_Frame:RegisterEvent( "" )


--     --Main load
-- function CritterEmote_OnLoad ()

--   --Stop the random number generator from doing the same thing every time
--   local tval = math.random();
--   tval = random();

--   --Secure hook functions
--         hooksecurefunc("DoEmote", CritterEmote_OnEmote);

--         CritterEmoteFrame:RegisterEvent("ADDON_LOADED");
--         CritterEmoteFrame:RegisterEvent("PLAYER_LOGOUT");
--         CritterEmoteFrame:RegisterEvent("CHAT_MSG_EMOTE");
--         CritterEmoteFrame:RegisterEvent("UNIT_PET")
--         CritterEmoteFrame:RegisterEvent("PLAYER_TARGET_CHANGED")



--         --Define Slash Commands
--         SLASH_CRITTEREMOTE1 = "/ce";



--         SlashCmdList["CRITTEREMOTE"] = CritterEmote_SlashHandler;

--         --Update timer
--         CritterEmote_SetUpdateInterval(30, 400);
--         CritterEmote_Welcome();
-- end

-- -- Load Libraries & Modules
-- local Response = CritterEmote_Response_enUS
-- local TargetEmotes = CritterEmote_Target_enUS
-- local PetPersonality = CritterEmote_PetPersonality or {}

-- if not CritterEmote_PetPersonality then
--     print("|cffff0000[CritterEmote]|r ERROR: Pet Personality table is nil!")
-- else
--     print("|cff00ff00[CritterEmote]|r Pet Personality table loaded successfully.")
-- end

-- print("Debug: Response table:", Response)

-- -- Function to Handle Events
-- function CritterEmote_OnEvent(self, event, ...)
--     if event == "ADDON_LOADED" then
--         local addonName = ...
--         if addonName == "CritterEmote" then
--             print("|cff00ff00[CritterEmote]|r Initialized!")
--         end
--     elseif event == "PLAYER_LOGIN" then
--         print("|cff00ff00[CritterEmote]|r Ready!")
--     end
-- end

-- -- Function to Initialize the Main Addon Frame
-- function CritterEmote_OnLoad(self)
--     self:RegisterEvent("ADDON_LOADED")
--     self:RegisterEvent("PLAYER_LOGIN")
--     print("|cff00ff00[CritterEmote]|r Add-on Loaded Successfully!")
-- end

-- -- Function to Handle the Tooltip Frame
-- function CritterEmoteScanTooltip_OnLoad(self)
--     if self and self.SetOwner then
--         self:SetOwner(UIParent, "ANCHOR_NONE")
--     else
--         print("|cffff0000[CritterEmote]|r Warning: Tooltip frame failed to initialize.")
--     end
-- end

-- -- Register Frame for Chat Events
-- local eventFrame = CreateFrame("Frame")
-- eventFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
-- eventFrame:SetScript("OnEvent", function(self, event, msg, sender, ...)
--     CritterEmote_HandleEmote(msg, sender)
-- end)

-- -- Function to Get the Active Pet Name
-- function CritterEmote_GetActivePet()
--     local petGUID = C_PetJournal.GetSummonedPetGUID()
--     if not petGUID then return nil end -- No active pet

--     local _, customName, _, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petGUID)

--     -- Use custom name if available, otherwise default to species name
--     return customName or name
-- end

-- -- Function to Determine Pet Personality
-- local function GetPetPersonality(petName)
--     return PetPersonality[petName] or "default"
-- end

-- local EmoteMap = CritterEmote_EmoteMap or {}

-- function GetEmoteKey(msg)
--     if not msg then return nil end
--     msg = msg:lower()  -- Normalize case

--     -- Directly check if the message contains a valid emote keyword
--     for keyword, token in pairs(CritterEmote_EmoteMap) do
--         if string.find(msg, keyword, 1, true) then
--             return token  -- Return the corresponding Blizzard emote token
--         end
--     end

--     print("|cffff0000[CritterEmote]|r ERROR: No match found for:", msg)
--     return nil
-- end

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
