--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1
/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel(BA.NPCModel)
	self:SetMoveType(MOVETYPE_NONE)
    self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal()
	self:SetNPCState( 0	)
	self:SetSolid( SOLID_BBOX ) 
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType( SIMPLE_USE )
	self:SetMaxYawSpeed( 90 )
end

util.AddNetworkString("BA_Open_Menu")
function ENT:AcceptInput(name, activator, caller, data)
	if name == "Use" and IsValid(caller) and caller:IsPlayer() then
		if table.HasValue(BA.AllowedClasses, team.GetName(caller:Team())) then
			net.Start("BA_Open_Menu")
			net.Send(caller)
		end
	end
end

function ENT:OnTakeDamage()
	return
end 

hook.Add( "PostGamemodeLoaded", "WriteAdvertiseNPCFiles", function()
	if !file.IsDir( "elgcadvert", "DATA" ) then
		file.CreateDir( "elgcadvert", "DATA" )
		MsgN( "[BA] Created elgcadvert!" )
	end
	if !file.IsDir( "elgcadvert/"..string.lower(game.GetMap()).."", "DATA" ) then
		file.CreateDir( "elgcadvert/"..string.lower(game.GetMap()).."", "DATA" )
		MsgN( "[BA] Created elgcadvert/"..string.lower(game.GetMap()).."!" )
	end
	if !file.Exists( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "DATA" ) then
		file.Write( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "", "DATA")
		MsgN( "[BA] Created placements.txt!" )
	end
end)

hook.Add( "InitPostEntity", "Spawn Advertise NPC's", function()
	if file.Exists( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "DATA" ) then
		local FILE = file.Read("elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE) or {}
		for k, v in pairs( TABLE ) do 
			local pos = v.pos
			local ang = v.ang
			local spawn_npc = ents.Create( "advertisenpc" )
			spawn_npc:SetPos( pos )
			spawn_npc:SetAngles( ang )
			spawn_npc:SetMoveType( MOVETYPE_NONE )
			spawn_npc:Spawn()
		end
		MsgN( "[BA] Read Files and Spawned NPC's!" )
	end
end)

concommand.Add( "save_advertpos", function( ply )
	if file.Exists( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "DATA" ) then
		RunConsoleCommand( "remove_advertpos" )
	end
	timer.Simple( 2, function()
		local NPCLocation = {}
		for k, v in pairs( ents.FindByClass( "advertisenpc" ) ) do
			if IsValid( v ) then
				table.insert( NPCLocation, {pos = v:GetPos(), ang = v:GetAngles() } )
			end
		end
		file.Write( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", util.TableToJSON(NPCLocation))
		ply:ChatPrint( "NPC Positions Set!" )
	end)
end)

concommand.Add( "remove_advertpos", function( ply )
	if file.Exists( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt", "DATA" ) then
		file.Delete( "elgcadvert/"..string.lower(game.GetMap()).."/placements.txt" )
	end
end)




