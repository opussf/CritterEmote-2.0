-- CritterEmote_Options @VERSION@
function CritterEmote.OptionsPanel_OnLoad(panel)
	panel.name = CritterEmote.ADDONNAME
	CritterEmoteOptionsFrame_Title:SetText(CritterEmote.ADDONNAME.." v"..CritterEmote.VERSION)
	CritterEmoteOptionsFrame_EnableHeader:SetText(CritterEmote.L["Enable options"])
	CritterEmoteOptionsFrame_EmoteCategoriesHeader:SetText(CritterEmote.L["Emote Categories"])
	CritterEmote.AddCategoryOptions()

	-- These NEED to be set
	panel.OnDefault = function() end
	panel.OnRefresh = function() end
	panel.OnCommit = CritterEmote.OptionsPanel_OKAY
	panel.cancel = CritterEmote.OptionsPanel_Cancel

	local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
	panel.category = category
	Settings.RegisterAddOnCategory(category)
end
function CritterEmote.OptionsPanel_OKAY()
end
function CritterEmote.OptionsPanel_Cancel()
end
function CritterEmote.OptionsPanel_CheckButton_OnLoad(self, tbl, option, text)
	getglobal(self:GetName().."Text"):SetText(text)
	self:SetChecked(tbl[option])
end
-- OnClick for checkbuttons
function CritterEmote.OptionsPanel_CheckButton_OnClick(self, tbl, option)
	tbl[option] = self:GetChecked()
end
function CritterEmote.AddCategoryOptions()
	local lastName = nil
	for _, category in CritterEmote.Spairs(CritterEmote.Categories) do
		local name = "$parent_Enable"..category
		local checkButton = CreateFrame("CheckButton", name, CritterEmoteOptionsFrame, "CritterEmoteOptionsCheckButtonTemplate")
		checkButton:SetPoint("TOPLEFT", (lastName and lastName or "$parent_EmoteCategoriesHeader"), "BOTTOMLEFT")
		checkButton.tooltip = string.format(CritterEmote.L["toggle inclusion of %s emotes."], CritterEmote.L[category])
		checkButton:SetScript("OnShow", function(self)
			CritterEmote.OptionsPanel_CheckButton_OnLoad(
				self,
				CritterEmote_Variables.Categories,
				category,
				string.format(CritterEmote.L["%s %i emotes"], category, (CritterEmote[category.."_emotes"] and #CritterEmote[category.."_emotes"] or 0))
			)
		end)
		checkButton:SetScript("OnClick", function(self)
			CritterEmote.OptionsPanel_CheckButton_OnClick(
				self,
				CritterEmote_Variables.Categories,
				category
			)
		end)
		lastName = name
	end
end

CritterEmote.commandList[CritterEmote.L["options"]] = {
	["func"] = function() Settings.OpenToCategory( CritterEmoteOptionsFrame.category:GetID() ) end,
	["help"] = {"", CritterEmote.L["Open the options panel"]},
}



--[[
-- Assuming 'parent' is your options panel frame
local checkButton = CreateFrame("CheckButton", "$parent_Enabled", parent, "CritterEmoteOptionsCheckButtonTemplate")

-- Anchor: same as the XML
checkButton:SetPoint("TOPLEFT", parent.EnableHeader, "BOTTOMLEFT")

-- Tooltip: same as <OnLoad>
checkButton.tooltip = CritterEmote.L["Enable emotes."]

-- OnShow script
checkButton:SetScript("OnShow", function(self)
    CritterEmote.OptionsPanel_CheckButton_OnLoad(
        self,
        CritterEmote_Variables,
        "enabled",
        CritterEmote.L["Enable"]
    )
end)

-- OnClick script
checkButton:SetScript("OnClick", function(self)
    CritterEmote.OptionsPanel_CheckButton_OnClick(
        self,
        CritterEmote_Variables,
        "enabled"
    )
end)

]]