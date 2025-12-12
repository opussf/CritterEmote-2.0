# Notes

## Questions

* "slash commands when targeted" means emotes to pet?


## Ideas

* Create tables of emotes.
* Each table has an "init" and a "choose" method that can be overridden.
* Add an ability for the user to create their own.
  * Account
  * Per character





  -------

BACKPACK_PATCHES = {
  add = {
    ["Argent Squire"] = {
      "shines armor with a little rag.",
      "pets the pony companion lovingly.",
    },
    ["New Pet"] = {
      "does a little dance.",
    },
  },

  remove = {
    ["Argent Squire"] = {
      "\"What are you looking for? May I be of assistance?\"",
    },
    ["ooze"] = true, -- remove entire key
  },
}

Rules:
add[key] — adds new strings to the list at that key (creating the key if needed).

remove[key]:
If it’s a table, remove specific strings from the list.
If it’s true, remove the entire key from the base table.
-----------

function applyPatches(base, patches)
  -- Handle removals first
  if patches.remove then
    for key, val in pairs(patches.remove) do
      if val == true then
        base[key] = nil
      elseif type(val) == "table" and type(base[key]) == "table" then
        local removeSet = {}
        for _, str in ipairs(val) do
          removeSet[str] = true
        end
        local newList = {}
        for _, str in ipairs(base[key]) do
          if not removeSet[str] then
            table.insert(newList, str)
          end
        end
        base[key] = newList
      end
    end
  end

  -- Handle additions
  if patches.add then
    for key, newEntries in pairs(patches.add) do
      base[key] = base[key] or {}
      for _, str in ipairs(newEntries) do
        table.insert(base[key], str)
      end
    end
  end
end


------------

USER_PATCHES = {
  ["Argent Squire"] = {
    add = {
      "shines armor with a little rag.",
      "pets the pony companion lovingly.",
    },
    remove = {
      "\"What are you looking for? May I be of assistance?\"",
    },
  },
  ["ooze"] = {
    remove = true,  -- if user deleted all entries
  },
}

function getEffectiveList(name)
  local base = BACKPACK[name]
  local patch = USER_PATCHES[name]
  local list = {}

  -- Start with base
  if type(base) == "table" then
    for _, v in ipairs(base) do
      table.insert(list, v)
    end
  end

  if patch then
    -- Remove
    if patch.remove == true then
      return {} -- user deleted everything
    elseif type(patch.remove) == "table" then
      local removeSet = {}
      for _, s in ipairs(patch.remove) do
        removeSet[s] = true
      end
      local newList = {}
      for _, v in ipairs(list) do
        if not removeSet[v] then
          table.insert(newList, v)
        end
      end
      list = newList
    end

    -- Add
    if type(patch.add) == "table" then
      for _, s in ipairs(patch.add) do
        table.insert(list, s)
      end
    end
  end

  return list
end


function computePatch(baseList, newList)
  local patch = {}
  local baseSet, newSet = {}, {}
  for _, v in ipairs(baseList or {}) do baseSet[v] = true end
  for _, v in ipairs(newList or {}) do newSet[v] = true end

  for v in pairs(newSet) do
    if not baseSet[v] then
      patch.add = patch.add or {}
      table.insert(patch.add, v)
    end
  end

  for v in pairs(baseSet) do
    if not newSet[v] then
      patch.remove = patch.remove or {}
      table.insert(patch.remove, v)
    end
  end

  if not next(patch) then return nil end
  return patch
end

