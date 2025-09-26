#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"

ParseTOC( "../src/CritterEmote.toc" )

function test.before()
	chatLog = {}
	CritterEmote.OnLoad()
end
function test.after()
	test.dump(chatLog)
end

function test.test_do_emote_no_target()
	CritterEmote.OnEmote("SILLY", "")

end

test.run()
