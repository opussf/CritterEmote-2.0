#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"
-- myLocale = "ruRU"  -- wowStubs lets me set my locale

ParseTOC( "../src/CritterEmote.toc" )

function test.before()
	Units["target"] = nil
	CritterEmote.Test_emotes = { "Mutters something." }
	chatLog = {}
	CritterEmote.emoteToSend = nil
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.logLevel = CritterEmote.Debug
	CritterEmote.OnLoad()
	CritterEmote.LOADING_SCREEN_DISABLED()
end
function test.after()
	-- test.dump(chatLog)
end

function test.test_do_emote_no_target()
	-- with no targeted critter, an emote does not set emoteToSend
	-- OnUpdate takes care of posting this later.
	Units["target"] = nil
	CritterEmote.OnEmote("SILLY", "")
	assertIsNil( CritterEmote.emoteToSend )
end
function test.test_do_emote_target_self()
	Units["target"] = Units["player"]
	CritterEmote.OnEmote("TRAIN", "")
	assertIsNil( CritterEmote.emoteToSend )
end
function test.test_do_emote_target_critter()
	Units["target"] = {
		["name"] = "pet",
		["realm"] = "not sure what this should be",
		["creatureTypeID"] = 14,
	}
	C_TooltipInfo.data = {
		["target"] = {
			["lines"] = {
				{ ["leftText"] = Units.player.name.."'s pet" },
			}
		}
	}
	CritterEmote.OnEmote("SING", "")
	assertEquals( ": CustomPetName sings with you.", CritterEmote.emoteToSend )
end
function test.test_onUpdate_randomEnabled_sets_emoteToSend()
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.randomEnabled = true
	isInCombat = false
	CritterEmote.lastUpdate = 0  -- force update
	CritterEmote_Variables.Categories.General = true
	CritterEmote.OnUpdate()
	if not CritterEmote.emoteToSend then
		test.dump(chatLog)
	end
	assertTrue( CritterEmote.emoteToSend )  -- this should be set, to be posted later
	assertAlmostEquals( time(), CritterEmote.lastUpdate, nil, nil, 1 ) -- should set the time.
