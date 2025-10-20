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
	test.dump(chatLog)
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
function test.notest_onUpdate_emoteToSend()
	CritterEmote.OnUpdate()
	CritterEmote_Variables.randomEnabled = true
	test.dump(CritterEmote)
	-- fail()
end
function test.notest_GetEmoteMessage()
	CritterEmote_Personalities = CritterEmote.Personalities
	CritterEmote_ResponseDb = CritterEmote.EmoteResponses
	CritterEmote_Cats = {
		Normal = true;
		Silly = true;
		Song = true;
		Locations = true;
		Special = true;
		PVP = true;
	}
	print(CritterEmote_GetEmoteMessage1("CHEER","petName","customName"))
	-- test.dump(CritterEmote_ResponseDb)
	-- test.dump(CritterEmote_Personalities)
	fail()
end
function test.test_noCritterEmote_()
	local prefix = "CritterEmote_"
	local badThings = {}
	-- test.dump(_G)
	for n, v in pairs(_G) do
		if n:sub(1, #prefix) == prefix then
			table.insert( badThings, {n, type(v)} )
		end
	end
	if #badThings > 3 then
		test.dump(badThings)
	end
	assertTrue( #badThings <= 3 )
end
function test.test_yaya()
	assertIsNil( CritterEmote_testThingy )
	-- fail()
end


test.run()
