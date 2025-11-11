Welcome to Critter Emote.

You are probably reading this to figure out how to add your own emotes.

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

For reference, and {array table} is a table with contiguous numeric keys.
1="", 2="", etc.

An Example:
CritterEmote.Kitty_emotes = { "purrs.", ["PickTable"] = function(self) return self end }

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

You can add a file that directly adds emotes to `CritterEmote.EmoteResponses`.

