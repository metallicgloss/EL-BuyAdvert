--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1
/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

function BADrawCircle( posx, posy, radius, color, selected )
	local poly = { }
	local v = 40
	for i = 0, v do
		poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
	if selected then
		surface.DrawCircle(posx, posy, radius, Color(255, 255, 255, 255))
	else
		surface.DrawCircle(posx, posy, radius, color)
	end
end
local meta = FindMetaTable( "Player" )

function meta:SaveStatus()
	self:SetPData( "save_advert_status", self:GetStatus() )
	print("[BA] Saved the status for "..self:Nick().." as "..tostring(self:GetStatus())..".")
end 

function meta:GetStatus()
	return self:GetNWBool( "AdvertStatus" )
end

function meta:LoadStatus()
	self:SetNWBool( "AdvertStatus", self:GetPData( "save_advert_status" ) )
end

function meta:SetStatus( amt )
	self:SetNWBool( "AdvertStatus", amt )
	print("[BA] Set the status for "..self:Nick().." to "..tostring(amt)..".")
end

function NewAdvert(t, m, p)
	table.insert(BA.CurrentAdverts, {Time = t, Msg = m, Ply = p})
end

function FindAdvertInTable(m, p)
	for k, v in pairs(BA.CurrentAdverts) do 
		if v.Ply == p or v.Msg == m then
			return k
		end
	end
end

function RemoveAdvert(m, p)
	table.remove(BA.CurrentAdverts, FindAdvertInTable(m, p))
end

function ClearTable()
	table.Empty(BA.CurrentAdverts)
end

function GetTableCount()
	return table.Count(BA.CurrentAdverts)
end
