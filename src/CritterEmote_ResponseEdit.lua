_, CritterEmote = ...
CritterEmote_ResponseEmotesPatches = {}  -- save variable
---------------------
function CritterEmote.Edit_OnLoad()
	CritterEmoteResponseEditFrame_Title:SetText(CritterEmote.ADDONNAME)
end
function CritterEmote.Edit_OnShow()
	CritterEmote.Log(CritterEmote.Debug, "Edit_OnShow")
	CritterEmote.Edit_UpdatePetInfo()
	-- if drop down has emote - populate editbox
	CritterEmote.Edit_PopulateEditBox()
	-- CritterEmoteResponseEditFrame:RegisterEvent("COMPANION_UPDATE")
end
function CritterEmote.Edit_OnHide()
	-- save editbox
	CritterEmote.Edit_SaveEmotes()
	-- CritterEmoteResponseEditFrame:UnregisterEvent("COMPANION_UPDATE")
end
-- function CritterEmote.Edit_COMPANION_UPDATE()
	-- this seems to fire a lot....
	-- print("COMPANION_UPDATE")
	-- CritterEmote.Edit_UpdatePetInfo()
-- end
function CritterEmote.Edit_UpdatePetInfo()
	local petGUID = C_PetJournal.GetSummonedPetGUID()
	if petGUID then  -- @TODO: What to do about no pet?
		CritterEmoteResponseEditFrame.petInfo = {C_PetJournal.GetPetInfoByPetID(petGUID)}
		-- 1=id, 2=custom, 8=name
		CritterEmoteResponseEditFrame_Icon:SetTexture(CritterEmoteResponseEditFrame.petInfo[9])
		CritterEmote.editGroup = CritterEmoteResponseEditFrame.petInfo[2] or CritterEmoteResponseEditFrame.petInfo[8]
		CritterEmote.Edit_InitGroupDropDown(CritterEmoteResponseEditFrame_GroupDropDown)
	end
end
function CritterEmote.Edit_InitGroupDropDown(self)
	UIDropDownMenu_Initialize(self, function(self, level)
			local info = UIDropDownMenu_CreateInfo()
			info.func = CritterEmote.Edit_SetGroupForEdit
			info.notCheckable = true
			if CritterEmoteResponseEditFrame.petInfo[2] then
				info.text = CritterEmoteResponseEditFrame.petInfo[2]
				UIDropDownMenu_AddButton(info)
			end
			info.text = CritterEmoteResponseEditFrame.petInfo[8]
			UIDropDownMenu_AddButton(info)
			info.text = CritterEmote.GetPetPersonality(CritterEmoteResponseEditFrame.petInfo[1])
			UIDropDownMenu_AddButton(info)
			info.text = "default"
			UIDropDownMenu_AddButton(info)

			UIDropDownMenu_SetSelectedName(self, CritterEmote.editGroup)
			UIDropDownMenu_SetText(self, CritterEmote.editGroup)

		end)
	UIDropDownMenu_JustifyText(self, "LEFT")
end
function CritterEmote.Edit_SetGroupForEdit(info)
	-- save editbox
	CritterEmote.Edit_SaveEmotes()

	-- update editGroup
	CritterEmote.editGroup = info.value
	-- populate Editbox
	CritterEmote.Edit_PopulateEditBox()
	UIDropDownMenu_SetText(CritterEmoteResponseEditFrame_GroupDropDown, CritterEmote.editGroup)
	CloseDropDownMenus()
end
function CritterEmote.Edit_InitEmoteDropDown(self)
	if not CritterEmote.knownEmotes then
		CritterEmote.knownEmotes = { keys = {} }
		for i = 1,MAXEMOTEINDEX do
			local emote = _G["EMOTE"..i.."_TOKEN"]
			if emote then
				local header = string.sub(emote,1,1)
				CritterEmote.knownEmotes[header] = CritterEmote.knownEmotes[header] or {}
				table.insert(CritterEmote.knownEmotes[header], emote)
			end
		end
		for header, _ in pairs(CritterEmote.knownEmotes) do
			table.sort(CritterEmote.knownEmotes[header])
			if header ~= "keys" then
				table.insert(CritterEmote.knownEmotes.keys, header)
			end
		end
		table.sort(CritterEmote.knownEmotes.keys)
	end
	UIDropDownMenu_Initialize(self, function(self, level, menuList) -- keep this an an anonymous function
			-- this gets called MANY times, this is the ONLY place that this is called.
			local info = UIDropDownMenu_CreateInfo()

			if (level or 1) == 1 then
				for _, header in ipairs(CritterEmote.knownEmotes.keys) do
					info.text = header
					info.hasArrow, info.notCheckable = true, true
					info.menuList = header
					UIDropDownMenu_AddButton(info)
				end
			else
				info.func = CritterEmote.Edit_SetEmoteForEdit
				for _, emote in pairs(CritterEmote.knownEmotes[menuList]) do
					info.text = emote
					info.hasArrow, info.notCheckable = false, true
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end)
	UIDropDownMenu_JustifyText(self, "LEFT")
