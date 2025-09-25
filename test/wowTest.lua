-----------------------------------------
-- Author  :  Opussf
-- Date    :  September 22 2025
-- Revision:  9.5.1-17-g28f1478
-----------------------------------------
-- This is an uber simple unit test implementation
-- It creates a dictionary called test.
-- Put the normal test functions in it like:
-- function test.before() would define what to do before each test
-- function test.after() would define what to do after each test
-- function test.testName() would define a test
-- Use test.run() at the end to run them all

require "wowStubs"

-- Basic assert functions
function assertEquals( expected, actual, msg )
	msg = msg or ("Failure: expected ("..(expected or "nil")..") actual ("..(actual or "nil")..")")
	if not actual or expected ~= actual then
		error( msg )
	else
		return 1    -- passed
	end
end
function assertAlmostEquals( expected, actual, msg, places, delta)
	-- compute difference,
	-- round to places and compare to 0
	-- if delta is given, difference must be less or equal to delta
	places = tonumber(places) or 7
	delta = delta and tonumber(delta) or nil
	msg = msg or ( "Failure: expected ("..(expected or "nil")..") actual ("..(actual or "nil")..")" )
	diff = math.abs( expected - actual )

	if delta and delta == tonumber(delta) then
		if diff > delta then
			error( msg.." difference exceeds delta ("..delta..")" )
		else
			return 1
		end
	else
		diff = tonumber( string.format( "%."..places.."f", diff ) )
		if diff > 0 then
			error( msg.." difference ("..diff..") is within "..places.." places." )
		else
			return 1
		end
	end
end
function assertIsNil( expected, msg )
	msg = msg or ("Failure: Expected nil value")
	if expected and expected ~= nil then
		error( msg )
	else
		return 1
	end
end
function assertTrue( actual, msg )
	msg = msg or ("Failure: "..(actual and "True" or "False").." did not test as true.")
	assert( actual, msg )
end
function assertFalse( actual, msg )
	if actual then
		msg = msg or ("Failure: "..(actual and "True" or "False").." did not test as false.")
		error( msg )
	else
		return 1
	end
end
function fail( msg )
	error( msg )
end

test = {}
test.outFileName = "testOut.xml"
test.runInfo = {
		["count"] = 0,
		["fail"] = 0,
		["time"] = 0,
		["testResults"] = {}
}
test.coverage = {} -- {[file] = {[line] = int,}}
test.coverageIgnoreFiles = { "wowStubs", "wowTest", "test" }

function test.print(...)
	-- ... = arg
	-- io.write(unpack(arg))
--	io.write("meh:", unpack(arg))
end

-- intercept the lua's print function
--print = test.print
function test.PairsByKeys( t, f )  -- This is an awesome function I found
	local a = {}
	for n in pairs( t ) do table.insert( a, n ) end
	table.sort( a, f ) -- @TODO: Look into giving a sort function here.
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
function test.EscapeStr( strIn )
	-- This escapes a str
	strIn = string.gsub( strIn, "\\", "\\\\" )
	strIn = string.gsub( strIn, "\"", "\\\"" )
	return strIn
end
function test.dump( tableIn, depth )
	depth = depth or 1
	if tableIn then
		for k, v in test.PairsByKeys( tableIn ) do
			io.write( ("%s[%s%s%s] = "):format( string.rep("\t", depth), type(k) == "string" and "\"" or "", k, type(k) == "string" and "\"" or "" ) )
			if ( type( v ) == "boolean" ) then
				io.write( v and "true" or "false" )
			elseif ( type( v ) == "table" ) then
				io.write( "{\n" )
				test.dump( v, depth+1 )
				io.write( ("%s}"):format( string.rep("\t", depth) ) )
			elseif ( type( v ) == "string" ) then
				io.write( "\""..test.EscapeStr( v ).."\"" )
			elseif ( type( v ) == "function" ) then
				io.write( "function()" )
			else
				io.write( v )
			end
			io.write( ",\n" )
		end
	end
end

function test.toXML()
	if test.outFileName then
		local f = assert( io.open( test.outFileName, "w"))
		f:write(string.format("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"))
		f:write(string.format(
				"<testsuite errors=\"0\" failures=\"%i\" name=\"Lua.Tests\" tests=\"%i\" time=\"%0.3f\" timestamp=\"%s\">\n",
				test.runInfo.fail, test.runInfo.count, test.runInfo.time, os.date("%Y-%m-%dT%X" ) ) )
		f:write(string.format("\t<properties/>\n"))
		for tName, tData in pairs( test.runInfo.testResults ) do
			f:write(string.format("\t<testcase classname=\"%s\" name=\"%s\" time=\"%0.3f\" ",
					"Lua.Tests", tName, tData.runTime ) )
			if tData.failed then
				f:write(string.format(">\n<failure type=\"%s\">%s\n</failure>\n</testcase>\n", "testFail", tData.output ) )
			else
				f:write("/>\n")
			end
		end

		f:write(string.format("</testsuite>\n"))
		f:close()
	end
