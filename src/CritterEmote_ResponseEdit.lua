CritterEmote.commandList[CritterEmote.L["edit"]] = {
	["help"] = {"", CritterEmote.L["Show the Critter Emote Response Edit frame."]},
	["func"] = function() CritterEmoteResponseEditFrame:Show() end,
}

--[[
	--print(MAXEMOTEINDEX)
	for i = 1,1000 do
		cron_knownEmotes[i] = _G["EMOTE"..i.."_TOKEN"]
	end
]]