-- CritterEmote Core Module
CritterEmote_SLUG, CritterEmote = ...
CritterEmote.ADDONNAME = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Title" )
CritterEmote.VERSION   = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Version" )
CritterEmote.AUTHOR    = C_AddOns.GetAddOnMetadata( CritterEmote_SLUG, "Author" )



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
