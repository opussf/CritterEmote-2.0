#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"

ParseTOC( "../src/CritterEmote.toc" )

function test.before()
	chatLog = {}
	CritterEmote.emoteToSend = nil
	CritterEmote_Variables.enabled = true
	CritterEmote.OnLoad()
end
function test.after()
	-- test.dump(chatLog)
end

function test.notest_do_emote_no_target()
	-- with no targeted critter, an emote does not set emoteToSend
	-- OnUpdate takes care of posting this later.
	Units["target"] = nil
	CritterEmote.OnEmote("SILLY", "")
	assertIsNil( CritterEmote.emoteToSend )
end
function test.notest_do_emote_target_self()
	Units["target"] = Units["player"]
	CritterEmote.OnEmote("TRAIN", "")
	assertIsNil( CritterEmote.emoteToSend )
	fail( "What does UnitCreatureType return for players?" )
end
function test.notest_do_emote_target_critter()
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
function test.test_onUpdate_emoteToSend()
	CritterEmote_Variables.enabled = true
	CritterEmote_Variables.randomEnabled = true
	isInCombat = false
	CritterEmote.lastUpdate = 0  -- force update
	CritterEmote.OnUpdate()
	if not CritterEmote.emoteToSend then
		test.dump(chatLog)
	end
	print( "emoteToSend: "..CritterEmote.emoteToSend )
	assertTrue( CritterEmote.emoteToSend )  -- this should be set, to be posted later
	assertAlmostEquals( time(), CritterEmote.lastUpdate, nil, nil, 1 ) -- should set the time.
end

function test.notest_GetEmoteMessage()
	local emoteToSend = CritterEmote.GetEmoteMessage("CHEER","petName","customName")
	-- test.dump(chatLog)
	assertEquals( "Celebrates!", emoteToSend )
end
function test.notest_noCritterEmote_()
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


test.run()
