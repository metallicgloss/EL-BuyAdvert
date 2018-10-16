--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

local maindirectory = "buyadvert"
local AddonName = "BA"
if SERVER then
	AddCSLuaFile()
	local folder = maindirectory .. "/sh"
	local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	folder = maindirectory .."/cl"
	files = file.Find( folder .. "/" .. "*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( folder .. "/" .. file )
	end

	--Shared modules
	local files = file.Find( maindirectory .."/sh/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3), "[" .. AddonName .. "] Loading SHARED file: " .. file .. "\n")
			include( maindirectory .. "/sh/" .. file )
			AddCSLuaFile( maindirectory .. "/sh/" .. file )
		end
	end

	--Server modules
	local files = file.Find( maindirectory .."/sv/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading SERVER file: " .. file .. "\n")
			include( maindirectory .. "/sv/" .. file )
		end
	end

	MsgC(Color( 255, 179, 3 ), "\n----------------------------[ Load Complete ]------------------------\n\n")
end

if CLIENT then
	--Shared modules
	local files = file.Find( maindirectory .."/sh/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading SHARED file: " .. file .. "\n")
			include( maindirectory .. "/sh/" .. file )
		end
	end

	--Client modules
	local files = file.Find( maindirectory .."/cl/*.lua", "LUA" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			MsgC(Color( 255, 179, 3 ), "[" .. AddonName .. "] Loading CLIENT file: " .. file .. "\n")
			include( maindirectory .."/cl/" .. file )
		end
	end
	MsgC(Color( 255, 179, 3 ), "-------------------------------[ Load Complete ]---------------------------\n\n")
end