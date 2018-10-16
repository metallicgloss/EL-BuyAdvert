--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

BA = {}
BA.CurrentAdverts = {}
BA.Colors = {}


BA.ChatCommand = "!advertise" --The chat command to open menu.
BA.VIPChatCommand = "!advertiseVIP" --The chat command to open VIP menu.
BA.DonationRank = { --Self explanatory. Whatever ranks are allowed to open the close menu - PrometheusIPN
	1,
	2,
	3
} 
BA.AllowedClasses = { --The teams allowed to use the NPC or chat command. I switched this to fix the command not working. Do the names of teams not TEAM_BLAH.
	"Citizen"
}
BA.Colors.MainBG = Color(57, 57, 57, 255) --The back panel color.
BA.Colors.SecondaryBG = Color(38, 38, 38, 255) --The inner panel color.
BA.Colors.Text = Color(234, 234, 234, 255) --Color of some text.
BA.Colors.AltText = Color(91, 91, 91, 255) --Color of some text.
BA.Colors.PrimaryColor = Color(227, 81, 39, 255) --Color of the non gray.
BA.PricePerTime = 10000 --The amount of time per 1/10 of the max time.
BA.MaxTime = 100 --The max amount of time a player can select.
BA.PricePerLetter = 100 --The cost each letter will be.
BA.NPCModel = "models/kleiner.mdl" --Model of NPC.