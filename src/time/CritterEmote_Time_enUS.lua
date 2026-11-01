local _, CritterEmote = ...
if GetLocale() == "enUS" then
CritterEmote.Time_emotes = {
	["PickTable"] = function(self)
		local month = date("%m")
		return self[month] or self
	end,
	["01"] = {
		"would like to mentor the next generation of pets.",
		"gave blood, and not in combat.",
	},
	["02"] = {
		"is reminded to check their heart rate.",
	},
	["04"] = {
		"hides the book of poems they are reading.",
	},
	["09"] = {
		"wants to head to the library to get their library card.",
	},
	["10"] = {
		"has a book picked out for National Book Month.",
		"quotes Neil Gaiman, \"A book is a dream that you hold in your hand.\"",
		"proudly states: \"Open a Book, Open Your Mind!\"",
	},
	["11"] = {
		"starts to think about how to work this into their memoir.",
		"ponders if they could actually finish that novel this month.",
		"just wants to curl up next to the fire with a good book.",
		"twirls an imaginary mustache thoughtfully.",
		"is jealous of the dwarves, who have been Movember-ready all year.",
		"wonders if a fake mustache counts.",
		"thinks of everyone who looks after a loved one, and silently says thank you.",
		"gives a caregiver a warm nod of appreciation.",
		"wonders when they last asked a caregiver how they're doing.",
		"offers to cover for a friend who's been caring for family, so they can rest.",
		"reminds a caregiver that they're allowed to take a break too.",
		"raises a mug of tea to the unsung caregivers everywhere.",
		"is writing a thank-you note to someone who has cared for a loved one.",
		"thinks about how much patience and love caregiving takes.",
		"is dropping off a meal for a family caring for someone.",
		"tips their hat to every family caregiver.",
		"knows that caring for the caregiver matters too.",
		"is grateful for the people who show up, day after day, for the ones they love.",
		"takes a deep breath and appreciates it.",
		"reminds everyone that lung cancer can affect people who have never smoked.",
	},
	"asks what is this month's national event?",
}
end
