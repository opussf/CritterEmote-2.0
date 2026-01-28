# Features

## #2:  %t should be expanded to either the player, or player's target if NOT the pet.

If you target a pet, and the pets does an emote with %t in it, the pet emotes itself.
Change this to have the pet emote the player if the pet is targeted.


## CustomResponseEmotes

This is a rethink from DropDowns

> Using dropdowns for pets, the user can custom configure each pet, or pet personality, for emote response emotes.

> MENU_PET_COLLECTION_PET is the tag for the default UI

Modifing the drop downs will be difficult because of how Rematch did their UI.

Create a UI with a pet portrait, ad dropdown and a scrollable text box.

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

## TargetEmotes

Allow the pet the chance to use target based emotes.
These should only fire if the player has a target.
