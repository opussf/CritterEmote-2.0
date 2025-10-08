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
function test.test_onUpdate_emoteToSend()
	CritterEmote.OnUpdate()
	CritterEmote.Personalities = nil
	CritterEmote_Variables.randomEnabled = true
	test.dump(CritterEmote)
	fail()

end


test.run()