end
function test.test_onUpdate_sends_emoteToSend()
	CritterEmote_Variables.enabled = true
	CritterEmote.lastUpdate = time()
	CritterEmote.emoteToSend = "Looks around for parachuting ninjas."
	CritterEmote.OnUpdate(1)
	assertEquals( "Looks around for parachuting ninjas.", chatLog[#chatLog].msg )
end
function test.test_GetEmoteMessage()
	local emoteToSend = CritterEmote.GetEmoteMessage("CHEER","petName","customName")
	-- test.dump(chatLog)
	assertEquals( "Celebrates!", emoteToSend )
end
function test.test_noCritterEmote_()
	local prefix = "CritterEmote_"
	local badThings = {}
	-- test.dump(_G)
	for n, v in pairs(_G) do
		if n:sub(1, #prefix) == prefix then
			badThings[n] = type(v)
		end
	end
	badThings.CritterEmote_SLUG = nil
	badThings.CritterEmote_Variables = nil
	badThings.CritterEmote_TypeValues = nil
	badThings.CritterEmote_CharacterVariables = nil
	test.dump(badThings)
	local count = 0
	for k, v in pairs(badThings) do
		count = count + 1
	end
	assertTrue( count <= 0 )
end
function test.test_slashCommand_help()
	CritterEmote.SlashHandler("help")
end
function test.test_slashCommand_turnOff()
	CritterEmote_Variables.enabled = true
	CritterEmote.SlashHandler("off")
	assertFalse(CritterEmote_Variables.enabled)
end
function test.test_slashCommand_turnOn()
	CritterEmote_Variables.enabled = false
	CritterEmote.SlashHandler("on")
	assertTrue(CritterEmote_Variables.enabled)
end
function test.test_slashCommand_info()
	CritterEmote.SlashHandler("info")
end
function test.test_slashCommand_random_on()
	CritterEmote_Variables.randomEnabled = false
	CritterEmote.SlashHandler("random ON")
	assertTrue(CritterEmote_Variables.randomEnabled)
end
function test.test_slashCommand_random_off()
	CritterEmote_Variables.randomEnabled = true
	CritterEmote.SlashHandler("random off")
	assertFalse(CritterEmote_Variables.randomEnabled)
end
function test.test_slashCommand_random_noFlag()
	CritterEmote_Variables.randomEnabled = true
	CritterEmote.SlashHandler("random")
	assertTrue(CritterEmote_Variables.randomEnabled)
end
function test.test_slashCommand_debug()
	CritterEmote_Variables.logLevel = 3
	CritterEmote.SlashHandler("debug")
	assertEquals( 4, CritterEmote_Variables.logLevel )
	assertEquals( "|cff00ff00Critter Emote> |rLog level is now set to Error, Warn, Info, Debug", chatLog[#chatLog].msg )
end
function test.test_slashCommand_verbose_to_Error()
	CritterEmote_Variables.logLevel = 3
	CritterEmote.SlashHandler("verbose")
	assertEquals( 1, CritterEmote_Variables.logLevel )
	assertEquals( "|cff00ff00Critter Emote> |rLog level is now set to Error", chatLog[#chatLog].msg )
end
function test.test_slashCommand_verbose_to_Info()
	CritterEmote_Variables.logLevel = 2
	CritterEmote.SlashHandler("verbose")
	assertEquals( 3, CritterEmote_Variables.logLevel )
	assertEquals( "|cff00ff00Critter Emote> |rLog level is now set to Error, Warn, Info", chatLog[#chatLog].msg )
end
function test.test_slashCommand_noCommand()
	-- this should post a random emote
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.randomEnabled = true
	CritterEmote_Variables.Categories.Test = true
	CritterEmote.SlashHandler()
	assertTrue(CritterEmote.emoteToSend)
end
function test.test_slashCommand_withMessage()
	-- this should post a random emote
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.randomEnabled = true
	CritterEmote.SlashHandler("Oh SNAP!")
	assertEquals(": CustomPetName Oh SNAP!", CritterEmote.emoteToSend)
end
function test.test_slashCommand_categorysFromList_1()
	CritterEmote_Variables.Categories.General = true
	assertTrue(CritterEmote.commandList.general, "general should be in the commandList")
	CritterEmote.SlashHandler("general")
	assertFalse(CritterEmote_Variables.Categories.General, "CritterEmote_Variables.Categories General should be false")
end
function test.test_slashCommand_categorysFromList_2()
	CritterEmote_Variables.Categories.Silly = true
	assertTrue(CritterEmote.commandList.silly, "silly should be in the commandList")
	CritterEmote.SlashHandler("silly")
	assertFalse(CritterEmote_Variables.Categories.Silly)
end
function test.test_slashCommand_categorysFromList_3()
	CritterEmote_Variables.Categories.Song = true
	assertTrue(CritterEmote.commandList.song, "song should be in the commandList")
	CritterEmote.SlashHandler("song")
	assertFalse(CritterEmote_Variables.Categories.Song)
end
function test.test_slashCommand_categorysFromList_4()
	CritterEmote_Variables.Categories.Location = false
	assertTrue(CritterEmote.commandList.location, "location should be in the commandList")
	CritterEmote.SlashHandler("location")
	assertTrue(CritterEmote_Variables.Categories.Location)
end
function test.test_slashCommand_categorysFromList_5()
	CritterEmote_Variables.Categories.Holiday = false
	assertTrue(CritterEmote.commandList.holiday, "holiday should be in the commandList")
	CritterEmote.SlashHandler("holiday")
	assertTrue(CritterEmote_Variables.Categories.Holiday)
end
function test.test_slashCommand_categorysFromList_6()
	CritterEmote_Variables.Categories.PVP = false
	assertTrue(CritterEmote.commandList.pvp, "pvp should be in the commandList")
	CritterEmote.SlashHandler("pvp")
	assertTrue(CritterEmote_Variables.Categories.PVP)
end
function test.test_emote_with_target()
	Units["target"] = {
		["name"] = "World NPC",
		["realm"] = "not sure what this should be",
		["creatureTypeID"] = 1,
	}
	CritterEmote_Variables.Categories.Target = true
	assertTrue( CritterEmote.GetRandomEmote() )
end

test.run()
