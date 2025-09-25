-----------------------------------------
-- Author  :  Opussf
-- Date    :  September 22 2025
-- Revision:  9.5.1-17-g28f1478
-----------------------------------------
-- These are functions from wow that have been needed by addons so far
-- Not a complete list of the functions.
-- Most are only stubbed enough to pass the tests
-- This is not intended to replace WoWBench, but to provide a stub structure for
--     automated unit tests.
-- Setup:
-- * Create test.lua  - Add #!/usr/bin/env lua
-- * require "wowTest"
-- * set test.outFileName to an ouput.xml file
-- * set test.coberturaFileName = "../coverage.xml" to enable coverage output
-- * Parse the TOC - ParseTOC( "../src/sonthing.toc" )
-- * Setup any 'Normal Frames'

settings = {
}
actionLog = {
}
buildInfo = {
	"1.1.1",       --version
	"3255",        --build
	"Sep 12 2025", --date
	20400          --TOC Version
}
-- append actions to the log to track actions that may not have an other sideeffects.
-- record the function calls
-- [1] = "DoEmote(....)""
chatLog = {
-- append chat output here
-- [1] = { ["msg"] = "ChatOutput", ["channel"] = "where", [<other parameters>] = <values> }
}

local itemDB = {
}

_G["GUILD"] = "Guild"
_G["INSTANCE"] = "instance"
_G["PARTY"] = "Party"
_G["RAID"] = "Raid"
_G["SAY"] = "Say"
_G["WHISPER"] = "Whisper"
_G["YELL"] = "Yell"

-- simulate an internal inventory
-- myInventory = { ["9999"] = 52, }
		-- myInventory = { ["9999"] = {52, 0, 1}, }
		-- myInventory = { ["<itemID"] = {<count>, <bagID>, <slotID>}, }
myInventory = {}
-- bagInfo is the info about the containers themselves
-- bagInfo = {<size>, <type>}
bagInfo = {
	[0] = {16, 0},
}
myCurrencies = {}
myCopper = 0
-- myCopper is the amount of Copper that you own on this toon
-- set one of these to the number of people in the raid or party to reflect being in group or raid.
-- roster should be an array for GetRaidRosterInfo
myParty = { ["group"] = nil, ["raid"] = nil, ["roster"] = {} }
playerRange = {}  -- { ["party1"] = <yards> }
dungeonDifficultyLookup = { [34] = "Timewalking" }
myGuild = { ["name"] = "Test Guild", }
-- set myGuild = {} to simulate not in a guild
outMail = {}
inbox = {}
onCursor = {}
-- onCursor["item"] = itemId
-- onCursor["quantity"] = # of item
-- onCursor["from"] = picked up from -- Should have enough info to effect an item swap "myInventory | myGear"
globals = {}
accountExpansionLevel = 4   -- 0 to 5
-- registeredPrefixes - populated by the RegisterAddonMessagePrefix( prefix )
unitSpeeds = { ["player"] = 0 }

myStatistics = {
	[60] = 42  -- 60 = deaths
}
myLocale = "enUS"
myZone = {["Zone"] = "Thing", ["Sub"] = "Sub"}

registeredPrefixes = {}

SlotListMap={ "HeadSlot","NeckSlot","ShoulderSlot","ShirtSlot","ChestSlot","WaistSlot","LegsSlot",
		"FeetSlot", "WristSlot", "HandsSlot", "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
		"BackSlot", "MainHandSlot","SecondaryHandSlot","RangedSlot","TabardSlot", "Bag0Slot", "Bag1Slot",
		"Bag2Slot", "Bag3Slot",
}
myGear = {} -- items that are equipped in the above slots, index matching
Items = {
	["6948"] = {["name"] = "Hearthstone", ["link"] = "|cffffffff|Hitem:6948::::::::70:258:::::::::|h[Hearthstone]|h|r", ["texture"] = ""},
	["7073"] = {["name"] = "Broken Fang", ["link"] = "|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0:0|h[Broken Fang]|h|r", ["texture"] = ""},
	["6742"] = {["name"] = "UnBroken Fang", ["link"] = "|cff9d9d9d|Hitem:6742:0:0:0:0:0:0:0:80:0:0|h[UnBroken Fang]|h|r", ["texture"] = ""},
	["22261"] = {["name"] = "Love Fool", ["link"] = "|cff9d9d9d|Hitem:22261:0:0:0:0:0:0:0:80:0:0|h[Love Fool]|h|r", ["texture"] = ""},
	["23784"] = {["name"] = "Adamantite Frame", ["link"] = "|cff9d9d9d|Hitem:23784:0:0:0:0:0:0:0:80:0:0|h[Adanabtute Frame]|h|r", ["texture"] = ""},
	["23786"] = {["name"] = "Khorium Power Core", ["link"] = "|cffffff|Hitem:23786|h[Khorium Power Core]|h|r", ["texture"] = ""},
	["23787"] = {["name"] = "Felsteel Stabilizer", ["link"] = "|cffffff|Hitem:23787|h[Felsteel Stabilizer]|h|r", ["texture"] = ""},
	["34061"] = {["name"] = "Turbo-Charged Flying Machine", ["link"] = "|cff9d9d9d|Hitem:34061:0:0:0:0:0:0:0:80:0:0|h[Turbo-Charged Flying Machine]|h|r", ["texture"] = ""},
	["34249"] = {["name"] = "Hula Girl Doll", ["link"] = "|cffffff|Hitem:34249|h[Hula Girl Doll]|h|r", ["texture"] = ""},
	["45579"] = {["name"] = "Darnassus Tabard", ["link"] = "|cffffffff|Hitem:45579:0:0:0:0:0:0:0:14:258:0:0:0|h[Darnassus Tabard]|h|r", ["texture"] = ""},
	["45580"] = {["name"] = "Exodar Tabard", ["link"] = "|cffffffff|Hitem:45580:0:0:0:0:0:0:0:14:258:0:0:0|h[Exodar Tabard]|h|r", ["texture"] = ""},
	["49916"] = {["name"] = "Lovely Charm Bracelet", ["link"] = "|cff9d9d9d|Hitem:49916:0:0:0:0:0:0:0:80:0:0|h[Lovely Charm Bracelet]|h|r", ["texture"] = ""},
	["49927"] = {["name"] = "Love Token", ["link"] = "|cff9d9d9d|Hitem:49927:0:0:0:0:0:0:0:80:0:0|h[Love Token]|h|r", ["texture"] = ""},
	["74661"] = {["name"] = "Black Pepper", ["link"] = "|cffffffff|Hitem:74661:0:0:0:0:0:0:0:90:0:0|h[Black Pepper]|h|r", ["texture"] = ""},
	["85216"] = {["name"] = "Enigma Seed", ["link"]= "|cffffffff|Hitem:85216:0:0:0:0:0:0:0:90:0:0|h[Enigma Seed]|h|r", ["texture"] = ""},
	["113596"] = {["name"] = "Vilebreath Mask", ["link"] = "|cffffffff|Hitem:113596:0:0:0:0:0:0:0:90:0:0|h[Vilebreath Mask]|h|r", ["slotPrefix"] = "Head", ["texture"] = ""},
--[[
Vilebreath Mask
Item Level 655
Binds when picked up
Head	Cloth
85 Armor
+211 Intellect
+316 Stamina
+120 Mastery (1.09 @ L100)
+153 Multistrike (2.32% @ L100)
Durability 100 / 100
Requires Level 100
Sell Price: 32 81 73
Dropped by: Kargath Bladefist
Drop Chance: 11.48%
]]
    -- ^^ Need another head item for testing.
    ["999999"] = {["name"] = "Finger Thing", ["link"] = "|cffffffff|Hitem:999999:0:0:0:0:0:0:0:90:0:0|h[Finger Thing|h|r", ["slotPrefix"] = "Finger", ["texture"] = ""},
}

-- simulate the data structure that is the flight map
-- Since most the data assumes Alliance, base it on being at Stormwind
TaxiNodes = {
	{["name"] = "Stormwind", ["type"] = "CURRENT", ["hops"] = 0, ["cost"] = 0},
	{["name"] = "Rebel Camp", ["type"] = "REACHABLE", ["hops"] = 1, ["cost"] = 40},
	{["name"] = "Ironforge", ["type"] = "NONE", ["hops"] = 1, ["cost"]=1000},
}
Currencies = {
	[1] = { ["name"] = "Currency Token Test Token 4", ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = false, ["link"] = "|cffffffff|Hcurrency:1|h[Currency Token Test Token 4]|h|r"},
	[384] = { ["name"] = "Dwarf Archaeology Fragment", ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 200, isDiscovered = true, ["link"] = "|cff9d9d9d|Hcurrency:384:0:0:0:0:0:0:0:80:0:0|h[Dwarf Archaeology Fragment]|h|r"},
	[390] = { ["name"] = "Conquest", ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = true, ["link"] = ""},
	[392] = { ["name"] = "Honor",    ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = true, ["link"] = ""},
	[395] = { ["name"] = "Justice",  ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = true, ["link"] = ""},
	[396] = { ["name"] = "Valor",    ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = true, ["link"] = ""},
	[402] = { ["name"] = "Ironpaw Token", ["texturePath"] = "", ["weeklyMax"] = 0, ["totalMax"] = 0, isDiscovered = true, ["link"] = "|cff9d9d9d|Hcurrency:402:0:0:0:0:0:0:0:80:0:0|h[Ironpaw Token]|h|r"},
	[703] = { ["name"] = "Fictional Currency", ["texturePath"] = "", ["weeklyMax"] = 1000, ["totalMax"] = 4000, isDiscovered = true, ["link"] = "|cffffffff|Hcurrency:703|h[Fictional Currency]|h|r"},
	[824] = { ["name"] = "Garrison Resources", ["texturePath"] = "", ["quantity"] = 100 },
	[3044]= { ["name"] = "Engineering Concentration", ["totalMax"] = 1000}
}
ArchaeologyCurrencies = {"999",}
MerchantInventory = {
	{["id"] = "7073", ["cost"] = 5000, ["quantity"] = 1, ["isUsable"] = 1},
	{["id"] = "6742", ["cost"] = 10000, ["quantity"] = 1, ["isUsable"] = 1},
	{["id"] = "22261", ["cost"] = 0, ["quantity"] = 1, ["isUsable"] = 1,
		["currencies"] = {{["id"] = "49927", ["type"] = "item", ["quantity"] = 10},}},
	{["id"] = "49927", ["cost"] = 0, ["quantity"] = 1, ["isUsable"] = 1,
		["currencies"] = {{["id"] = "49916", ["type"] = "item", ["quantity"] = 1},}},  -- Lovely Charm Bracelet
	{["id"] = "74661", ["cost"] = 0, ["quantity"] = 1, ["isUsable"] = 1,
		["currencies"] = {{["id"] = 402, ["type"] = "currency", ["quantity"] = 1},}},
	{["id"] = "85216", ["cost"] = 2500, ["quantity"] = 1, ["isUsable"] = nil},
}
TradeSkillItems = {
	{["id"] = "44157", ["name"] = "Engineering: Turbo-Charged Flying Machine", ["cost"]= 0, ["numReagents"] = 4,
		["minMade"] = 1, ["maxMade"] = 1,
		["elink"] = "|cffffffff|Henchant:44157|h[Engineering: Turbo-Charged Flying Machine]|h|r",
		["ilink"] = "|cff9d9d9d|Hitem:34061:0:0:0:0:0:0:0:80:0:0|h[Turbo-Charged Flying Machine]|h|r",
		["reagents"] = {{["id"] = "23784", ["count"] = 4}, -- Adamantite Frame
				{["id"] = "23786", ["count"] = 8},  -- Khorium Power Core
				{["id"] = "23787", ["count"] = 8},  -- Felsteel Stabilizer
				{["id"] = "34249", ["count"] = 1},  -- Hula Girl Doll
		},
	},
}
Achievements = {
	["10722"] = {
		["link"] = "|cffffff00|Hachievement:10722:Player-3661-06DAB4ED:0:0:0:-1:524288:0:0:0|h[The Wish Remover]|h|r",
		["criteria"] = {
			{ 	["description"] = "Broken Fang thingy",
				["type"] = 36,
				["completed"] = false,
				["quantity"] = 0,
				["reqQuantity"] = 1,
				["charName"] = "",
				["flags"] = nil,
				["assetID"] = "7073",
				["quantityString"] = "string",
				["criteriaID"] = "id",
			},
			{	["description"] = "string",
				["type"] = 36,
				["completed"] = false,
				["quantity"] = 0,
				["reqQuantity"] = 1,
				["charName"] = "",
				["flags"] = nil,
				["assetID"] = "6742",
				["quantityString"] = "string",
				["criteriaID"] = "id",
			}
		},
		["name"] = "The Wish Remover",
		["points"] =10,
		["completed"] = false,
		["month"] = nil,
		["day"] = nil,
		["year"] = nil,
		["description"] = "Fishing in Dalaran fountain (again)",
		["flags"] = 0x00000000,
		["icon"] = "",
		["rewardText"] = "",
		["isGuildAch"] = false,
		["wasEarnedByMe"] = false,
		["earnedBy"] = ""
	},
	[5738] = {
		["name"] = "Deadmines",
		["points"] = 10,
		["value"] = "6",


	}

	--[[return id, achiveInfo['name'], achiveInfo['points'], achiveInfo['completed'], achiveInfo['month'], achiveInfo['day'], achiveInfo['year'],
		achiveInfo['description'], achiveInfo['flags'], achiveInfo['icon'], achiveInfo['rewardText'], achiveInfo['isGuildAch'],
		achiveInfo['wasEarnedByMe'], achiveInfo['earnedBy']
		]]
}
-- EquipmentSets is an array (1 based numeric key table)
EquipmentSets = {
	{["name"] = "testSet", ["icon"] = "icon", ["items"] = {[1] = "113596"},},
}
-- Instance variables
LE_PARTY_CATEGORY_HOME = 1
LE_PARTY_CATEGORY_INSTANCE = 2
-- WowToken
TokenPrice = 123456 -- 12G 34S 45C
--- Factions
FACTION_STANDING_LABEL1 = "Hated"
FACTION_STANDING_LABEL2 = "Hostile"
FACTION_STANDING_LABEL3 = "Unfriendly"
FACTION_STANDING_LABEL4 = "Neutral"
FACTION_STANDING_LABEL5 = "Friendly"
FACTION_STANDING_LABEL6 = "Honored"
FACTION_STANDING_LABEL7 = "Revered"
FACTION_STANDING_LABEL8 = "Exalted"
FACTION_STANDING_INCREASED = "Reputation with %s increased by %d."
FACTION_STANDING_DECREASED = "Reputation with %s decreased by %d."
FACTION_STANDING_INCREASED_GUARDIAN = "%s has gained %d guardian experience points."
FACTION_STANDING_INCREASED_ACCOUNT_WIDE = "Your Warband's reputation with %s increased by %d."
FACTION_STANDING_DECREASED_ACCOUNT_WIDE = "Your Warband's reputation with %s decreased by %d."

