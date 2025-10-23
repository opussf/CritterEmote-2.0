local _, CritterEmote = ...

CritterEmote.EmoteMap = {
    ["WAVE"] = "WAVE",
    ["CHEER"] = "CHEER",
    ["RAISE"] = "ANGRY",
    ["KISS"] = "KISS",
    ["DANCE"] = "DANCE",
    ["LAUGH"] = "LAUGH",
    ["HUG"] = "HUG",
    ["KNEEL"] = "KNEEL",
    ["NOD"] = "NOD",
    ["SALUTE"] = "SALUTE",
    ["SMILE"] = "SMILE",
    ["THANK"] = "THANK",
}
local function defaultFunc(L, key)
    -- same as the localization core table.
    -- this prints an error if the mapping is not found.
    -- @TODO: This metatable entry should probably setup just like the localization,
    --        Where the key is returned if no entry is found.
    CritterEmote.Log(CritterEmote.Error, "No match found for: "..(key or "nil"))
    return nil
end
setmetatable( CritterEmote.EmoteMap, {__index=defaultFunc})
