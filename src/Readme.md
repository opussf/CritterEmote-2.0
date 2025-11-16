# BP Critter Emote

Welcome to Critter Emote.

This addon will let your non-combat companion pets do fun and random emotes.

When you have a pet out it will emote something fun every five (5) minutes or so as long as you aren't in combat.

Your pets will also respond to in-game interaction.  Try /wave while targeting your pet.

## Usage

```
/ce               - send a random emote now
/ce <message>     - make the current pet emote <message>
/ce help          - shows the help message
/ce options       - options panel
/ce verbose       - change the verbosity
/ce on            - turns on Critter Emote
/ce off           - turns off Critter Emote
/ce info          - displays Critter Emote information
/ce random on     - turns periodic random emotes on
/ce random off    - turns periodic random emotes off
```

# Advanced

You are probably reading this to figure out how to add your own emotes.
If you are not, welcome to a light overview of the data structures used.

A note: These extension instructions all require adding files to the addon folder, and modifying the .toc file.
Keep your originals in a safe place, and remember to recopy and update the .toc file after addon updates.

There are 2 types of emotes, and how to add them is different.

## Random Emotes

Random emotes are what your pet does, randomly (if enabled).

These emotes are listed in tables like `CritterEmote.Silly_emotes` in `silly/CritterEmote_Silly_enUS.lua`.

The tables of emotes must have the following attributes:
* Member of: CritterEmote.  The table must be a member of CritterEmote to be considered.
* Name: <Category>_emotes.  The table name must have a capitalized Category, followed by "_emotes".

These attributes are optional:
* Structure: {array table}. The table should be an array table.
* Methods: `Init(self)` and `PickTable(self)`.
	These methods are optional.
	`Init(self)` is called when the addon is loaded. It will be called like:
	`<tableName>:Init()`

	`PickTable(self)` will be called when an emote should be choosen from that table.
	It needs to return an {array table}.

	A default `PickTable(self)` will be given if not provided.

For reference, an {array table} is a table with contiguous numeric keys.
1="", 2="", etc.

An Example:
CritterEmote.Kitty_emotes = { "purrs.", ["PickTable"] = function(self) return self end }

### How to Add to this

Create your own files in another location, copy them to the addon directory, and add to the .toc file.
Keep the originals in another location.

If you want to add to a current category, add them, as a block, to the end of the category file.
Keep a copy of the originals in another location so that you can copy them back in after updates.

If you want to create your own category, the simplist way is to create a table like the `CritterEmote.Kitty_emotes` above.
Copy that file to addon directory, and add it to the .toc file.

## Response Emotes

Response Emotes are the emotes that your pet does when you emote them directly.
The choice of which is determined from a most specific to least specific order, based on the emote.
For each emote, there are a list of reponse emotes.
A reponse list is chosen in this order:
* Custom Pet Name - You have given a specific pet a custom name
* Pet Name
* Pet Personality
* default

These are all recorded in the `CritterEmote.EmoteResponses` table.

An example is:
	DROOL = {
		default = { "wonders if you have some brain damage.", },
		ooze = { "drips slime.", },
		["Lil' K.T."] = { "says, \"I once knew a ghoul who drooled. I called him Drooly.\"", },
	},

If you `/drool` at a pet, "Lil' K.T." will have a different response than a pet in the ooze personality, and different than the defualt response.

### How to Add to this

You can add a file that directly adds emotes to `CritterEmote.EmoteResponses`, and add that file to the .toc list.

Example: `responses\Frank_EmoteResponses.lua`.

For a pet with a custom name of Frank, add to the `CritterEmote.EmoteResponses` table like this:

```
CritterEmote.EmoteResponses["ABSENT"]["Frank"] = { "hums a little tune.", "looks like they are working out a dance move.", }
CritterEmote.EmoteREsponses["DANCE"]["Frank"] = { "breaks into dance and song.", }
```

Again, keep the original in a safe place, copy it to the addon directory.

## Afterword

I hope that you enjoy this addon.
Many people have believed in this addon to keep it alive.

Please feel free to submit any emotes you wish to see included in this addon.
