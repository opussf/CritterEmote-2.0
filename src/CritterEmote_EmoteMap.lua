local _, CritterEmote = ...

CritterEmote.EmoteMap = {
    ["wave"] = "WAVE",
    ["cheer"] = "CHEER",
    ["raise"] = "ANGRY",
    ["kiss"] = "KISS",
    ["dance"] = "DANCE",
    ["laugh"] = "LAUGH",
    ["hug"] = "HUG",
    ["kneel"] = "KNEEL",
    ["nod"] = "NOD",
    ["salute"] = "SALUTE",
    ["smile"] = "SMILE",
    ["thank"] = "THANK",
}
local function defaultFunc(L, key)
    -- same as the localization core table
    CritterEmote.Log(CritterEmote.Error, "No match found for: "..(key or "nil"))
    return nil
end
setmetatable( CritterEmote.EmoteMap, {__index=defaultFunc})