COMBATLOG_OBJECT_AFFILIATION_OUTSIDER = 8
COMBATLOG_XPGAIN_FIRSTPERSON = "%s dies, you gain %d experience."
COMBATLOG_XPGAIN_EXHAUSTION1 = "%s dies, you gain %d experience. (%s exp %s bonus)"

--[[
				{ Name = "factionID", Type = "number", Nilable = false },
				{ Name = "name", Type = "cstring", Nilable = false },
				{ Name = "description", Type = "cstring", Nilable = false },
				{ Name = "reaction", Type = "luaIndex", Nilable = false },
				{ Name = "currentReactionThreshold", Type = "number", Nilable = false },
				{ Name = "nextReactionThreshold", Type = "number", Nilable = false },
				{ Name = "currentStanding", Type = "number", Nilable = false },
				{ Name = "atWarWith", Type = "bool", Nilable = false },
				{ Name = "canToggleAtWar", Type = "bool", Nilable = false },
				{ Name = "isChild", Type = "bool", Nilable = false },
				{ Name = "isHeader", Type = "bool", Nilable = false },
				{ Name = "isHeaderWithRep", Type = "bool", Nilable = false },
				{ Name = "isCollapsed", Type = "bool", Nilable = false },
				{ Name = "isWatched", Type = "bool", Nilable = false },
				{ Name = "hasBonusRepGain", Type = "bool", Nilable = false },
				{ Name = "canSetInactive", Type = "bool", Nilable = false },
				{ Name = "isAccountWide", Type = "bool", Nilable = false },
]]
FactionInfo = {
	{
		["factionID"] =   72, ["name"] = "Stormwind", ["description"] = "", ["reaction"] = 7, ["currentReactionThreshold"] = 21000,
		["nextReactionThreshold"] = 42000, ["currentStanding"] = 33397, ["atWarWith"] = false, ["canToggleAtWar"] = false,
		["isChild"] = true, ["isHeader"] = false, ["isHeaderWithRep"] = false, ["isCollapsed"] = false, ["isWatched"] = true,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = false,
	},
	{
		["factionID"] =  469, ["name"] = "Alliance", ["description"] = "", ["reaction"] = 6, ["currentReactionThreshold"] = 9000,
		["nextReactionThreshold"] = 21000, ["currentStanding"] = 10390, ["atWarWith"] = false, ["canToggleAtWar"] = false,
		["isChild"] = false, ["isHeader"] = true, ["isHeaderWithRep"] = false, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = false,
	},
	{
		["factionID"] =  909, ["name"] = "Darkmoon Faire", ["description"] = "description and stuff", ["reaction"] = 5, ["currentReactionThreshold"] = 3000,
		["nextReactionThreshold"] = 9000, ["currentStanding"] = 7575, ["atWarWith"] = false, ["canToggleAtWar"] = false,
		["isChild"] = true, ["isHeader"] = false, ["isHeaderWithRep"] = false, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = false,
	},
	{
		["factionID"] = 1118, ["name"] = "Classic", ["description"] = "", ["reaction"] = 4, ["currentReactionThreshold"] = 0,
		["nextReactionThreshold"] = 4000, ["currentStanding"] = 0, ["atWarWith"] = false, ["canToggleAtWar"] = true,
		["isChild"] = false, ["isHeader"] = true, ["isHeaderWithRep"] = true, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = false,
	},
	{
		["factionID"] = 2001, ["name"] = "Find my Name", ["description"] = "", ["reaction"] = 4, ["currentReactionThreshold"] = 0,
		["nextReactionThreshold"] = 4000, ["currentStanding"] = 0, ["atWarWith"] = false, ["canToggleAtWar"] = true,
		["isChild"] = false, ["isHeader"] = true, ["isHeaderWithRep"] = true, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = true,
	},
	{
		["factionID"] = 1282, ["name"] = "Fish Fellrend", ["description"] = "", ["reaction"] = 5, ["currentReactionThreshold"] = 0,
		["nextReactionThreshold"] = 4000, ["currentStanding"] = 0, ["atWarWith"] = false, ["canToggleAtWar"] = true,
		["isChild"] = false, ["isHeader"] = true, ["isHeaderWithRep"] = true, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = true,
	},
	{
		["factionID"] = 2010, ["name"] = "Max", ["description"] = "", ["reaction"] = 8, ["currentReactionThreshold"] = 42000,
		["nextReactionThreshold"] = 42000, ["currentStanding"] = 42000, ["atWarWith"] = false, ["canToggleAtWar"] = true,
		["isChild"] = false, ["isHeader"] = true, ["isHeaderWithRep"] = true, ["isCollapsed"] = false, ["isWatched"] = false,
		["hasBonusRepGain"] = false, ["canSetInactive"] = false, ["isAccountWide"] = true,
	},

}
--Auras
-- IIRC (Look this up) Auras are index based, use an index based system
-- ["unit"] = { [1] = { ["Fishing"] = true }}
UnitAuras = {}
--UnitAuras = {["player"] = { { ["name"] = "Fishing" } } }
-- 'support' code for setting / clearing auras
function wowSetAura( unit, auraName )
	if (UnitAuras[unit]) then
		for i, auras in pairs( UnitAuras[unit] ) do
			if( auras.name == auraName ) then
				return
			end
		end
		table.insert( UnitAuras[unit], { { ["name"] = auraName } } )
	else  -- unknown unit
		UnitAuras[unit] = { { ["name"] = auraName } }
	end
