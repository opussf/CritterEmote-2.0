#!/usr/bin/env python3
"""
This was used to import the personalities from the old lua format (["name"] = "personality").
I had done some search-replate to turn each line into a JSON object:
    {"name": "petname", "personality": "petpersonality"}
This was entirely to populate the data/pets.json file for the first time.

There is probably never a reason to use this again. Just posting.
"""

import json

# Load main JSON file (dictionary keyed by ID)
with open("data/pets.json", "r", encoding="utf-8") as f:
    main_data = json.load(f)

# Load secondary file (list of objects, one per line)
update_data = {}
with open("personalities.lua", "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()[:-1]
        try:
            obj = json.loads(line)
            update_data[obj["name"]] = obj
        except:
            pass

# Update main_data based on name match
new_data = {}
for old_id, info in main_data.items():
    name = info["name"]
    if name in update_data:
        # Keep old_id, but replace the value with the update
        new_data[old_id] = update_data[name]
    else:
         # No match, keep original
        new_data[old_id] = info

# Write back
with open("main_updated.json", "w", encoding="utf-8") as f:
    json.dump(new_data, f, ensure_ascii=False, indent=4)
