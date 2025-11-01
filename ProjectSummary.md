# CritterEmote 2.0 – Project Summary

Goal:
CritterEmote is a World of Warcraft addon that makes battle pets (“companion pets”) feel more alive by having them respond in chat to player actions, slash commands, and in-game events. Version 2.0 is a ground-up rewrite focused on modernization, modularity, and better player control.

Core Features related to the Tables:

    Slash Command Responses – Pets respond to player slash emotes (e.g. /kiss, /wave) with a themed chat message.

    Random Emotes – Pets occasionally post randomized messages from categories such as Silly, Songs, Locations, PVP, and General.

    Holiday Events – Special seasonal lines (e.g., “Love is in the Air”), recognizing that occasionally there are multiple in-game holidays for which random holiday emotes can be appropriately generated. (AI and I had this working for a moment, but it disrupted other parts of the main program.)

    Target Awareness – Messages can reference players, NPCs, hunter pets, or other battle pets when targeted.

        Example: if the player has Gamon targeted in Orgrimmar, the pet may randomly put into chat, "RollerDerby thinks Gamon is crazy."

    Toggleable Categories – Players can enable/disable entire categories (or mute the addon entirely) via UI checkboxes.

    Localization Support – Built with Ace3 to allow multiple language files, starting with English (US).

    PVP Servers or BGs -- recognizing the server type and the alignment of the character (Horde/Alliance). If a pet is in a battleground, allow random, appropriate Horde/Alliance chat output.

Technical Direction:

    Migrating from a monolithic file to a modular Lua system: separate tables for slash commands, random emotes, holidays, etc. This makes it easier to delete and add more relevant emotes. 

    Adding (darn, my husband came in and reminded me I forgot to feed him lunch. I will try to recall what else I was trying to add.)

    Adding an Ace3-based UI panel (CritterEmote_UI.lua) for easier configuration of activating/inactivating Tables. 

    Ensuring compatibility with WoW Retail API (patch 11.2 and beyond), including avoiding conflicts with addons like PetTracker.

    Preparing for localization expansion by structuring tables for easy translation.

    Using GitHub for version control, with a stable branch and a dev branch for ongoing work.

Example Use Case for slash commands:
If a character named Lysandia summons her Iron Starlette (pet type: Mech), which is named "RollerDerby", and targets RollerDerby with /wave, the response is:

    RollerDerby waves back at Lysandia.

Planned Enhancements:

    Better handling of multiple holidays occurring simultaneously.

    Improved Blizzard API integration for pulling updated pet data. (This has been completed. The old method was amazingly tedious.)

    Creating an addon for the Classic versions of WoW (MoP first).

    Expansion of translation files for multiple languages (local). Integrating them according to the Server, with the option to change the default language.


=======================================

## Things done:

[x] Slash Command Responses
[x] Random Emotes
[x] Holiday Events - Still have to figure out how to force calendar load
[x] Target awareness
[x] Toggleable Categories
[x] Localization Support - Mostly.  Need to try on another locale.
[x] Horde / Alliance themed emotes - Should be fairly simple

[x] UI panel - Still want to improve
[x] should have no conflicts as only a few tables in the global space.
[x] Localization should be easy.  Need to review the things to localize.

[x] Multiple holidays should create a longer table to choose from.
[x] API integration.
[ ] Classic version done.
[x] translations should be done based on client locale.