end
function CritterEmote.Edit_SetEmoteForEdit(info)  -- takes the info table, called when an emote is chosen
	-- save editbox
	CritterEmote.Edit_SaveEmotes()

	-- update editEmote
	CritterEmote.editEmote = info.value
	-- populate Editbox
	CritterEmote.Edit_PopulateEditBox()
	UIDropDownMenu_SetText(CritterEmoteResponseEditFrame_EmoteDropDown, CritterEmote.editEmote)
	CloseDropDownMenus()
	CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:SetFocus()
end
function CritterEmote.Edit_PopulateEditBox()
	CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:SetText(
			table.concat(CritterEmote.Edit_GetResponses(CritterEmote.editEmote, CritterEmote.editGroup) or {})
	)
end
--------------------------
-- Support functions
--------------------------
function CritterEmote.Edit_SaveEmotes()
	-- make and save a patch structure
	local editEmote = CritterEmote.editEmote
	local editGroup = CritterEmote.editGroup
	if editEmote and editGroup then
		local patch = {}
		local baseList = CritterEmote.EmoteResponses[editEmote] and CritterEmote.EmoteResponses[editEmote][editGroup] or {}
		local newList = {}

		-- convert text block to newList
		local text = CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:GetText().."\n"  -- append a new line
		for emote in text:gmatch("(.-)\n") do
			if emote ~= "" then
				table.insert(newList, emote)
			end
		end

		-- make baseSet and newSet
		local baseSet, newSet = {}, {}
		for _, e in ipairs(baseList or {}) do baseSet[e] = true end
		for _, e in ipairs(newList) do newSet[e] = true end

		-- create .add
		for newEmote in pairs(newSet) do
			if not baseSet[newEmote] then -- this line is not in the baseList
				patch.add = patch.add or {}
				table.insert(patch.add, newEmote)
			end
		end

		-- create .remove
		for baseEmote in pairs(baseSet) do
			if not newSet[baseEmote] then
				patch.remove = patch.remove or {}
				table.insert(patch.remove, baseEmote)
			end
		end
		CritterEmote_ResponseEmotesPatches[editEmote] = CritterEmote_ResponseEmotesPatches[editEmote] or {}
		if patch.add or patch.remove then
			CritterEmote_ResponseEmotesPatches[editEmote][editGroup] = patch
		else
			CritterEmote_ResponseEmotesPatches[editEmote][editGroup] = nil
		end
		if not next(CritterEmote_ResponseEmotesPatches[editEmote]) then
			CritterEmote_ResponseEmotesPatches[editEmote] = nil
		end
	end
end
function CritterEmote.Edit_GetResponses(emote, groupName)
	-- still not sure how to do this exactly
	CritterEmote.Log(CritterEmote.Debug, "Edit_GetResponses( "..(emote or "nil")..", "..(groupName or "nil").." )")
	if emote == nil or groupName == nil then return end
	local base = CritterEmote.EmoteResponses and CritterEmote.EmoteResponses[emote] and CritterEmote.EmoteResponses[emote][groupName] or {}
	local patch = CritterEmote_ResponseEmotesPatches[emote] and CritterEmote_ResponseEmotesPatches[emote][groupName] or {}
	local listOut = {}
	for _, v in ipairs(base) do  -- copy from base list
		table.insert(listOut, v)
	end
	if patch then
		-- Remove
		local removeSet = {}
		if patch.remove then
			for _, v in ipairs(patch.remove) do removeSet[v] = true end
			listOut = {}  -- reset the process
			for _, v in ipairs(base) do
				if not removeSet[v] then
					table.insert(listOut, v)
				end
			end
		end
		-- Add
		if patch.add then
			for _, v in ipairs(patch.add) do
				table.insert(listOut, v)
			end
		end
	end
	return (#listOut > 0) and listOut or nil
end

CritterEmote.commandList[CritterEmote.L["edit"]] = {
	["help"] = {"", CritterEmote.L["Show the Critter Emote Response Edit frame."]},
	["func"] = function() CritterEmoteResponseEditFrame:Show() end,
}
