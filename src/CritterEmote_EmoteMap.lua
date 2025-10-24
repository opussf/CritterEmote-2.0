local _, CritterEmote = ...

CritterEmote.EmoteMap = {
    ["RAISE"] = "ANGRY",

}
local function defaultFunc(L, key)
    -- same as the localization core table.
    -- this prints an error if the mapping is not found.
    -- @TODO: This metatable entry should probably setup just like the localization,
    --        Where the key is returned if no entry is found.
    CritterEmote.Log(CritterEmote.Error, "EmoteMap: No match found for: "..(key or "nil")..". Returning: "..key)
    return key
end
setmetatable( CritterEmote.EmoteMap, {__index=defaultFunc})
