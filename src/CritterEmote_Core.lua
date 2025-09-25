-- CritterEmote Core Module
CritterEmote_SLUG, CritterEmote = ...
CritterEmote.ADDONNAME = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Title" )
CritterEmote.VERSION   = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Version" )
CritterEmote.AUTHOR    = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Author" )

CritterEmote.Colors = {
	print = "|cff00ff00",
	reset = "|r",
}

function CritterEmote.Print(msg, showName)
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = CritterEmote.Colors.print..CritterEmote.ADDONNAME.."> "..CritterEmote.Colors.reset..msg
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end
function CritterEmote.OnLoad()
	hooksecurefunc("DoEmote", CritterEmote.OnEmote)
	CritterEmoteFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	CritterEmoteFrame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
	CritterEmoteFrame:RegisterEvent("CHAT_MSG_EMOTE")

	SLASH_CRITTEREMOTE1 = "/ce"
	SlashCmdList["CRITTEREMOTE"] = CritterEmote.SlashHandler
	CritterEmote.playerName = GetUnitName("player", false)
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
	print("OnEmote")
	print(emote)
	if target and #target < 1 then
		print("TARGET and #TARGET < 1")
		print(type(target))
		print(string.format(">%s<", target))
		local petowner = CritterEmote.GetTargetPetsOwner()
		print("Returned petowner: >"..petowner.."<")
	end
end
function CritterEmote.OnUpdate()
end


-- --      For secure func hook on DoEmote()
-- local function CritterEmote.OnEmote(emote, target)
--   CritterEmote_printDebug("Emote detected: ".. emote)
--   if target and #target < 1 then
--     local petowner = CritterEmote_GetTargetPetsOwner()
--     if petowner then
--       CritterEmote_printDebug("\tFound petowner : " .. petowner);
--       if(petowner == UnitName("player") ) then
--         CritterEmote_doEmote(emote,true);
--       end
--     end
--   end
-- end

function CritterEmote.GetTargetPetsOwner()
	-- this is probably misnamed, should probably be IsPetOwnedByPlayer() and return truthy values.  Though, returning the name would be true.
	print("GetTargetPetsOwner()")
	if UnitExists("target") and not UnitIsPlayer("target") then
		local creatureType = UnitCreatureType("target")
		print("creatureType: "..creatureType.."==?"..CritterEmote.L["Wild Pet"])
		if creatureType == CritterEmote.L["Wild Pet"] or creatureType == CritterEmote.L["Non-combat Pet"] then
			local tooltipData = C_TooltipInfo.GetUnit("target")
			if tooltipData and tooltipData.lines then
				for _, line in ipairs(tooltipData.lines) do
					if line.leftText then
						-- print(line.leftText)
						if string.find(line.leftText, CritterEmote.playerName) then
							return CritterEmote.playerName
						end

						-- local owner = string.match(line.leftText, CritterEmote.L["^(.+)'s Companion"])  -- this allows better
						-- print("Owner: >"..(owner or "nil").."<")
						-- print((owner or "nil").."==?"..CritterEmote.playerName)
						-- if owner == CritterEmote.playerName then
						-- 	return owner
						-- end
					-- if line.leftText and line.leftText:find("Companion", -9, true) then
					-- 	local owner = string.match(line.leftText, "[^']+")
					-- 	if owner == CritterEmote.playerName then
					-- 		return owner
					-- 	end
					end
				end
			end
		end
	end
	-- returning nothing is the same as returning nil.
end


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
