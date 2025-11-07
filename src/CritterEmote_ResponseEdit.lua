_, CritterEmote = ...
function CritterEmote.Edit_OnLoad()
	CritterEmoteResponseEditFrame_Title:SetText(CritterEmote.ADDONNAME)
end
function CritterEmote.Edit_OnShow()
	CritterEmote.Log(CritterEmote.Debug, "Edit_OnShow")
	CritterEmote.Edit_UpdatePetInfo()
	-- if drop down has emote - populate editbox
	CritterEmote.Edit_PopulateEditBox()
	CritterEmoteResponseEditFrame:RegisterEvent("COMPANION_UPDATE")
end
function CritterEmote.Edit_OnHide()
	-- save editbox
	CritterEmote.Edit_SaveEmotes()
	CritterEmoteResponseEditFrame:UnregisterEvent("COMPANION_UPDATE")
end
function CritterEmote.Edit_COMPANION_UPDATE()
	-- this seems to fire a lot....
	-- print("COMPANION_UPDATE")
	-- CritterEmote.Edit_UpdatePetInfo()
end
function CritterEmote.Edit_UpdatePetInfo()
	local petGUID = C_PetJournal.GetSummonedPetGUID()
	if petGUID then  -- @TODO: What to do about no pet?
		local petInfo = {C_PetJournal.GetPetInfoByPetID(petGUID)}
		CritterEmoteResponseEditFrame_Icon:SetTexture(petInfo[9])
		CritterEmoteResponseEditFrame_Name:SetText((petInfo[2] or petInfo[8]))
	end
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
function CritterEmote.Edit_SaveEmotes()
	local numLines = CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:GetNumLines()
	if numLines > 0 then
		local petName = CritterEmoteResponseEditFrame_Name:GetText()
		local editEmote = CritterEmote.editEmote

		if petName then
			-- clear old data, or make new
			CritterEmote_CustomResponseEmotes[petName] = CritterEmote_CustomResponseEmotes[petName] or {}
			CritterEmote_CustomResponseEmotes[petName][editEmote] = {} -- this is being replaced

			-- populate data from editbox
			local text = CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:GetText().."\n"  -- append a newline
			for emote in text:gmatch("(.-)\n") do
				if emote ~= "" then
					table.insert(CritterEmote_CustomResponseEmotes[petName][editEmote], emote)
				end
			end
		end
	end
end
function CritterEmote.Edit_PopulateEditBox()
	local petName = CritterEmoteResponseEditFrame_Name:GetText()
	local editEmote = CritterEmote.editEmote
	CritterEmoteResponseEditFrame_EditScrollFrame_EditBox:SetText(
			table.concat((CritterEmote_CustomResponseEmotes[petName] and CritterEmote_CustomResponseEmotes[petName][editEmote] or {}), "\n")
		)
end

CritterEmote.commandList[CritterEmote.L["edit"]] = {
	["help"] = {"", CritterEmote.L["Show the Critter Emote Response Edit frame."]},
	["func"] = function() CritterEmoteResponseEditFrame:Show() end,
}


-- eyes you like you have lost your head.   Midnight Blue - Dance

