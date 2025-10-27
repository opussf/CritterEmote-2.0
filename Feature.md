# Features

## FlexibleCategories

This is to allow flexible categories.
To start, look for any entry in the CritterEmote table with a name like `CategoryName_emotes`.
It should be an array type of table.
It can have an [init] function, to determine what it needs to do to be ready to be used (see example below).
It can have a [pick] function, to figure out what to do to pick an emote.

If neither of those functions are present, then no [init] is called, and a built-in [pick] function will be called on the table.
The built-in [pick] will assume that the table is an array of strings.

An example of the [init] function might be for the Holiday emotes, which have a seperate array for each holiday to respond to.
Though, thinking of this, the [pick] might be a better way of doing it.

