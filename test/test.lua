#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"
-- myLocale = "ruRU"  -- wowStubs lets me set my locale

ParseTOC( "../src/CritterEmote.toc" )

function test.before()
	chatLog = {}
	CritterEmote.emoteToSend = nil
	CritterEmote_Variables.enabled = true
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
		["creatureType"] = "Wild Pet",
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
	assertEquals( "Looks around for parachuting ninjas.", chatLog[1].msg )
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
	test.dump(chatLog)
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
end
function test.test_slashCommand_verbose()
	CritterEmote_Variables.logLevel = 3
	CritterEmote.SlashHandler("verbose")
	assertEquals( 1, CritterEmote_Variables.logLevel )
end
function test.test_slashCommand_noCommand()
	-- this should post a random emote
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.randomEnabled = true
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
	assertTrue(CritterEmote.commandList.general)
	CritterEmote.SlashHandler("general")
	assertFalse(CritterEmote_Variables.Categories.General)
end
function test.test_slashCommand_categorysFromList_2()
	CritterEmote_Variables.Categories.General = true
	assertTrue(CritterEmote.commandList.silly)
	CritterEmote.SlashHandler("silly")
	assertFalse(CritterEmote_Variables.Categories.Silly)
end
function test.test_slashCommand_categorysFromList_3()
	CritterEmote_Variables.Categories.Song = true
	assertTrue(CritterEmote.commandList.song)
	CritterEmote.SlashHandler("song")
	assertFalse(CritterEmote_Variables.Categories.Song)
end
function test.test_slashCommand_categorysFromList_4()
	CritterEmote_Variables.Categories.Location = false
	assertTrue(CritterEmote.commandList.location)
	CritterEmote.SlashHandler("location")
	assertTrue(CritterEmote_Variables.Categories.Location)
end
function test.test_slashCommand_categorysFromList_5()
	CritterEmote_Variables.Categories.Special = false
	assertTrue(CritterEmote.commandList.special)
	CritterEmote.SlashHandler("special")
	assertTrue(CritterEmote_Variables.Categories.Special)
end
function test.test_slashCommand_categorysFromList_6()
	CritterEmote_Variables.Categories.PVP = false
	assertTrue(CritterEmote.commandList.pvp)
	CritterEmote.SlashHandler("pvp")
	assertTrue(CritterEmote_Variables.Categories.PVP)
end

test.run()
