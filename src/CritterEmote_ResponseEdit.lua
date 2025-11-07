_, CritterEmote = ...
function CritterEmote.Edit_OnLoad()
	print("OnLoad")
end
function CritterEmote.Edit_OnShow()
	CritterEmote.Log(CritterEmote.Error, "EditOnShow")
	CritterEmote.Edit_UpdatePetIcon()
	-- CritterEmote.Edit_UpdateEmoteDropDown()
end
function CritterEmote.Edit_UpdatePetIcon()
	local petIcon = select(9, C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetSummonedPetGUID()))
	CritterEmoteResponseEditFrame_Icon:SetTexture(petIcon)
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
	UIDropDownMenu_Initialize(self, CritterEmote.Edit_EmoteDropDownPopulate)
	UIDropDownMenu_JustifyText(self, "LEFT")
end
function CritterEmote.Edit_EmoteDropDownPopulate(self, level, menuList)
	-- this gets called MANY times
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
end
function CritterEmote.Edit_SetEmoteForEdit(info)  -- takes the info table
	CritterEmote.editEmote = info.value
	print(CritterEmote.editEmote)
	UIDropDownMenu_SetText(CritterEmoteResponseEditFrame_EmoteDropDown, CritterEmote.editEmote)
	CloseDropDownMenus()
end

CritterEmote.commandList[CritterEmote.L["edit"]] = {
	["help"] = {"", CritterEmote.L["Show the Critter Emote Response Edit frame."]},
	["func"] = function() CritterEmoteResponseEditFrame:Show() end,
}
