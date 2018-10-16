--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

util.AddNetworkString("BA_Open_Menu")
hook.Add("PlayerSay", "BA_OpenMenu", function(ply, text)
	if text == BA.ChatCommand then
		if table.HasValue(BA.AllowedClasses, team.GetName(ply:Team())) then
			net.Start("BA_Open_Menu")
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("BA_Open_VIP_Menu")
hook.Add("PlayerSay", "BA_OpenMenu_VIP", function(ply, text)
	if text == BA.VIPChatCommand then
		if table.HasValue(BA.DonationRank, ply:GetRank()) then
			net.Start("BA_Open_VIP_Menu")
				net.WriteBool(ply:GetStatus())
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("BA_SendAdvertise_Client")
util.AddNetworkString("BA_SendAdvertise_Server")
net.Receive("BA_SendAdvertise_Client", function()
	local tbl = net.ReadTable()
	local ply = tbl.Player
	local amt = tbl.Price
	local time = tbl.Time
	local msg = tbl.Message
	if GetTableCount() == 0 or GetTableCount() == 1 or GetTableCount() == 2 then
		if ply:IsPlayer() and ply:canAfford(amt) then
			if table.HasValue(BA.AllowedClasses, team.GetName(ply:Team())) then
				ply:addMoney(-amt)
				DarkRP.notify(ply, 0, 10, "Congragulations on purchasing an advertisement place!")
				net.Start("BA_SendAdvertise_Server")
					local tbl = {}
					tbl.Time = time
					tbl.Player = ply
					tbl.Message = msg
					net.WriteTable(tbl)
				net.Broadcast()
			else
				DarkRP.notify(ply, 1, 10, "You are not the right class to perform this action!")
			end
		else
			DarkRP.notify(ply, 1, 10, "You cannot afford this advertisement!")
		end
	else
		DarkRP.notify(ply, 1, 10, "All of the advertisement places are filled.")
	end
end)

hook.Add("PlayerInitialSpawn", "SetValues", function(ply)
	if ply:GetPData( "save_advert_status" ) != nil then
		ply:LoadStatus()
		print("[BA] Status was found and set for "..ply:Nick()..".")
	else
		ply:SetStatus(false)
		print("[BA] Status was not found. Setting Status for "..ply:Nick().." to false.")
	end
end)

hook.Add("PlayerDisconnected", "SaveValues", function(ply)
	ply:SaveStatus()
end)

util.AddNetworkString("Change_Stat_ToServer")
net.Receive("Change_Stat_ToServer", function()
	local stat = net.ReadBool()
	local ply = net.ReadEntity()
	ply:SetStatus(stat)
end)