end
function wowClearAura( unit, auraName )
	if UnitAuras[unit] then
		for i, aura in pairs( UnitAuras[unit] ) do
			if( aura.name == auraName ) then
				UnitAuras[unit][i] = nil
			end
		end
		if (#UnitAuras[unit] == 0) then
			UnitAuras[unit] = nil
		end
	end
end

-- WOW's function renames
format = string.format
strmatch = string.match
strfind = string.find
strsub = string.sub
strlower = string.lower
strlen = string.len
time = os.time
date = os.date
max = math.max
min = math.min
abs = math.abs
random = math.random
tinsert = table.insert
unpack = table.unpack

bit = {}
function bit.lshift( x, by )
	return x * 2 ^ by
end
function bit.rshift( x, by )
	return math.floor( x / 2 ^ by )
end
function bit.bor( a, b )  -- bitwise or
	local p,c=1,0
	while a+b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>0 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c
end
function bit.band( a, b ) -- bitwise and
	local p,c=1,0
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c
end
function bit.bnot( n )  -- bitwise not
	local p,c=1,0
	while n>0 do
		local r=n%2
		if r<1 then c=c+p end
		n,p=(n-r)/2,p*2
	end
	return c
end
-- Sound Kit
SOUNDKIT = {
	ALARM_CLOCK_WARNING_1 = 18871,
}

-- WOW's functions
function getglobal( globalStr )
	-- set the globals table to return what is needed from the 'globals'
	return globals[ globalStr ]
end
function hooksecurefunc( externalFunc, internalFunc )
end
function strsplit( delim, subject, pieces )
	-- delim is a string that defines all the bytes that may split the string
	-- subject is the string to work with
	-- pieces (optional) is the maximum number of pieces to return
	splitTable = {}
	--print("strsplit( "..delim..", "..subject..", "..(pieces or "nil").." )")
	pos, count = 1, 1
	pieces = pieces or string.len(subject)
	while true do
		s, e = strfind(subject, delim, pos)
		if (s and count<pieces) then -- found delim in subject
			tinsert( splitTable, strsub( subject, pos, s-1 ) )
			pos = s + 1
			count = count + 1
		else
			tinsert( splitTable, strsub( subject, pos ) )
			break
		end
	end
	return unpack(splitTable)
end

-- WOW's structures
SlashCmdList = {}
FACTION_BAR_COLORS = {
	[1] = {r = 1.0, g = 0, b = 0},                  -- 36000 Hated - Red
	[2] = {r = 1.0, g = 0.5019608, b = 0},          -- 3000 Hostile - Orange
	[3] = {r = 1.0, g = 0.8196079, b = 0},          -- 3000 Unfriendly - Yellow
	[4] = {r = 0.8, g = 0.9, b = 0.8},              -- 3000 Neutral - Grey
	[5] = {r = 1.0, g = 1.0, b = 1.0},              -- 6000 Friendly - White
	[6] = {r = 0, g = 0.6, b = 0.1},                -- 12000 Honored - Green
	[7] = {r = 0, g = 0, b = 1.0},                  -- 21000 Revered - Blue
	[8] = {r = 0.5803922, g = 0, b = 0.827451},     -- 1000 Exalted - Purple
}

-- WOW's constants
-- http://www.wowwiki.com/BagId
NUM_BAG_SLOTS=4
ATTACHMENTS_MAX_SEND=8
ITEM_SOULBOUND="Soulbound"
ITEM_BIND_ON_PICKUP="Binds when picked up"

-- WOW's frames
Frame = {
		["__isShown"] = true,
		["Events"] = {},
		["points"] = {},
		["Hide"] = function( self ) self.__isShown = false; end,
		["Show"] = function( self ) self.__isShown = true; end,
		["IsVisible"] = function( self ) return( self.__isShown ) end,
		["RegisterEvent"] = function(self, event) self.Events[event] = true; end,
		["SetPoint"] = function(self, ... ) table.insert( self.points, {...} ); end,
		["UnregisterEvent"] = function(self, event) self.Events[event] = nil; end,
		["GetName"] = function(self) return self.framename end,
		["SetFrameStrata"] = function() end,
		["width"] = 100,
		["height"] = 100,
		["SetWidth"] = function(self, value) self.width = value; end,
		["GetWidth"] = function(self) return( self.width ); end,
		["SetHeight"] = function(self, value) self.height = value; end,
		["GetHeight"] = function(self) return( self.height ); end,
		["SetMovable"] = function(self, value) self.movable = value end,
		["CreateFontString"] = function(self, ...) return(CreateFontString(...)) end,
		["CreateTexture"] = function(self, name, ...) return(CreateTexture(...)) end,
		["SetSize"] = function(self, x, y) self.width=x; self.height=y; end,
		["GetSize"] = function(self) return self.width,self.height end,
		["ClearAllPoints"] = function(self) self.points={}; end,
		["GetPoint"] = function(self) end,
		["GetNumPoints"] = function(self) end,
		["SetAllPoints"] = function(self) end,
		["StopMovingOrSizing"] = function(self) end,

		["SetMinMaxValues"] = function(self, min, max) self.min=min; self.max=max; end,
		["SetValue"] = function(self, value) self.value=value end,
		["GetValue"] = function(self) return self.value end,
		["SetStatusBarColor"] = function() end,
		["SetScript"] = function(self, event, func) end,
		["SetAttribute"] = function() end,

		["SetChecked"] = function() end,
		["SetText"] = function(self, textIn) self.textValue = textIn; end,
		["GetText"] = function(self) return( self.textValue ); end,
		["SetFrameLevel"] = function(self) end,
		["SetAlpha"] = function(self, value) end,
}
FrameGameTooltip = {
		["HookScript"] = function( self, callback ) end,
		["GetName"] = function(self) return self.name end,
		["GetUnit"] = function(self) return self.name end,
		["SetOwner"] = function(self, newOwner) end, -- this is only for tooltip frames...
		["ClearLines"] = function(self) end, -- this is only for tooltip frames...
		["SetHyperlink"] = function(self, hyperLink) end, -- this is only for tooltip frames...
		["AddLine"] = function(self, line) self.line = line end,
		["init"] = function(frameName)
			_G[frameName.."TextLeft2"] = CreateFontString(frameName.."TextLeft2")
			_G[frameName.."TextLeft3"] = CreateFontString(frameName.."TextLeft3")
			_G[frameName.."TextLeft4"] = CreateFontString(frameName.."TextLeft4")
		end,
}
        -- None = 0
        -- Warrior = 1
        -- Paladin = 2
        -- Hunter = 3
        -- Rogue = 4
        -- Priest = 5
        -- DeathKnight = 6
        -- Shaman = 7
        -- Mage = 8
        -- Warlock = 9
        -- Monk = 10
        -- Druid = 11
        -- Demon Hunter = 12
Units = {
	["player"] = {
		["class"] = "Warlock",
		["classCAPS"] = "WARLOCK",
		["classIndex"] = 9,
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "testPlayer",
		["race"] = "Human",
		["realm"] = "Test Realm",
		["realmRelationship"] = 1,  -- same realm
		["sex"] = 3,
		["currentHealth"] = 100000,
		["maxHealth"] = 123456,
	},
	["sameRealmUnit"] = {
		["class"] = "Warrior",
		["classCAPS"] = "WARRIOR",
		["classIndex"] = 1,
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "sameRealmPlayer",
		["race"] = "Gnome",
		["realm"] = "testPlayer",
		["realmRelationship"] = 1,
		["sex"] = 2,
	},
	["coalescedRealmUnit"] = {
		["class"] = "Monk",
		["classCAPS"] = "MONK",
		["classIndex"] = 10,
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "coalescedUnit",
		["race"] = "Pandarian",
		["realm"] = "coalescedRealm",
		["realmRelationship"] = 2,
	},
	["connectedRealmUnit"] = {
		["class"] = "Mage",
		["classCAPS"] = "MAGE",
		["classIndex"] = 8,
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "connectedUnit",
		["realm"] = "connectedRealm",
		["realmRelationship"] = 3,
	},
	["mouseover"] = {
		["class"] = "Priest",
		["classCAPS"] = "PRIEST",
		["classIndex"] = 99999,  -- find this out
		["faction"] = {"Alliance", "Alliance"},
		["name"] = "mousename",
		["race"] = "Dwarf",
		["realm"] = "mouserealm",
		["sex"] = 1,
	},

}
function CreateFrame( frameType, frameName, parentFrame, inheritFrame )
--	print("CreateFrame: needing a new frame of type: "..(frameType or "nil"))
	newFrame = {}
	for k,v in pairs( Frame ) do
		newFrame[k] = v
	end
	if frameType and _G["Frame"..frameType] then  -- construct the name of the table to pull from, use _G to reference it.
		for k, f in pairs(_G["Frame"..frameType]) do  -- add the methods in the sub frame to the returned frame
			if k == "init" then  -- check to see if the key is 'init', which is a function to run when creating the Frame
				f(frameName)  -- run the ["init"] function
			else
				newFrame[k] = f  -- add the method to the frame
			end
		end
	end
	frameName = newFrame
	--http://www.wowwiki.com/API_CreateFrame
	return newFrame
end
function CreateFontString( name, ... )
	--print("Creating new FontString: "..name)
	FontString = {}
	--	print("1")
	for k,v in pairs(Frame) do
		FontString[k] = v
	end
	FontString.text = ""
	FontString["SetText"] = function(self,text) self.text=text; end
	FontString["GetText"] = function(self) return(self.text); end
	FontString.name=name
	--print("FontString made?")
	return FontString
end
function CreateStatusBar( name, ... )
	StatusBar = {}
	for k,v in pairs(Frame) do
		StatusBar[k] = v
	end
	StatusBar.name=name
	return StatusBar
end
function CreateSlider( name, ... )
	Slider = {}
	for k,v in pairs(Frame) do
		Slider[k] = v
	end
	Slider.name=name
	Slider[name.."Text"] = CreateFontString(name.."Text")
	Slider.GetValue = function() return 2  end
	return Slider
end
CheckButton = {
		["SetChecked"] = function(self,value) self.isChecked=value; end,
}
function CreateCheckButton( name, ... )
	me = {}
	for k,v in pairs(CheckButton) do
		me[k] = v
	end
	me.name = name
	me[name.."Text"] = CreateFontString(name.."Text")
	return me
end
EditBox = {
		["SetText"] = function(self,text) self.text=text; end,
		["SetCursorPosition"] = function(self,pos) self.cursorPosition=pos; end,
		["HighlightText"] = function(self,start,last) end,
		["IsNumeric"] = function() end,
}
function CreateEditBox( name, ... )
	me = {}
	for k,v in pairs(EditBox) do
		me[k] = v
	end
	me.name = name
	return me
end
Button = {
	["enabled"] = true,
	["SetEnabled"] = function(self,enabled) self.enabled = enabled; end,
	["IsEnabled"] = function(self) return self.enabled; end,
}
function CreateButton( name, ... )
	me = {}
	for k,v in pairs(Button) do
		me[k] = v
	end
	me.name = name
	return me
end
Texture = {
	["SetTexture"] = function(self) end,
}
function CreateTexture( name, ... )
	me = {}
	for k,v in pairs(Frame) do
		me[k] = v
	end
	for k,v in pairs(Texture) do
		me[k] = v
	end
	me.name=name
	return me
end
function UIDropDownMenu_Initialize( self )
end
function UIDropDownMenu_JustifyText( self, justify )
end
function UIDropDownMenu_GetText( self )
	return ""
end
function ChatFrame_AddMessageEventFilter()
end

-- WOW's resources
DEFAULT_CHAT_FRAME={ ["AddMessage"] = function( self, msg )
		table.insert( chatLog,
			{ ["msg"] = msg, ["chatType"] = "DEFAULT_CHAT_FRAME", ["language"] = "", ["channel"] = "DEFAULT_CHAT_FRAME" }
		)
	end, }
UIErrorsFrame={ ["AddMessage"] = function( self, msg )
		table.insert( chatLog,
			{ ["msg"] = msg, ["chatType"] = "UIErrorsFrame", ["language"] = "", ["channel"] = "UIErrorsFrame" }
		)
	end, }
WeeklyRewardsFrame = CreateFrame()
BankFrame = CreateFrame()

-- stub some external API functions (try to keep alphabetical)
function BuyMerchantItem( index, quantity )
	-- adds quantity of index to myInventory
	-- no return value
	local itemID = MerchantInventory[index].id

	if myInventory[itemID] then
		myInventory[itemID] = myInventory[itemID] + quantity
	else
		myInventory[itemID] = quantity
	end
end
function CheckInbox()
	-- http://www.wowwiki.com/API_CheckInbox
	-- Fires the MAIL_INBOX_UPDATE event when data is available
	-- @TODO - Write this
end
function CheckInteractDistance( unit, distIndex )
	-- https://wowwiki.fandom.com/wiki/API_CheckInteractDistance
	-- unit - string: unit lookupstr
	-- distIndex - int: 1= inspect (28 yards), 2= Trade (11.11 yards), 3= Duel (9.9 yards), 4= Follow (28 yards)
	-- returns: bool (1nil)
	-- uses:  playerRange = {}  -- { ["party1"] = <yards> }
	-- leaving blank is the same as being out of range
	rangeIndex = { 28, 11.11, 9.9, 28 }
	distIndex = tonumber( distIndex )
	if( playerRange[unit] and rangeIndex[distIndex] ) then
		if( playerRange[unit] <= rangeIndex[distIndex] ) then
			return true
		end
	end
end
function ClearCursor()
	onCursor = {}
end
--[[
function ClearSendMail()
	-- http://www.wowwiki.com/API_ClearSendMail
	-- clears any text, items or money from the mail message to be sent
	-- @TODO - Write this
end
function ClickSendMailItemButton( slot, clearItem )
	-- http://www.wowwiki.com/API_ClickSendMailItemButton
	--
	-- @TODO - Write this
end
function CloseMail()
	-- http://www.wowwiki.com/API_CloseMail
	-- Fires the MAIL_CLOSED event
	-- returns: nil
	-- @TODO - Write this
end
]]
function InCombatLockdown()
	return false
end
function CombatLogGetCurrentEventInfo()
	-- return much the same info as used to be passed to the LOG_UNFILTERD event
	-- set CombatLogCurrentEventInfo = {} to return specific data.
	-- timestamp,event,hideCaster,srcGUID,srcName,srcFlags,srcFlags2,
	--		targetGUID,targetName,targetFlags,targetFlags2,spellId = CombatLogGetCurrentEventInfo()
	return unpack( CombatLogCurrentEventInfo )
end
function IterateCombatLog( file, text, realtime )
	-- Support function
	-- file: file to parse for data,
	-- text: text instead
	-- realtime: simulate delays between events based on recorded timestamp


end
function CombatTextSetActiveUnit( who )
	-- http://www.wowwiki.com/API_CombatTextSetActiveUnit
	-- @TODO - Write this
end
function CursorHasItem()
	-- http://www.wowwiki.com/API_CursorHasItem
	-- Returns: 1-nil  if cursor has an item
	if onCursor["item"] then
		return true
	end
end
function DoEmote( emote, target )
	table.insert( actionLog,
			"DoEmote( "..(emote or "nil")..", "..(target or "nil").." )"
	)
	-- not tested as the only side effect is the character doing an emote
end
function EquipItemByName( itemIn, slotIDIn )
	-- http://www.wowwiki.com/API_EquipItemByName
	-- item: string (itemID, itemName, or itemLink)
	-- slot: number (optional: where to place it)
	local itemID = __getItemID( itemIn )
	local slotID
	if tonumber(itemIn) then -- got the itemID
		itemID = itemIn
	elseif strmatch( itemIn, "item:(%d*)" ) then -- got an ItemString or ItemLink
		itemID = string.format("%s", strmatch( itemIn, "item:(%d*)" ) )
	else -- Anything else, treat it as an ItemName.
		for ID, data in pairs(Items) do
			if itemIn == data.name then
				itemID = ID
				break  -- break the loop once the item is found.
			end
		end
	end
	--print(itemID,type(itemID),(slotIDIn or "nil"))
	-- look for the item in inventory
	if myInventory[itemID] then -- is in inventory
		if Items[itemID] then -- is a valid item
			if Items[itemID].slotPrefix then -- item has a slot prefix (it can be equipped - to that slot)
				-- find valid slot ID, set slotID if slotIDIn is valid, or not set
				for i, slotName in pairs(SlotListMap) do
					if strmatch( slotName, Items[itemID].slotPrefix ) then -- valid possible slot
						if (not slotIDIn) or (slotIDIn and slotIDIn == i) then
							slotID = slotID or i
						end
					end
				end
			end
		else
			error("item:"..itemID.." is unknown. This should not the thrown by the client, but this is for testing.")
		end
		if slotID then
			local swapItem = myGear[slotID]
			myGear[slotID] = itemID
			if swapItem then myInventory[swapItem] = 1 end
			myInventory[itemID] = nil
		end
	end
end
function ExpandFactionHeader( index )
	-- http://wowprogramming.com/docs/api/ExpandFactionHeader
	if FactionInfo[index] then
		if FactionInfo[index].isHeader then
			FactionInfo[index].isCollapsed = false
		end
	end
end
function GetAccountExpansionLevel()
	-- http://www.wowwiki.com/API_GetAccountExpansionLevel
	-- returns 0 to 4 (5)
	return accountExpansionLevel
end
function GetAchievementCriteriaInfo( ID, criteriaNum )
	-- criteriaString, criteriaType, completed, quantity, reqQuantity,
	-- charName, flags, assetID, quantityString, criteriaID =
	-- GetAchievementCriteriaInfo(criteriaID or achievementID, criteriaNum);
	if criteriaNum then
		achievementID = ID
		if Achievements[achievementID] then
			achievementInfo = Achievements[achievementID]
			info = achievementInfo["criteria"][criteriaNum]
			return info.description, info.type, info.completed, info.quantity, info.reqQuantity, info.charName,
					info.flags, info.assetID, info.quantityString, info.criteriaID
		end
	end
end
--[[
function GetAchievementCriteriaInfoByID( criteriaID )
	-- criteriaString, criteriaType, completed, quantity, reqQuantity,
	-- charName, flags, assetID, quantityString, criteriaID, eligible =
	-- GetAchievementCriteriaInfoByID(achievementID, criteriaID)
	return "string","36",3,4,5,6,7
end
--]]
function GetAchievementInfo( id, index )
	-- http://wowprogramming.com/docs/api/GetAchievementInfo
	-- Arguments:
	-- id: achievement category ID or achievement ID
	-- index: index of achievement in given category ID
	-- Returns:
	-- id: The numeric ID of the achievement or statistic (number)
	-- name: Name of the achievement or statistic (string)
    -- points: Amount of achievement points awarded for completing the achievement (number)
	-- completed: True if any toon on the account has completed the achievement; otherwise false (boolean)
	-- month: Month in which the player completed the achievement (number)
	-- day: Day of the month on which the player completed the achievement (number)
	-- year: Year in which the player completed the achievement. (Two digit year, assumed to be 21st century.) (number)
	-- description: Description of the achievement (string)
	-- flags: Test against the following masks with bit.band() to reveal additional information: (bitfield)
	--		0x00000001 - Info is for a statistic, not an achievement
	--		0x00000002 - Achievement should be hidden in normal displays
	--		0x00000080 - Achievement should display its criteria as a progress bar regardless of per-criterion flags
	-- icon: Path to an icon texture for the achievement (string)
	-- rewardText: Text describing a reward for the achievement, or the empty string if no reward is offered (string)
	-- isGuildAch: True if the achievement is a Guild achievement; otherwise false (boolean)
	-- wasEarnedByMe: True if the achievement was earned by the player; otherwise false (boolean)
	-- earnedBy: Who earned the achivement, if not the player; otherwise nil (string)
	if index then
		category = id
		-- Find the id to actually work with
	end
	achiveInfo = Achievements[id]

	return id, achiveInfo['name'], achiveInfo['points'], achiveInfo['completed'], achiveInfo['month'], achiveInfo['day'], achiveInfo['year'],
		achiveInfo['description'], achiveInfo['flags'], achiveInfo['icon'], achiveInfo['rewardText'], achiveInfo['isGuildAch'],
		achiveInfo['wasEarnedByMe'], achiveInfo['earnedBy']
end
function GetAchievementNumCriteria( achievementID )
	-- numCriteria = GetAchievementNumCriteria(AchievementID)
	if Achievements[achievementID] then
		return #Achievements[achievementID]["criteria"]
	end
end
function GetBuildInfo()
	return table.unpack(buildInfo)
end
function GetCurrentRegion()
	-- @TODO: find region info
	return 1
end
function GetSpecialization()
	return 2
end
function GetStatistic( statID )
	-- https://wow.gamepedia.com/API_GetStatistic

	return Achievements[statID].value
end
function GetCombatRating( ratingEnum )
	return 2734
end
function GetComparisonStatistic( achievementID )
	-- https://wowwiki.fandom.com/wiki/API_GetComparisonStatistic
	-- achievementID: integer - ID of the achievement
	-- returns: string - the value of the requested statistic
	return Achievements[achievementID].value
end
function GetCategoryList()
	-- http://www.wowwiki.com/API_GetCategoryList
	-- Returns a table of achievement categories
	return {"10","47454"}
end
function GetCategoryNumAchievements( catID )
	-- http://wowprogramming.com/docs/api/GetCategoryNumAchievements
	-- http://wow.gamepedia.com/API_GetCategoryNumAchievements    <---  MUCH BETTER
	-- Arguments:
	-- catID: Category to return the number of displayable achievements
	-- includeAll: (optional) boolean include all achievements, or just visible (if false)
	-- Returns:
	-- numItems: Number of achievements or stats to display
	-- numCompleted: Number of completed achievements (or 0 for stats)
	-- numIncomplete: Number of incomplete achievements
	return 5,0,5
end

C_AddOns = {}
function C_AddOns.GetAddOnMetadata( addon, field )
	-- returns addonData[field] for 'addon'
	-- local addonData = { ["version"] = "1.0", }
	return addonData[field]
end
function C_AddOns.GetNumAddOns()
	return 1
end
function C_AddOns.LoadAddOn( addonName )
end
function C_AddOns.DisableAddOn( addonName, playerName )
end

C_Container = {}
C_Container.SortBagsRightToLeft = false -- this is normal
function C_Container.GetContainerItemID( bagId, slotId )
end
function C_Container.GetContainerItemInfo( bagId, slotId )
end
function C_Container.GetContainerItemLink( bagId, slotId )
end
function C_Container.GetBagSlotFlag( bagId, filterFlagCheck )
	-- returns true if the filterFlagCheck matches the bag's filterFlag
	return true
end
function C_Container.GetContainerNumFreeSlots( bagId )
	-- http://www.wowwiki.com/API_GetContainerNumFreeSlots
	-- http://www.wowwiki.com/BagType
	-- returns numberOfFreeSlots, BagType
	-- BagType should be 0
	-- TODO: For API, what should it return if no bag is equipped?  (it should not be nil it seems)
	-- ^^ Note, the backpack(0) is ALWAYS equipped.
	if bagInfo[bagId] then
		return unpack(bagInfo[bagId])
	else
		return 0, 0
	end
end
function C_Container.GetContainerNumSlots( bagId )
	-- http://wowwiki.wikia.com/wiki/API_GetContainerNumSlots
	-- returns the number of slots in the bag, or 0 if no bag
	if bagInfo[bagId] then
		return bagInfo[bagId][1]
	else
		return 0
	end
end
function C_Container.GetSortBagsRightToLeft()
	return C_Container.SortBagsRightToLeft
end
function C_Container.UseContainerItem( bagId, slotId )
end
function GetEquipmentSetItemIDs( setName )
	-- http://wowprogramming.com/docs/api/GetEquipmentSetItemIDs
	-- Returns a table of item IDs keyed by slotID of items in the equipmentSet
	for _, set in pairs(EquipmentSets) do
		if setName == set.name then
			return set.items
		end
	end
end
function GetEquipmentSetInfo( index )
	-- http://www.wowwiki.com/API_GetEquipmentSetInfo
	-- Returns: name, icon, lessIndex = GetEquipmentSetInfo(index)
	-- Returns: nill if no equipmentSet at that index
	-- lessIndex is index-1 ( not used )
	if EquipmentSets[index] then
		return EquipmentSets[index].name, EquipmentSets[index].icon, index-1
	end
end
function GetEquipmentSetInfoByName( nameIn )
	-- http://www.wowwiki.com/API_GetEquipmentSetInfo
	-- Returns: icon, lessIndex = GetEquipmentSetInfoByName
	for i = 1, #EquipmentSets do
		if EquipmentSets[i].name == nameIn then  -- Since EquipementSet names are case sensitve...
			return EquipmentSets[i].icon, i-1
		end
	end
end
function GetGuildInfo( unitID )
	-- http://wowprogramming.com/docs/api/GetGuildInfo
	-- Returns: guildName, guildRankName, guildRankIndex
	if myGuild and myGuild.name then
		return myGuild.name, "Rank Name", 2
	end
end
function GetHaste()
	return 15.42345
end
function GetInventoryItemID( unitID, invSlot )
	-- http://www.wowwiki.com/API_GetInventoryItemID
	-- unitID: string   (http://www.wowwiki.com/API_TYPE_UnitId)  (bossN 1-4, player, partyN 1-4, raidN 1-40)
	-- invSlot: number  (http://www.wowwiki.com/InventorySlotId)
	-- Returns: itemID of the item in that slot, or nil
	if unitID == "player" then
		return myGear[invSlot]
	end
end
function GetInventoryItemLink( unitID, slotID )
	-- http://www.wowwiki.com/API_GetInventoryItemLink
	-- unitID: string
	-- slotID: number
	-- Returns: itemLink or nil
	if unitID == "player" then
		if myGear[slotID] then -- has an item in the slot
			if Items[myGear[slotID]] then -- knows about the item ID
				return Items[myGear[slotID]].link
			end
		end
	end
end
function GetInventorySlotInfo( slotName )
	-- http://www.wowwiki.com/API_GetInventorySlotInfo
	-- Returns: slotID, textureName
	-- Return empty string for textureName for now.
	for k,v in pairs(SlotListMap) do
		if v == slotName then
			return k,""
		end
	end
end
function GetItemCount( itemID, includeBank, includeUses, includeReagentBank, includeAccountBank )
	-- print( itemID, myInventory[itemID] )
	return myInventory[itemID] or 0
end
function GetItemInfo( itemIn )
	-- itemID is number, link or 'item:#####'
	-- returns name, itemLink
	local itemID = __getItemID( itemIn )
	if Items[itemID] then
		return Items[itemID].name, Items[itemID].link
	end
end
function GetLocale()
	return myLocale
end
function GetMastery()
	return 21.3572
end
function GetMerchantItemCostInfo( index )
	-- returns count of alterate items needed to purchase an item
	if MerchantInventory[ index ] then  -- valid index
		if MerchantInventory[ index ].currencies then  -- has alternate currencies
			local count = 0
			for _ in pairs (MerchantInventory[ index ].currencies ) do count = count + 1 end
			return count
		end
	end
	return 0  -- returns 0 not nil on 0 currencies
end
function GetMerchantItemCostItem( index, currencyIndex )
	-- returns texture, value, and link for 1..GetMerchantItemCostInfo() for index item
	if MerchantInventory[ index ] then  -- valid index
		if MerchantInventory[ index ].currencies then  -- has alternate currencies
			if MerchantInventory[ index ].currencies[ currencyIndex ] then -- currencyIndex exists
				local currencyLink = ""
				if MerchantInventory[ index ].currencies[ currencyIndex ].type == "item" then
					currencyLink = Items[ MerchantInventory[ index ].currencies[ currencyIndex ].id ].link
				elseif MerchantInventory[ index ].currencies[ currencyIndex ].type == "currency" then
					currencyLink = Currencies[ MerchantInventory[ index ].currencies[ currencyIndex ].id ].link
				end
				return "", MerchantInventory[ index ].currencies[ currencyIndex ].quantity, currencyLink
			end
		end
	end
	return nil, nil, nil  -- probably don't need to do this.
end
function GetMerchantItemLink( index )
	-- returns a link for item at index
	if MerchantInventory[ index ] and Items[ MerchantInventory[ index ].id ] then
		return Items[ MerchantInventory[ index ].id ].link
	else
		return nil
	end
end
function GetMerchantItemInfo( index )
	--local itemName, texture, price, quantity, numAvailable, isUsable = GetMerchantItemInfo( i )
	if MerchantInventory[ index ] then
		local item = Items[ MerchantInventory[ index ].id ]
		return item.name, item.texture, MerchantInventory[ index ].cost, MerchantInventory[ index ].quantity, -1, MerchantInventory[ index ].isUsable
--		local item = MerchantInventory[ index ]
--		return item.name, "", item.cost, item.quantity, -1, item.isUsable
	end
end
function GetMerchantItemMaxStack( index )
	-- Max allowable amount per purchase.  Hard code to 20 for now
	return 20
end
function GetMerchantNumItems()
	local count = 0
	for _ in pairs(MerchantInventory) do count = count + 1 	end
	return count
end
function GetMoney()
	return myCopper
end
function GetNumArchaeologyRaces()
	return 1
--[[
/run print("Total artifacts"); for x=1,12 do local c=GetNumArtifactsByRace(x); local a =0;
for y=1,c do local t = select(9, GetArtifactInfoByRace(x, y)); a=a+t;end
local rn = GetArchaeologyRaceInfo(x); if( c > 1 ) then print(rn .. ": " .. a); end end


numRaces = GetNumArchaeologyRaces()

Returns:

    numRaces - The number of Archaeology races in the game (number)
]]
end
function GetArchaeologyRaceInfo( index )
--[[

raceName, raceTexture, raceItemID, numFragmentsCollected, numFragmentsRequired, maxFragments = GetArchaeologyRaceInfo(raceIndex)

Arguments:

    raceIndex - nil (number, GetNumArchaeologyRaces())

Returns:

    raceName - Name of the race (string)
    raceTexture - Path to the texture (icon) used by this race in the Archaeology UI (string)
    raceItemID - The itemID for the Keystone this race uses (number)
    numFragmentsCollected - Number of collected fragments for this race (number)
    numFragmentsRequired - Number of fragments required to solve the current artifact (number)
    maxFragments - Maximum number of fragments that can be carried (number)
]]
	return "Dwarf", "", 384, 0, 100, 200
end

-- 7, Mining
-- 8, Engineering
-- 10, arch
-- 9, Fishing
-- 6, Cooking
function GetProfessions()
	-- prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	return 5, 6, 7, 8, 9
end
ProfessionInfo = {
	[5] = { "Engineering", "icon", 75, 300, 3, 3, 3, 3, 3, 3, "Khaz Algar Engineering" },
	[6] = { "prof2", "icon", 75, 300, 3, 3, 3, 3, 3, 3, "Catacylism prof2" },
	[7] = { "Archaeology", "icon", 75, 300, 3, 3, 3, 3, 3, 3, "Catacylism Arch" },
	[8] = { "Fishing", "icon", 75, 300, 3, 3, 3, 3, 3, 3, "Catacylism Fishing" },
	[9] = { "Cooking", "icon", 75, 300, 3, 3, 3, 3, 3, 3, "Catacylism Cooking" },
}
function GetProfessionInfo( index )
	--[[
	name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset,
    skillLine, skillModifier, specializationIndex,
    specializationOffset = GetProfessionInfo(index)
	]]
	return unpack( ProfessionInfo[index] )
end
function GetNumEquipmentSets()
	-- http://www.wowwiki.com/API_GetNumEquipmentSets
	-- Returns 0,MAX_NUM_EQUIPMENT_SETS
	return #EquipmentSets
end
function GetRepairAllCost()
	-- Returns cost to repair all, and if can repair
	return 5000, true  -- 50s and yes
end
function GetNumFactions()
	-- returns number of factions
	-- I believe that this should return the correct number that are SHOWN.
	-- It should then process the info the describes if it is collapsed or not.
	local count = 0
	for _ in pairs(FactionInfo) do count = count + 1 end
	return count
end
function GetNumGroupMembers()
	-- http://www.wowwiki.com/API_GetNumGroupMembers
	-- Returns number of people (include self) in raid or party, 0 if not in raid / party
	if myParty.raid then
		return #myParty.roster
	else
		return #myParty.roster
	end
	return 0
end
function GetNumRoutes( nodeId )
	-- http://wowprogramming.com/docs/api/GetNumRoutes
	-- returns numHops
	return TaxiNodes[nodeId].hops
end
mySavedInstances = {}
-- mySavedInstances = { { "raidName", id, secondsUntilLockResets, difficulty(number),
--      isLocked(bool), isExtended(bool), instanceIDMostSig?(number), isRaid(bool),
--      maxPlayers(number), "difficulty", numEncounters(number), encounterProgress(number),
--      {{bossName, fileDataID, isKilled, unknown}, {}, ...} }, {}, ... }
function GetNumSavedInstances()
	-- https://addonstudio.org/wiki/WoW:API_GetNumSavedInstances
	--     numInstances (Number) - number of instances saved to, zero if none
	-- See GetSavedInstanceInfo
	return #mySavedInstances
end
function GetSavedInstanceInfo( index )
	-- https://addonstudio.org/wiki/WoW:API_GetSavedInstanceInfo
	-- name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(index)
	-- add the above info as a table to mySavedInstances
	return table.unpack( mySavedInstances[index] )
end
function GetSavedInstanceEncounterInfo( raidIndex, bossIndex )
	return table.unpack( mySavedInstances[raidIndex][13][bossIndex] )
end
-- GetNumTradeSkills is deprecated
--function GetNumTradeSkills( )
--	-- returns number of lines in the tradeskill window to show
--	local count = 0
--	for _ in pairs( TradeSkillItems ) do count = count + 1 end
--	return count
--end
function GetPlayerInfoByGUID( playerGUID )
	-- http://wowprogramming.com/docs/api/GetPlayerInfoByGUID
	-- localClass, englishClass, localRace, englishRace, gender, name, realm = GetPlayerInfoByGUID( playerGUID )
	-- @TODO: Affirm this
	return "Warlock", "Warlock", "Human", "Human", 3, "testPlayer", "Test Realm"
end
function GetQuestResetTime()
	-- @TODO: Find out more about this
	return 5
end
function GetRaidRosterInfo( raidIndex )
	-- http://www.wowwiki.com/API_GetRaidRosterInfo
	-- returns name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML
	if (myParty.raid or myParty.party) and myParty.roster then
		return unpack(myParty.roster[raidIndex]) -- unpack returns the array as seperate values
	end
end
function GetRealmName()
	return "Test Realm"
end
function GetNormalizedRealmName()
	return "TestRealm"
end
function GetSendMailItem( slot )
	-- 1 <= slot <= ATTACHMENTS_MAX_SEND
	-- returns: itemName, itemTexture, stackCount, quality
end
function GetSendMailItemLink( slot )
	-- 1 <= slot <= ATTACHMENTS_MAX_SEND
	-- returns: itemlink
end
function GetSendMailMoney()
	-- returns: amount (in copper)
end
function GetSendMailPrice()
	-- returns: amount (in copper) to send the mail
end
function GetStatistic( index )
	return myStatistics[index]
end
function GetTradeSkillItemLink( index )
	if TradeSkillItems[index] then
		return TradeSkillItems[index].ilink
	end
end
function GetTradeSkillReagentInfo( skillIndex, reagentIndex )
	-- reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(tradeSkillRecipeId, reagentId)
	if TradeSkillItems[skillIndex] and TradeSkillItems[skillIndex].reagents[reagentIndex] then
		local item = Items[ TradeSkillItems[ skillIndex ].reagents[ reagentIndex ].id ]
		if item then
			return item.name, -- reagentName
					item.texture,  --reagentTexture
					TradeSkillItems[skillIndex].reagents[reagentIndex].count, -- reagentCount
					myInventory[TradeSkillItems[skillIndex].reagents[reagentIndex].id] or nil -- playerReagentCount
		end
	end
end
function GetTradeSkillReagentItemLink( skillIndex, reagentIndex )
	-- link = GetTradeSkillReagentItemLink(skillId, reagentId)
	-- skillId = TradeSkillIndex
	-- reagentId = ReagentIndex
	-- returns LINK or NIL (?)
	if TradeSkillItems[skillIndex] then
		if TradeSkillItems[skillIndex].reagents[reagentIndex] then
			return Items[ TradeSkillItems[skillIndex].reagents[reagentIndex].id ].link
		end
	end
end
function GetTradeSkillNumMade( index )
	-- returns minMade, maxMade of the target item
	return TradeSkillItems[index].minMade, TradeSkillItems[index].maxMade
end
function GetTradeSkillNumReagents( index )
	return TradeSkillItems[index].numReagents
end
function GetTradeSkillRecipeLink( index )
	return TradeSkillItems[index].elink
end
function GetUnitName( lookupStr )
	error("This is deprecated")
end
function GetUnitSpeed( lookupStr )
	lookupStr = string.lower( lookupStr )

	return (unitSpeeds[lookupStr])
end
--[[
function HasNewMail()
	-- @TODO: Research this
	return true
end
]]
function GetWeeklyQuestResetTime()
	-- @TODO: Research this
	return 15
end
function GetXPExhaustion()
	-- TODO:
	return 3618
end
function GetZoneText()
	return myZone.Zone
end
function GetSubZoneText()
	return myZone.Sub
end
function InterfaceOptionsFrame_OpenToCategory()
end
function IsInGroup( groupType )
	-- http://wowprogramming.com/docs/api/IsInGroup
	-- LE_PARTY_CATEGORY_INSTANCE = 2  -- from /dump in client
	groupType = groupType or 1
	local groupTypes = { [1] = "party", [2] = "instance" }
	key = groupTypes[groupType]

	--print( "IsInGroup( "..(groupType or "NIL" ).." ) -->"..(key or "NIL") )
	return( myParty[key] and 1 or nil )
end
function IsInGuild()
	-- http://www.wowwiki.com/API_IsInGuild
	-- 1, nil boolean return of being in guild
	return (myGuild and myGuild.name) and 1 or nil
end
function IsInInstance()
	-- https://wowwiki.fandom.com/wiki/API_IsInInstance
	-- returns bool, string( arena | none | party | pvp | raid 		)
	-- set myParty.string = true.  Only one should be set.
	for partyType, _ in pairs( myParty ) do
		if partyType ~= "roster" then -- "roster" is special.  Should probably move this someplace else....
			return true, partyType
		end
	end
	-- returns nil if not in instance
end
function IsInRaid()
	-- http://www.wowwiki.com/API_IsInRaid
	-- 1, nill boolean return of being in raid
	-- myParty = { ["group"] = nil, ["raid"] = nil } -- set one of these to true to reflect being in group or raid.
	return ( myParty["raid"] and 1 or nil )
end
function IsFlying()
end
function IsMounted()
end
function IsShiftKeyDown()
end
function GetCritChance()
	return 25.42345
end
function GetCursorInfo()
end
function GetInstanceInfo()
	-- https://wowwiki.fandom.com/wiki/API_GetInstanceInfo
	-- name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapId, lfgID = GetInstanceInfo()
	-- name is localized!
	-- instanceMapId -- should probably be used for lookup.
	-- @TODO refine these....
	return "Deadmines", 1, 34, "", 5, 1, 0, 36, 0
end
function GetDifficultyInfo( diffInt )
	return dungeonDifficultyLookup[diffInt]
end
function GetFramerate()
	return 8
end
function IsResting()
	return true
end
function NumTaxiNodes()
	-- http://www.wowwiki.com/API_NumTaxiNodes
	local count = 0
	for _ in pairs(TaxiNodes) do
		count = count + 1
	end
	return count
end
function __getItemID( itemIn )
	local itemID
	if tonumber(itemIn) then -- got the itemID
		itemID = itemIn
	elseif strmatch( itemIn, "item:(%d*)" ) then -- got an ItemString or ItemLink
		itemID = string.format("%s", strmatch( itemIn, "item:(%d*)" ) )
	else -- Anything else, treat it as an ItemName.
		for ID, data in pairs(Items) do
			if itemIn == data.name then
				itemID = ID
				break -- break the loop once the item is found.
			end
		end
	end
	return itemID
end
function PickupItem( itemIn )
	-- http://www.wowwiki.com/API_PickupItem
	-- itemString is:
	--   ItemID (Numeric value)
	--   ItemString (item:#######)
	--   ItemName ("Hearthstone")
	--   ItemLink (Full link text as if Shift-Clicking Item)
	-- Should only pick up an item that you know about. (in bags for now (myInventory) )
	-- -- Note: Does not pick up an item from equipped inventory
	-- Not sure what this should do if there is already something on the cursor
	itemID = __getItemID( itemIn )
	onCursor={}
	if myInventory[itemID] then
		onCursor['item'] = itemID
		onCursor['quantity'] = myInventory[itemID]	-- pickup the quantity of the item in the inventory
		onCursor['from'] = "myInventory"
	end
end
function PickupInventoryItem( slotID )
	-- http://www.wowwiki.com/API_PickupInventoryItem
	-- If the cursor is empty, then it will attempt to pick up the item in the slotId.
    -- If the cursor has an item, then it will attempt to equip the item to the slotId and place the previous slotId item (if any) where the item on cursor orginated.
    -- If the cursor is in repair or spell-casting mode, it will attempt the action on the slotId.
	if myGear[slotID] then -- There is an item in this slot.
		onCursor['item'] = myGear[slotID]
		onCursor['quantity'] = 1
		onCursor['from'] = 'myGear'
		onCursor['fromSlot'] = slotID
	end
end
function PlaySound( sound, channel )
	-- http://wowwiki.wikia.com/wiki/API_PlaySound
end
function PlaySoundFile( file )
	-- does nothing except play a sound.  Do not test.
end
function PutItemInBackpack()
	-- http://www.wowwiki.com/API_PutItemInBackpack
	-- no argument, no return
	-- This puts the item in the Backpack and clears the cursor
	-- Really, it does not really put it in any bag, just clears the cursor, or removes it from inventory
	-- Removes item from source
	if onCursor["item"] then -- Cursor has an item
		myInventory[onCursor['item']] = onCursor['quantity']
		if (onCursor["from"] == "myGear" and onCursor['fromSlot']) then  -- Came from equipped items
			myGear[onCursor['fromSlot']] = nil  -- Remove it from Gear
		end
	end
	onCursor = {}
end
function PutItemInBag( bagNum )
	-- http://www.wowwiki.com/API_PutItemInBag
	-- bagNum, numberic (20 right most - 23 left most)
	-- Really, it does not really put it in any bag, just clears the cursor, or removes it from inventory
	if onCursor["item"] then
		myInventory[onCursor['item']] = onCursor['quantity']
		if (onCursor["from"] == "myGear" and onCursor['fromSlot']) then
			myGear[onCursor['fromSlot']] = nil -- Remove it from Gear
		end
	end
	onCursor = {}
end
function RegisterAddonMessagePrefix( prefix )
	-- http://wowprogramming.com/docs/api/RegisterAddonMessagePrefix
	-- returns success (512 limit)
	-- prefix can be up to 16 characters
	-- Cannot be empty.
	-- What does this do?  In a bigger system, it could allow random messages to be generated
end
function RepairAllItems( useGuild )
	-- performs rapir, uses guild money if useGuild is true
end
function RequestTimePlayed()
end
function Screenshot( )
end
function SecondsToTime( secondsIn, noSeconds, notAbbreviated, maxCount )
	-- http://www.wowwiki.com/API_SecondsToTime
	-- formats seconds to a readable time  -- WoW omits seconds if 0 even if noSeconds is false
	-- secondsIn: number of seconds to work with
	-- noSeconds: True to ommit seconds display (optional - default: false)
	-- notAbbreviated: True to use full unit text, short text otherwise (optional - default: false)
	-- maxCount: Maximum number of terms to return (optional - default: 2)
	maxCount = maxCount or 2
	local days, hours, minutes, seconds = 0
	local outArray = {}
	days = math.floor( secondsIn / 86400 )
	secondsIn = secondsIn - (days * 86400)

	hours = math.floor( secondsIn / 3600 )
	secondsIn = secondsIn - (hours * 3600)

	minutes = math.floor( secondsIn / 60 )
	seconds = secondsIn - (minutes * 60)

	-- format output
	local includeZero = false
	formats = { { "%i Day", "%i Day", days},
			{ "%i Hr", "%i Hours", hours},
			{ "%i Min", "%i Minutes", minutes},
			{ "%i Sec", "%i Seconds", seconds},
		}
	if noSeconds or seconds == 0 then  -- remove the seconds format if no seconds
		table.remove(formats, 4)
	end

	for i = 1,#formats do
		if (#outArray < maxCount) and (((formats[i][3] > 0) or includeZero)) then
			table.insert( outArray,
					string.format( formats[i][(notAbbreviated and 2 or 1)], formats[i][3] )
			)
			includeZero = true  -- include subsequent 0 values
		end
	end
	return( table.concat( outArray, " " ) )
end
function SendAddonMessage( prefix, text, type, target )
	-- http://wowwiki.wikia.com/wiki/API_SendAddonMessage
	-- Fires CHAT_MSG_ADDON event
		-- Sends these args with the event:
		-- Arg1: prefix
		-- Arg2: message
		-- Arg3: distribution
		-- Arg4: sender
		-- Need to register the addon prefix with RegisterAddonMessagePrefix
	-- type is in "PARTY", "RAID", "GUILD", "OFFICER", "BATTLEGROUND", "WHISPER"
	-- length of prefix and text cannot exceed 254 characters.
	-- \t cannot be used in the prefix
	-- all characters 1-255 can be used (no NULL)
end
function SendChatMessage( msg, chatType, language, channel )
	-- http://www.wowwiki.com/API_SendChatMessage
	-- This could simulate sending text to the channel, in the language, and raise the correct event.
	-- returns nil
	-- append the parameters to chatLog
	-- @TODO: Expand this

	table.insert( chatLog,
			{ ["msg"] = msg, ["chatType"] = chatType, ["language"] = language, ["channel"] = channel }
	)

	--print( string.format( "%s: %s", chatType, msg ) )
end
function SetAchievementComparisonUnit( lookupStr )
	-- mostly does nothing...  Just allows INSPECT_ACHIEVEMENT_READY to happen,
	-- and data to be gathered with:
	-- GetComparisonStatistic( statisticID ) and GetAchievementInfo( statisticID )
end
function ClearAchievementComparisonUnit()
	-- mostly does nothing...
end
function SetRaidTarget( target, iconID )
	-- sets the raid icon ID on target
end
function BNSendWhisper( id, msg )
	table.insert( chatLog,
			{ ["msg"] = msg, ["chatType"] = "BNWhisper", ["language"] = "", ["channel"] = "BNWhisper" }
	)
end
function TaxiNodeCost( nodeId )
	-- http://www.wowwiki.com/API_TaxiNodeCost
	return TaxiNodes[nodeId].cost
end
function TaxiNodeName( nodeId )
	-- http://www.wowwiki.com/API_TaxiNodeName
	return TaxiNodes[nodeId].name
end
function TaxiNodeGetType( nodeId )
	-- http://www.wowwiki.com/API_TaxiNodeGetType
	return TaxiNodes[nodeId].type
end
function setUnitOnTaxi( valueIn )
	settings.unitOnTaxi = valueIn
end
function UnitOnTaxi()
	return settings.unitOnTaxi or false
end
function UnitAffectingCombat( unit )
	return false
end
C_UnitAuras = {}
function C_UnitAuras.GetAuraDataByIndex( unit, index )
	-- @TODO: Look this up to get a better idea of what this function does.
	-- Returns an auraData table
	if( UnitAuras[unit] and UnitAuras[unit][index] ) then
		return UnitAuras[unit][index]
	end
end
function UnitClass( who )
	return Units[who].class, Units[who].classCAPS, Units[who].classIndex
end
function UnitExists( who )
	return Units[who] and true or nil
end
function UnitGUID( who )
	return "playerGUID"
end
function UnitGroupRolesAssigned( who )
	print( "UnitGroupRolesAssigned( "..who.." )")
	return Units[who].role
end
function UnitHealthMax( who )
	-- http://wowwiki.wikia.com/wiki/API_UnitHealth
	return Units[who].maxHealth
end
function UnitFactionGroup( who )
	-- http://www.wowwiki.com/API_UnitFactionGroup
	return unpack( Units[who].faction )
end
function UnitIsBattlePet( who )
	return Units[who].isBattlePet
end
function UnitIsDeadOrGhost( who )
end
function UnitIsPVP( who )
end
function UnitLevel( who )
	local unitLevels = {
		["player"] = 60,
	}
	return unitLevels[who]
end
function UnitName( who )
	return Units[who].name, Units[who].realm
end
function UnitPowerMax( who, powerType )
	-- http://wowwiki.wikia.com/wiki/API_UnitPowerMax
	-- VERY simplified version of this function for now.
	return 12345
end
function UnitRace( who )
	return Units[who].race
end
function UnitRealmRelationship( who )
	-- https://wow.gamepedia.com/API_UnitRealmRelationship
	-- returns
	-- 1 = same realm
	-- 2 = coalesced and unconnected realms
	-- 3 = connected realms
	return Units[who].realmRelationship
end
function UnitSex( who )
	-- 1 = unknown, 2 = Male, 3 = Female
	return Units[who].sex
end
function UnitStat( unitID, statID )
	stats = { 15, 20, 25, 30 } -- str, agil, stam, int
	return stats[statID], stats[statID], 0, 0
end
function UnitXP( who )
	return 100
end
function UnitXPMax( who )
	return 1000
end
---------  C_WowTokenPublic
C_WowTokenPublic = {}
function C_WowTokenPublic.GetCommerceSystemStatus()
	-- returns
	-- [1] boolean - unsure
	-- [2] seconds - minseconds between scans
	-- [3] 0?
	return true, 300, 0
end
function C_WowTokenPublic.GetCurrentMarketPrice()
	-- returns the value, and a 2nd number (unknown)
	return TokenPrice, 5
end
function C_WowTokenPublic.UpdateMarketPrice()
	-- this has the system query the market price, and fire the TOKEN_MARKET_PRICE_UPDATED event
	-- has no other side effects
end
----------
C_TradeSkillUI = {}
function C_TradeSkillUI.GetAllRecipeIDs()
	-- returns an array of RecipeIDs
	return {}
end
function C_TradeSkillUI.GetAllRecipeLink(recipeID)
end
function C_TradeSkillUI.GetChildProfessionInfos()
	-- https://warcraft.wiki.gg/wiki/API_C_TradeSkillUI.GetChildProfessionInfo
	return {
		{	["profession"] = 8,
			["professionID"] = 2875,
			["professionName"] = "Khaz Algar Engineering",
		},
	}
end
function C_TradeSkillUI.GetConcentrationCurrencyID( professionID )
	local stuff = {
		[2875] = 3044
	}
	return stuff[professionID]
end
function C_TradeSkillUI.GetRecipeInfo(recipeID)
	--disabled : boolean
	--type : string
	--hiddenUnlessLearned : boolean
	--icon : number
	--craftable : boolean
	--numSkillUps : number
	--recipeID : number
	--sourceType : number
	--numIndents : number
	--difficulty : string
	--name : string
	--numAvailable : string
	--learned : boolean
	--favorite : boolean
	--categoryID : number
end
function C_TradeSkillUI.GetRecipeTools( recipeID )
	--ordered
	--name : string
	--has : boolean
end
----------
C_EquipmentSet = {}
function C_EquipmentSet.GetNumEquipmentSets()
	-- http://www.wowwiki.com/API_GetNumEquipmentSets
	-- Returns 0,MAX_NUM_EQUIPMENT_SETS
	return #EquipmentSets
end
function C_EquipmentSet.GetEquipmentSetInfo( index )
	-- http://www.wowwiki.com/API_GetEquipmentSetInfo
	-- Returns: name, icon, lessIndex = GetEquipmentSetInfo(index)
	-- Returns: nill if no equipmentSet at that index
	-- lessIndex is index-1 ( not used )
	if EquipmentSets[index] then
		return EquipmentSets[index].name, EquipmentSets[index].icon, index-1
	end
end
function C_EquipmentSet.GetItemIDs( index )
	-- http://wowprogramming.com/docs/api/GetEquipmentSetItemIDs
	-- Returns a table of item IDs keyed by slotID of items in the equipmentSet
	if EquipmentSets[index] then
		return EquipmentSets[index].items
	end
end
function C_EquipmentSet.GetIgnoredSlots( setNum )
	-- Returns an array of true or false for each item slot (1-19)
	-- True is ignored, false is not
	return {}
end
function GetEquipmentSetInfoByName( nameIn )
	-- http://www.wowwiki.com/API_GetEquipmentSetInfo
	-- Returns: icon, lessIndex = GetEquipmentSetInfoByName
	for i = 1, #EquipmentSets do
		if EquipmentSets[i].name == nameIn then  -- Since EquipementSet names are case sensitve...
			return EquipmentSets[i].icon, i-1
		end
	end
end
function CanMerchantRepair()
	return true
end
function CanGuildBankRepair()
	return true
end

--http://wow.gamepedia.com/Patch_7.0.3/API_changes

--/script for k,v in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do print(k..":"..v) end
--/script for k,v in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do print(k..":"..v) end

----------

----------
C_AuctionHouse = {}
function C_AuctionHouse.PostItem( item, duration, quantity, bid, buyout )
end
function C_AuctionHouse.PostCommodity( item, duration, quantity, price )
end


function IsQuestFlaggedCompleted( questID )
	return nil
end
-- C_MountJournal
C_MountJournal = {}
C_MountJournal.critters = { ["mount"] = {}, ["critter"] = {} }

function C_MountJournal.GetMountIDs( )
	return {}
end

----------
-- C_CurrencyInfo
----------
C_CurrencyInfo = {}
function C_CurrencyInfo.GetCoinTextureString( copperIn, fontHeight )
-- simulates the Wow function:  http://www.wowwiki.com/API_GetCoinTextureString
-- fontHeight is ignored for now.
	if copperIn then
		-- cannot return exactly what WoW does, but can make a simular string
		local gold = math.floor(copperIn / 10000); copperIn = copperIn - (gold * 10000)
		local silver = math.floor(copperIn / 100); copperIn = copperIn - (silver * 100)
		local copper = copperIn
		return( (gold and gold.."G ")..
				(silver and silver.."S ")..
				(copper and copper.."C"))
	end
end
function C_CurrencyInfo.GetCurrencyInfo( id ) -- id is integet
	-- returns a table:
	-- 		localName, isHeader, isHeaderExpanded, isTypeUnused, isShowInBackpack, quantity, iconFileID, maxQuantity,
	--      canEarnPerWeek, quantityEarnedThisWeek, isTradeable, quality, maxWeeklyQuantity, discovered
	local ci = Currencies[id]
	if ci then
		return { ["localName"]=ci.name, ["isHeader"]=false, ["isHeaderExpanded"]=false, ["isTypeUnused"]=false,
				["isShowInBackpack"]=false, ["quantity"]=(myCurrencies[id] or 0), ["discovered"] = ci.isDiscovered,
				["canEarnPerWeek"]=ci.weeklyMax, ["maxQuantity"]=ci.totalMax, ["quantityEarnedThisWeek"]=0 }
				-- @TODO: fix the quantityEarnedThisWeek to come from myCurrencies
	end
end
function C_CurrencyInfo.GetCurrencyLink( id )
	if Currencies[id] then
		return Currencies[id].link
	end
end

----------
-- C_Bank
----------
C_Bank = {}
function C_Bank.FetchDepositedMoney( accountTypeEnum )
	return 8376
end
function C_Bank.CanDepositMoney()
	return true
end

Enum = {}
Enum.TooltipDataType = {}
Enum.TooltipDataType.Item = 0
Enum.BankType = {["Account"] = 2}

TooltipDataProcessor = {}
function TooltipDataProcessor.AddTooltipPostCall()
end

----------
-- Macros
----------
myMacros = {
	["general"] = {},  -- [1] = { ["name"] = "", ["icon"] = "", ["text"] = "" }   1-120 = general
	["personal"] = {}, -- 1-18 = personal (+120)
	["sort"] = function()
		table.sort( myMacros.general, function( l, r ) return( l.name < r.name ); end )
		table.sort( myMacros.personal, function( l, r ) return( l.name < r.name ); end )
	end,
}
function GetNumMacros()
	-- return number of global, number of personal
	return #myMacros.general, #myMacros.personal
end
function GetMacroInfo( macroName )
	-- returns:  macroName, macroIcon, macroText
	if macroName then
		local mIndex = tonumber(macroName) or GetMacroIndexByName( macroName )
		if mIndex ~= 0 then
			local location = mIndex > 120 and "personal" or "general"
			mIndex = mIndex>120 and mIndex-120 or mIndex
			if myMacros[location][mIndex] then
				return myMacros[location][mIndex].name, myMacros[location][mIndex].icon, myMacros[location][mIndex].text
			end
		end
	end
end
function GetMacroIndexByName( macroName )
	-- returns index, or 0 if not found (seems to go from highest to lowest - person to general )
	for index = 18, 1, -1 do
		if myMacros.personal[index] and myMacros.personal[index].name == macroName then
			return index+120
		end
	end
	for index = 120, 1, -1 do
		if myMacros.general[index] and myMacros.general[index].name == macroName then
			return index
		end
	end
	return 0
end
function CreateMacro( macroName, macroIcon, macroText, perChar )
	-- returns: macroID
	if macroName then
		local mIndex = GetMacroIndexByName( macroName )
		if mIndex == 0 then
			local location = perChar and "personal" or "general"
			table.insert( myMacros[location], { ["name"] = macroName, ["icon"] = macroIcon, ["text"] = macroText } )
			myMacros.sort()
			return( GetMacroIndexByName( macroName ) )  -- return the ID
		end
	end
end
function EditMacro( macroName, newName, newIcon, body )
	-- macroName is name or index
	-- returns: new macroID
	if macroName then
		mIndex = tonumber(macroName) or GetMacroIndexByName( macroName )
		if mIndex ~= 0 then
			local location = mIndex > 120 and "personal" or "general"
			mIndex = mIndex>120 and mIndex-120 or mIndex
			myMacros[location][mIndex].name = newName or myMacros[location][mIndex].name
			myMacros[location][mIndex].icon = newIcon or myMacros[location][mIndex].icon
			myMacros[location][mIndex].text = body or myMacros[location][mIndex].text
			myMacros.sort()
			return( GetMacroIndexByName( macroName ) )  -- return the ID
		end
	end
end

--------
-- C_ChatInfo
--------
C_ChatInfo = {}
function C_ChatInfo.IsAddonMessagePrefixRegistered( prefix )
	return true
end
function C_ChatInfo.RegisterAddonMessagePrefix( prefix )
end
function C_ChatInfo.SendAddonMessage()
	return true
end

----------
-- Toy info
----------
toyList = {}   -- [id] = {true | false}
C_ToyBox = {}
function PlayerHasToy( id )
	return toyList[id]
end
function C_ToyBox.IsToyUsable( id )
	return toyList[id] and toyList[id][1]
end
function C_ToyBox.PickupToyBoxItem( itemIn )
	-- http://www.wowwiki.com/API_PickupItem
	-- itemString is:
	--   ItemID (Numeric value)
	--   ItemString (item:#######)
	--   ItemName ("Hearthstone")
	--   ItemLink (Full link text as if Shift-Clicking Item)
	-- Should only pick up an item that you know about. (in bags for now (myInventory) )
	-- -- Note: Does not pick up an item from equipped inventory
	-- Not sure what this should do if there is already something on the cursor
	onCursor={}
	onCursor['item'] = itemID
end

----------
-- Settings
----------
Settings = {}
function Settings.OpenToCategory( id )
end
function Settings.RegisterCanvasLayoutCategory( frame, name )
	-- return a category structure
	return ( {["GetID"] = function() return 234; end} )
end
function Settings.RegisterAddOnCategory(category)
end

----------
-- C_Reputation
----------
C_Reputation = {}
function C_Reputation.GetFactionDataByID( idIn )
	for _, factionData in pairs( FactionInfo ) do
		if factionData.factionID == idIn then
			return factionData
		end
	end
end
function C_Reputation.GetFactionParagonInfo()
end

----------
-- C_GossipInfo
----------
C_GossipInfo = {}
function C_GossipInfo.GetFriendshipReputation( idIn )
	return {["maxRep"]=0, ["text"]="", ["reversedColor"]=false, ["reaction"]="", ["standing"]=0, ["reactionThreshold"]=0, ["friendshipFactionID"]=0, ["textrue"]=0}
end

----------
-- C_Item
----------
C_Item = {}
C_Item.GetItemCount = GetItemCount

----------
-- Menu
----------
Menu = {}
function Menu.ModifyMenu( ... )
end

----------
-- C_Timer
----------
C_Timer = {}
function C_Timer.After( seconds, callback )
	-- just call the callback
	callback()
end

----------
-- C_QuestLog
----------
C_QuestLog = {}
function C_QuestLog.IsQuestFlaggedCompleted( qnum )
	return ( qnum % 2 == 0 and true or false )
end
function C_QuestLog.GetTitleForQuestID( qnum )
	return "Test Quest"
end

----------
-- C_TaskQuest
----------
C_TaskQuest = {}
function C_TaskQuest.GetQuestInfoByQuestID( qnum )
end

----------
-- C_ClassTalents
----------
C_ClassTalents = {}
function C_ClassTalents.GetActiveConfigID()
end

----------
-- C_Traits
----------
C_Traits = {}
function C_Traits.GetConfigInfo( id )
	return {["ID"] = 13659962, ["name"] = "Holy", ["treeIDs"] = {790}, ["type"] = 1, ["usesSharedActionBars"] = false}
end
function C_Traits.GenerateImportString( configID )
	return "someReallyLongString"
end

----------
-- PlayerUtil
----------
PlayerUtil = {}
function PlayerUtil.GetCurrentSpecID()
	return {65, "Holy", "Desc", 135920, "HEALER", 4}
end

----------
-- C_PlayerInfo
----------
C_PlayerInfo = {}
function C_PlayerInfo.GetPlayerMythicPlusRatingSummary( unitStr )
	return {["runs"] = {}, ["currentSeasonScore"] = 0 }
end

----------
-- C_DateAndTime
----------
C_DateAndTime = {}
-- These functions return a non-lua-normal struct.
-- year 	number 	The current year (e.g. 2019)
-- month 	number 	The current month [1-12]
-- monthDay 	number 	The current day of the month [1-31]
-- weekday 	number 	The current day of the week (1=Sunday, 2=Monday, ..., 7=Saturday)
-- hour 	number 	The current time in hours [0-23]
-- minute 	number 	The current time in minutes [0-59]
C_DateAndTimeTS = time()  -- set this to control what is returned
function C_DateAndTime.GetCurrentCalendarTime()
	-- This is the realm's current time
	local out = date( "*t", C_DateAndTimeTS )
	out.monthDay = out.day; out.day = nil
	out.weekday = out.wday; out.wday = nil
	out.yday = nil
	out.isdst = nil
	out.sec = nil
	return out
end

-------
-- EventRegistry
-------
EventRegistry = {}
function EventRegistry.RegisterCallback( self )
end

----------
-- Settings
----------
Settings = {}
function Settings.OpenToCategory( id )
end
function Settings.RegisterCanvasLayoutCategory( frame, name )
	-- return a category structure
	return ( {["GetID"] = function() return 234; end} )
end
function Settings.RegisterAddOnCategory(category)
end

----------
-- C_Reputation
----------
C_Reputation = {}
function C_Reputation.GetFactionDataByID( idIn )
	for _, factionData in pairs( FactionInfo ) do
		if factionData.factionID == idIn then
			return factionData
		end
	end
end
function C_Reputation.GetFactionParagonInfo()
end

----------
-- C_GossipInfo
----------
C_GossipInfo = {}
function C_GossipInfo.GetFriendshipReputation( idIn )
	return {["maxRep"]=0, ["text"]="", ["reversedColor"]=false, ["reaction"]="", ["standing"]=0, ["reactionThreshold"]=0, ["friendshipFactionID"]=0, ["textrue"]=0}
end

----------
-- C_Item
----------
C_Item = {}
C_Item.GetItemCount = GetItemCount

----------
-- Menu
----------
Menu = {}
function Menu.ModifyMenu( ... )
end

----------
-- C_Timer
----------
C_Timer = {}
function C_Timer.After( seconds, callback )
end

----------
-- C_QuestLog
----------
C_QuestLog = {}
function C_QuestLog.IsQuestFlaggedCompleted( qnum )
	return ( qnum % 2 == 0 and true or false )
end
function C_QuestLog.GetTitleForQuestID( qnum )
	return "Test Quest"
end
function C_QuestLog.IsOnQuest( qnum )
	return true
end

----------
-- C_TaskQuest
----------
C_TaskQuest = {}
function C_TaskQuest.GetQuestInfoByQuestID( qnum )
end

----------
-- C_ClassTalents
----------
C_ClassTalents = {}
function C_ClassTalents.GetActiveConfigID()
end

----------
-- C_Traits
----------
C_Traits = {}
function C_Traits.GetConfigInfo( id )
	return {["ID"] = 13659962, ["name"] = "Holy", ["treeIDs"] = {790}, ["type"] = 1, ["usesSharedActionBars"] = false}
end
function C_Traits.GenerateImportString( configID )
	return "someReallyLongString"
end

----------
-- PlayerUtil
----------
PlayerUtil = {}
function PlayerUtil.GetCurrentSpecID()
	return {65, "Holy", "Desc", 135920, "HEALER", 4}
end

----------
-- C_PlayerInfo
----------
C_PlayerInfo = {}
function C_PlayerInfo.GetPlayerMythicPlusRatingSummary( unitStr )
	return {["runs"] = {}, ["currentSeasonScore"] = 0 }
end

-- A SAX parser takes a content handler, which provides these methods:
--     startDocument()                 -- called at the start of the Document
--     endDocument()                   -- called at the end of the Document
--     startElement( tagName, attrs )  -- with each tag start.  attrs is a table of attributes and values
--     endElement( tagName )           -- when a tag ends
--     characters( char )              -- for each character not being in a tag
-- The parser calls each of these methods as these events happen.

-- A SAX parser defines a parser (created with makeParser)
-- a Parser has a ContentHandler assigned
-- a Parser also defines these methods:
--      setContentHandler( contentHandler )
--      setFeature()  -- prob not going to implement
--      parse( text )
--      parse( file )

-- https://www.w3schools.com/xml/xml_elements.asp
-- https://www.w3schools.com/xml/xml_syntax.asp


contentHandler = {}
-- normally the contentHandler is an object, where data structures are created in the new object.
function contentHandler.startDocument( this )
end
function contentHandler.endDocument( this )
end
function contentHandler.startElement( this, tagName, attrs )
end
function contentHandler.endElement( this, tagName )
end
function contentHandler.characters( this, char )
end

saxParser = {}
-- SAX Parser
-- interface
function saxParser.makeParser()
	-- make a parser.  This is probably intended to be a factory function
	return saxParser
end
function saxParser.setContentHandler( contentHandlerIn )
	-- takes a table
	saxParser.contentHandler = contentHandlerIn
end
function saxParser.setFeature()
	-- research this
end
function saxParser.parse( fileIn )
	f = io.open( fileIn, "r" )
	if f then fileIn = f:read( "*all" ) end   -- read the contents of the file

	-- call the startDocument method for the given contentHandler
	if saxParser.contentHandler and saxParser.contentHandler.startDocument then
		saxParser.contentHandler:startDocument()
	end

	-- loop through each char
	State = {
		Outside       = { 0 },  -- outside of a tag
		ElementName   = { 1 },  -- When to parse for a name
		InElement     = { 2 },  -- In the element
	}
	currentState = State.Outside
	elementDepth = {}   -- table of current element depth
	elementName = ""
	chars = ""

	while( #fileIn > 0 ) do
		-- print( currentState[1].."\t"..#fileIn, "fileIn: "..string.sub( fileIn, 1, 60 ) )
		c = string.sub( fileIn, 1, 1 )
		n = string.sub( fileIn, 2, 2 )
		handled = false
		if currentState == State.Outside then
			if c == "<" then
				if n == "?" then
					local endProlog = string.find( fileIn, "?>" )
					if endProlog then
						fileIn = string.sub( fileIn, endProlog+2 )
					end
				elseif n == "!" then
					local endComment = string.find( fileIn, "%-%->" )
					if endComment then
						fileIn = string.sub( fileIn, endComment+3 )
					end
				else
					currentState = State.ElementName
					elementName = ""
					fileIn = string.sub( fileIn, 2 )
				end
			else
				saxParser.contentHandler:characters( c )
				fileIn = string.sub( fileIn, 2 )
			end
		elseif currentState == State.ElementName then
			tagStart, tagEnd, tagName = string.find( fileIn, "^([%a_][%a%d-_.]*)" )
			if tagStart then
				elementName = tagName
				attributes = {}
				currentState = State.InElement
				fileIn = string.sub( fileIn, tagEnd + 1 )
			end
			tagStart, tagEnd, tagName = string.find( fileIn, "^/([%a_][%a%d-_.]*)" )
			if tagStart then
				elementName = tagName
				-- print( "Fire endElement( "..tagName.." )" )
				depthElement = table.remove( elementDepth )
				saxParser.contentHandler:endElement( tagName )
				if depthElement ~= elementName then
					fail( "ERROR: Closing "..elementName.." is not the expected element to close; "..( depthElement or "nil" ).." is expected." )
				end
				currentState = State.Outside
				fileIn = string.sub( fileIn, tagEnd + 2 )
			end
		elseif currentState == State.InElement then
			attribStart, attribEnd, key, value = string.find( fileIn, "^%s*(%S+)%s*=%s*[\"\'](.-)[\"\']" )
			if c == ">" or n == ">" then
				-- print( "Fire startElement( "..elementName.." )" )
				-- print( "\twith attributes: ")
				-- for k,v in pairs( attributes ) do
					-- print( "\t\t"..k..":="..v )
				-- end
				table.insert( elementDepth, elementName )
				saxParser.contentHandler:startElement( elementName, attributes )
				currentState = State.Outside
				if c == "/" and n == ">" then
					-- print( "Fire endElement( "..elementName.." )" )
					depthElement = table.remove( elementDepth )
					saxParser.contentHandler:endElement( elementName )
					if depthElement ~= elementName then
						fail( "ERROR: Closing "..elementName.." is not the expected element to close; "..depthElement.." is expected." )
					end
					currentState = State.Outside
				end
				fileIn = string.sub( fileIn, (n==">" and 3 or 2) )
			elseif c == " " then
				fileIn = string.sub( fileIn, 2 )
			elseif attribStart then
				attributes[key] = value
				fileIn = string.sub( fileIn, attribEnd+1 )
			end
		end
		-- print( "elementDepth: "..table.concat( elementDepth, "\t" ) )
	end

	-- call the endDocument method for the given contentHandler
	if saxParser.contentHandler and saxParser.contentHandler.endDocument then
		saxParser.contentHandler:endDocument()
	end
end
function ParseXML( xmlFile )
	parents = {}
	ch = contentHandler
	ch.startElement = function( self, tagIn, attribs )
		if _G["Create"..tagIn] then
			if (attribs.name and (not attribs.virtual or attribs.virtual == "false")) then
				-- print("Create: "..attribs.name..">"..(#parents > 0 and string.gsub(attribs.name, "$parent", parents[#parents]) or "") )
				frameName = (#parents > 0 and string.gsub(attribs.name, "$parent", parents[#parents]) or attribs.name)
				_G[frameName] = _G["Create"..tagIn]( frameName )
				_G[frameName].framename = frameName
			end
		end
		if string.find( tagIn, "Frame$") then
			table.insert( parents, attribs.name )
		end
	end
	ch.endElement = function( self, tagIn )
		if string.find( tagIn, "Frame$" ) then
			table.remove( parents )
		end
	end
	parser = saxParser.makeParser()
	parser.setContentHandler( ch )
	parser.parse( xmlFile )
end

-----------------------------------------
-- TOC functions
addonData = {}
function ParseTOC( tocFile, useRequire )
	-- parse the TOC file for ## entries, and lua files to include
	-- put ## entries in addonData hash - normally hard coded
	-- set useRequire to use the old require method
	local tocFileTable = {}
	local f = io.open( tocFile, "r" )
	if f then
		local tocContents = f:read( "*all" )
		for line in tocContents:gmatch("([^\n]*)\n?") do
			if line ~= "" then
				local luaFile = line:match("([_%a][_%w]*)%.lua")
				local xmlFile = line:match("([_%a][_%w]*)%.xml")
				local hashKey, hashValue = line:match("## ([_%a]*): (.*)")

				if hashKey then
					addonData[hashKey] = hashValue
				elseif luaFile then
					table.insert(tocFileTable, { "lua", luaFile })
				elseif xmlFile then
					table.insert(tocFileTable, { "xml", xmlFile })
				end
			end
		end
		pathSeparator = string.sub(package.config, 1, 1)
		-- first character of this string (http://www.lua.org/manual/5.2/manual.html#pdf-package.config)
		includePath = tocFile
		while( string.sub( includePath, -1, -1 ) ~= pathSeparator ) do
			includePath = string.sub( includePath, 1, -2 )
		end
		addonName = string.sub( tocFile, string.len( includePath ) + 1, -5 )

		if( useRequire ) then
			--add to the include package.path
			package.path = includePath.."?.lua;" .. package.path
		end
		sharedTable = {}

		for _,f in pairs( tocFileTable ) do
			if( f[1] == "lua" ) then
				if( useRequire ) then
					require( f[2] )
				else
					local loadedfile = assert( loadfile( includePath..f[2]..".lua" ) )
					loadedfile( addonName, sharedTable )
				end
			elseif( f[1] == "xml" ) then
				ParseXML( includePath..f[2]..".xml" )
			end
		end
	else
		fail( "TOC file not found" )
	end
end

-- Standard Frames
GameTooltip = CreateFrame( "GameTooltip", "tooltip" )
ChatFrame1 = CreateFrame( nil, "ChatFrame1" )

---   https://wowwiki.fandom.com/wiki/AddOn_loading_process
--[[ Load event order:

After the addon code has been loaded, the loading process can be followed by registering for various events, listed here in order of firing.

    ADDON_LOADED
        This event fires whenever an AddOn has finished loading and the SavedVariables for that AddOn have been loaded from their file.
    SPELLS_CHANGED
        This event fires shortly before the PLAYER_LOGIN event and signals that information on the user's spells has been loaded and is available to the UI.
    PLAYER_LOGIN
        This event fires immediately before PLAYER_ENTERING_WORLD.
        Most information about the game world should now be available to the UI.
        All Sizing and Positioning of frames is supposed to be completed before this event fires.
        AddOns that want to do one-time initialization procedures once the player has "entered the world" should use this event instead of PLAYER_ENTERING_WORLD.
    PLAYER_ENTERING_WORLD
        This event fires immediately after PLAYER_LOGIN
        Most information about the game world should now be available to the UI. If this is an interface reload rather than a fresh log in, talent information should also be available.
        All Sizing and Positioning of frames is supposed to be completed before this event fires.
        This event also fires whenever the player enters/leaves an instance and generally whenever the player sees a loading screen
    PLAYER_ALIVE
        This event fires after PLAYER_ENTERING_WORLD
        Quest and Talent information should now be available to the UI
]]
