-- CritterEmote_Options @VERSION@
function CritterEmote.OptionsPanel_OnLoad(panel)
	panel.name = CritterEmote.ADDONNAME
	CritterEmoteOptionsFrame_Title:SetText(CritterEmote.ADDONNAME.." v"..CritterEmote.VERSION)
	CritterEmoteOptionsFrame_EnableHeader:SetText(CritterEmote.L["Enable options"])

	-- These NEED to be set
	panel.OnDefault = function() end
	panel.OnRefresh = function() end
	panel.OnCommit = CritterEmote.OptionsPanel_OKAY
	panel.cancel = CritterEmote.OptionsPanel_Cancel

	local category, layout = Settings.RegisterCanvasLayoutCategory( panel, panel.name )
	panel.category = category
	Settings.RegisterAddOnCategory(category)
end
function CritterEmote.OptionsPanel_OKAY()
end
function CritterEmote.OptionsPanel_Cancel()
end
function CritterEmote.OptionsPanel_CheckButton_OnLoad( self, tbl, option, text )
	getglobal(self:GetName().."Text"):SetText(text)
	self:SetChecked(tbl[option])
end
-- OnClick for checkbuttons
function CritterEmote.OptionsPanel_CheckButton_OnClick( self, tbl, option )
	tbl[option] = self:GetChecked()
end

CritterEmote.commandList[CritterEmote.L["options"]] = {
	["func"] = function() Settings.OpenToCategory( CritterEmoteOptionsFrame.category:GetID() ) end,
	["help"] = {"", CritterEmote.L["Open the options panel"]},
}