end

function test.toCobertura()
	if test.coberturaFileName then
		-- https://gcovr.com/en/stable/output/sonarqube.html
		-- https://gcovr.com/en/stable/output/cobertura.html

		-- calculate some data - meh, all coverage will be 100% for now anyway
		local coberturaTable = {}
		table.insert( coberturaTable, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" )
		table.insert( coberturaTable, "<!DOCTYPE coverage SYSTEM 'http://cobertura.sourceforge.net/xml/coverage-04.dtd'>" )
		table.insert( coberturaTable, "<coverage line-rate='1' branch-rate='0' lines-covered='0' lines-valid='0' branches-covered='0' branches-valid='0' complexity='0' timestamp='"..time().."' version='vROFL'>" )
		table.insert( coberturaTable, "<sources><source>test</source></sources>" )
		table.insert( coberturaTable, "<packages>" )
		table.insert( coberturaTable, "<package name='' line-rate='1' branch-rate='0' complexity='0'>" )
		table.insert( coberturaTable, "<classes>" )
		for file, lines in test.PairsByKeys( test.coverage ) do
			table.insert( coberturaTable, "<class name='' filename='"..file.."' line-rate='0' branch-rate='0' complexity='0'>" )
			table.insert( coberturaTable, "<methods/>" )
			table.insert( coberturaTable, "<lines>" )
			for line, count in test.PairsByKeys( lines ) do
				table.insert( coberturaTable, string.format( "<line number='%i' hits='%i' branch='false'/>", line, count ) )
			end
			table.insert( coberturaTable, "</lines>" )
			table.insert( coberturaTable, "</class>" )
		end
		table.insert( coberturaTable, "</classes>" )
		table.insert( coberturaTable, "</package>" )
		table.insert( coberturaTable, "</packages>" )
		table.insert( coberturaTable, "</coverage>" )


		local f = assert( io.open( test.coberturaFileName, "w" ) )
		f:write( table.concat( coberturaTable, "\n" ) )
		f:close()
	end
end

function test.processCoverage()
	-- prune capture table here
	for _, ignoreFile in pairs( test.coverageIgnoreFiles ) do
		for coverageFile in pairs( test.coverage ) do
			-- print( "is "..ignoreFile.." in "..coverageFile )
			if string.find( coverageFile, ignoreFile ) then
				-- print( "\tyes")
				test.coverage[coverageFile] = nil
			end
		end
	end
	test.toCobertura()
end

function test.run()
	if test.coberturaFileName then
		debug.sethook( test.hooker, "l" )
	end
	test.startTime = os.clock()
	test.runInfo.testResults = {}
	for fName in pairs( test ) do
		if string.match( fName, "^test.*" ) then
			local testStartTime = os.clock()
			test.runInfo.testResults[fName] = {}
			test.runInfo.count = test.runInfo.count + 1
			if test.before then test.before() end
			local status, exception = pcall(test[fName])
			if status then
				io.write(".")
			else
				test.runInfo.testResults[fName].output = (exception or "").."\n"..debug.traceback()
				io.write("\nF - "..fName.." failed\n")
				print( "Exception: "..(exception or "") )
				print( test.runInfo.testResults[fName].output )
				test.runInfo.fail = test.runInfo.fail + 1
				test.runInfo.testResults[fName].failed = 1
			end
			--print( status, exception )
			if test.after then test.after() end
			collectgarbage("collect")
			test.runInfo.testResults[fName].runTime = os.clock() - testStartTime
		end
	end
	test.runInfo.time = os.clock() - test.startTime
	debug.sethook()
	io.write("\n\n")
	io.write(string.format("Tests: %i  Failed: %i (%0.2f%%)  Elapsed time: %0.3f",
			test.runInfo.count, test.runInfo.fail, (test.runInfo.fail/test.runInfo.count)*100, test.runInfo.time ).."\n\n")
	test.toXML()
	test.processCoverage()
	if test.runInfo.fail and test.runInfo.fail > 0 then
		os.exit(test.runInfo.fail)
	end
end

function test.hooker( event, line, info )
	info = info or debug.getinfo( 2, "S" )
	-- print( "hooker( "..(event or "nil")..", "..(line or "nil")..", ("..(info.short_src or "nil")..", "..(info.linedefined or "nil")..") )" )
	test.coverage[info.short_src] = test.coverage[info.short_src] or {}
	test.coverage[info.short_src][line] = test.coverage[info.short_src][line] and (test.coverage[info.short_src][line] + 1) or 1
end
