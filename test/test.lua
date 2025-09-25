#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"

ParseTOC( "../src/CritterEmote.toc" )

function test.before()
	chatLog = {}
end
function test.after()
	test.dump(chatLog)
end

test.run()
