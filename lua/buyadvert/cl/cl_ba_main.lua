--[[
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
This script was completed on: 17/09/15
The script version is: 1.1/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/
]]

local function CreateTimeButton(panel, x, y, num, time, price)
	local StatsCircle = vgui.Create( "DButton", panel )
	StatsCircle:SetPos( x, y )
	StatsCircle:SetSize( 10, 10 )
	StatsCircle:SetText("")
	StatsCircle.Paint = function( self, w, h )
		if self.Selected then
			BADrawCircle( w/2, h/2, 5, BA.Colors.PrimaryColor, false )
		else
			BADrawCircle( w/2, h/2, 5, BA.Colors.MainBG, false )
		end
	end
	StatsCircle.DoClick = function(self)
		panel.SelectedTime = num
		panel.TimePrice = price
	end
	StatsCircle.Think = function(self)
		if panel.SelectedTime == num then
			self.Selected = true
		else
			self.Selected = false
		end
	end
end

local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() then
			target = v
		end
	end
	return target
end

net.Receive("BA_Open_Menu", function()
	if !IsValid(AdvertiseMenuMain) and table.HasValue(BA.AllowedClasses, team.GetName(LocalPlayer():Team())) then 
		local AdvertiseMenuMain = vgui.Create( "DFrame" ) 
		AdvertiseMenuMain:SetSize( 850, 450 )
		AdvertiseMenuMain:Center()
		AdvertiseMenuMain:SetTitle( " " ) 
		AdvertiseMenuMain:SetVisible( true )
		AdvertiseMenuMain:SetDraggable( false ) 
		AdvertiseMenuMain:ShowCloseButton( false ) 				
		AdvertiseMenuMain:MakePopup() 
		AdvertiseMenuMain.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 10, 10, w-20, h-20, BA.Colors.SecondaryBG )
			draw.SimpleText( "Message", "Advertise_Title", w/2, 32, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Time", "Advertise_Title", w/2, 220, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Price", "Advertise_Title", w/2, self:GetTall()-95, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring(BA.MaxTime/10).." Sec.", "Advertise_Time", 45, 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*2).." Sec.", "Advertise_Time", 121, 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*3).." Sec.", "Advertise_Time", (121+76), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*4).." Sec.", "Advertise_Time", (121+76*2), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*5).." Sec.", "Advertise_Time", (121+76*3), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*6).." Sec.", "Advertise_Time", (121+76*4), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*7).." Sec.", "Advertise_Time", (121+76*5), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*8).." Sec.", "Advertise_Time", (121+76*6), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*9).." Sec.", "Advertise_Time", (121+76*7), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( tostring((BA.MaxTime/10)*10).." Sec.", "Advertise_Time", (121+76*8), 260, BA.Colors.AltText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		AdvertiseMenuMain.TimePrice = BA.PricePerTime
		AdvertiseMenuMain.TextPrice = 0
		AdvertiseMenuMain.Think = function(self)
			self.TotalPrice = self.TimePrice + self.TextPrice
		end
		AdvertiseMenuMain.SelectedTime = 1
		
		local CloseButton = vgui.Create( "DButton", AdvertiseMenuMain )
		CloseButton:SetSize( 250, 45 )
		CloseButton:SetPos( AdvertiseMenuMain:GetWide()/2-385, AdvertiseMenuMain:GetTall()-75 )
		CloseButton:SetText( "Cancel" )
		CloseButton:SetFont("Advertise_CancelSend")
		CloseButton:SetTextColor( Color(216, 222, 229 ) )
		CloseButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 5, 5, w-10, h-10, BA.Colors.SecondaryBG )
			--OrionDrawBoxLine( 1, 1, w-2, h-2, Color(249, 65, 78, 255) )
			--OrionDrawBoxLine( 0, 0, w, h, Color(0, 0, 0, 190) )
		end
		CloseButton.DoClick = function()
			AdvertiseMenuMain:Remove()			
		end
		CloseButton.OnCursorEntered = function( self )
			self.hover = true
		end
		CloseButton.OnCursorExited = function( self )
			self.hover = false
		end

		local MessagePanel = vgui.Create( "DPanel", AdvertiseMenuMain )
		MessagePanel:SetPos( 45, 60 )
		MessagePanel:SetSize( AdvertiseMenuMain:GetWide()-90, 125 )
		MessagePanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
		end

		local AdvertTextEntry = vgui.Create( "DTextEntry", MessagePanel )
		AdvertTextEntry:SetPos(0, 0)
		AdvertTextEntry:SetSize(MessagePanel:GetSize())
		AdvertTextEntry:SetText("Write your ad here...")
		AdvertTextEntry:SetDrawBorder(false)
		AdvertTextEntry:SetDrawBackground(false)
		AdvertTextEntry:SetFont("Advertise_Message_Box")
		AdvertTextEntry:SetCursorColor(BA.Colors.AltText)
		AdvertTextEntry:SetTextColor(BA.Colors.AltText)
		AdvertTextEntry:SetMultiline(true)
		AdvertTextEntry.OnGetFocus = function(self)
			if self:GetValue() == "Write your ad here..." then
				self:SetText("")
			end
			if self:GetTextColor() == BA.Colors.AltText then
				self:SetTextColor(BA.Colors.Text)
			end
		end
		AdvertTextEntry.OnLoseFocus = function(self)
			if self:GetValue() == "" then
				self:SetText("Write your ad here...")
			end
			if self:GetTextColor() == BA.Colors.Text then
				self:SetTextColor(BA.Colors.AltText)
			end
		end
		AdvertTextEntry.Think = function(self)
			if self:GetValue() == "Write your ad here..." then
				return
			else
				AdvertiseMenuMain.TextPrice = string.len(self:GetValue())*BA.PricePerLetter
			end
		end

		CreateTimeButton(AdvertiseMenuMain, 60, 280, 1, BA.MaxTime/10, BA.PricePerTime)
		CreateTimeButton(AdvertiseMenuMain, 60+76, 280, 2, (BA.MaxTime/10)*2, BA.PricePerTime*2)
		CreateTimeButton(AdvertiseMenuMain, 60+76*2, 280, 3, (BA.MaxTime/10)*2, BA.PricePerTime*3)
		CreateTimeButton(AdvertiseMenuMain, 60+76*3, 280, 4, (BA.MaxTime/10)*3, BA.PricePerTime*4)
		CreateTimeButton(AdvertiseMenuMain, 60+76*4, 280, 5, (BA.MaxTime/10)*4, BA.PricePerTime*5)
		CreateTimeButton(AdvertiseMenuMain, 60+76*5, 280, 6, (BA.MaxTime/10)*5, BA.PricePerTime*6)
		CreateTimeButton(AdvertiseMenuMain, 60+76*6, 280, 7, (BA.MaxTime/10)*6, BA.PricePerTime*7)
		CreateTimeButton(AdvertiseMenuMain, 60+76*7, 280, 8, (BA.MaxTime/10)*7, BA.PricePerTime*8)
		CreateTimeButton(AdvertiseMenuMain, 60+76*8, 280, 9, (BA.MaxTime/10)*8, BA.PricePerTime*9)
		CreateTimeButton(AdvertiseMenuMain, 60+77*9, 280, 10, (BA.MaxTime/10)*9, BA.PricePerTime*10)

		local PriceOutlinePanel = vgui.Create( "DPanel", AdvertiseMenuMain )
		PriceOutlinePanel:SetPos( AdvertiseMenuMain:GetWide()/2-125, AdvertiseMenuMain:GetTall()-75 )
		PriceOutlinePanel:SetSize( 250, 45 )
		PriceOutlinePanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
		end

		local PricePanel = vgui.Create( "DPanel", AdvertiseMenuMain )
		PricePanel:SetPos( AdvertiseMenuMain:GetWide()/2-120, AdvertiseMenuMain:GetTall()-70 )
		PricePanel:SetSize( 240, 35 )
		PricePanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.SecondaryBG )
			draw.SimpleText( "$"..string.Comma(tostring(AdvertiseMenuMain.TotalPrice)), "Advertise_Price", w/2, 18, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		local BuyButton = vgui.Create( "DButton", AdvertiseMenuMain )
		BuyButton:SetSize( 250, 45 )
		BuyButton:SetPos( AdvertiseMenuMain:GetWide()/2+135, AdvertiseMenuMain:GetTall()-75 )
		BuyButton:SetText( "Purchase" )
		BuyButton:SetFont("Advertise_CancelSend")
		BuyButton:SetTextColor( Color(216, 222, 229 ) )
		BuyButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 5, 5, w-10, h-10, BA.Colors.SecondaryBG )
			--OrionDrawBoxLine( 1, 1, w-2, h-2, Color(249, 65, 78, 255) )
			--OrionDrawBoxLine( 0, 0, w, h, Color(0, 0, 0, 190) )
		end
		BuyButton.DoClick = function()
			if AdvertTextEntry:GetValue() != "Write your ad here..." then
				if GetTableCount() == 0 then
					net.Start("BA_SendAdvertise_Client")
						local tbl = {}
						tbl.Player = FindPlayer(LocalPlayer():Nick())
						tbl.Message = AdvertTextEntry:GetValue()
						tbl.Price = AdvertiseMenuMain.TotalPrice
						tbl.Time = (BA.MaxTime/10)*AdvertiseMenuMain.SelectedTime
						net.WriteTable(tbl)
					net.SendToServer()
					AdvertiseMenuMain:Remove()
				else
					Derma_Message( "All of the advertisement places are filled.", "ERROR: Full", "Okay" )
				end
			else
				Derma_Message( "You must enter a message!", "ERROR: Text", "Okay" )
			end
		end
		BuyButton.OnCursorEntered = function( self )
			self.hover = true
		end
		BuyButton.OnCursorExited = function( self )
			self.hover = false
		end
	end
end)

surface.CreateFont( "Advertise_Title", {
	font = "Roboto Regular",
	size = 38,
	weight = 500
} )
surface.CreateFont( "Advertise_CancelSend", {
	font = "Roboto Regular",
	size = 25,
	weight = 500
} )
surface.CreateFont( "Advertise_Message_Box", {
	font = "Roboto Regular",
	size = 20,
	weight = 500
} )
surface.CreateFont( "Advertise_Price", {
	font = "Roboto Regular",
	size = 30,
	weight = 500
} )

surface.CreateFont( "Advertise_Time", {
	font = "Roboto Regular",
	size = 18,
	weight = 500
} )
surface.CreateFont( "Advertise_VIP", {
	font = "Roboto Regular",
	size = 17,
	weight = 500
} )

net.Receive("BA_SendAdvertise_Server", function()
	local tbl = net.ReadTable()
	local ply = tbl.Player
	local msg = tbl.Message
	local time = tbl.Time
	NewAdvert(time, msg, ply)
	timer.Create("Advertisement_"..ply:EntIndex(), time, 1, function()
		hook.Remove("HUDPaint", "ShowAdvertisements")
		RemoveAdvert(msg, ply)
		timer.Simple(2, function() OpenThisThing(msg, ply) end)
	end)
	print("Onscreen")
	OpenThisThing(msg, ply)
end)

concommand.Add("ClearTab", function()
	ClearTable()
end)

function OpenThisThing(msg, ply)
	if LocalPlayer():GetStatus() == false then
		hook.Add("HUDPaint", "ShowAdvertisements", function()
			local w, h = ScrW(), ScrH()
			--local msg = BA.CurrentAdverts[1].msg
			if GetTableCount() == 1 then
				draw.RoundedBox( 0, w-275, 10, 265, 150, BA.Colors.MainBG )
				draw.RoundedBox( 0, w-265, 20, 245, 130, BA.Colors.SecondaryBG )
				if string.len(msg) > 35 then
					draw.SimpleText( string.sub(msg, 1, 35), "Advertise_Time", w-142.5, 32, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( msg, "Advertise_Time", w-142.5, 35, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				if string.len(msg) > 35 then
					draw.SimpleText( string.sub(msg, 36, 71), "Advertise_Time", w-142.5, 55, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				if string.len(msg) > 71 then
					draw.SimpleText( string.sub(msg, 72, 106), "Advertise_Time", w-142.5, 75, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				if string.len(msg) > 106 then
					draw.SimpleText( string.sub(msg, 107, 142), "Advertise_Time", w-142.5, 95, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( "Advertisement By: "..ply:Nick(), "Advertise_Time", w-142.5, 135, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end)
	end
end

net.Receive("BA_Open_VIP_Menu", function()
	local stat = net.ReadBool()
	if LocalPlayer():GetStatus() == false then
		ShowOptionMenu("You currently have advertisements turned", "Would you like to turn them off?", "on.", true)
	end	
	if LocalPlayer():GetStatus() == true then 
		ShowOptionMenu("You currently have advertisements turned", "Would you like to turn them on?", "off.", false)
	end
end)

function ShowOptionMenu(title, title2, status, stat)
	if !IsValid(VIPToggleMenu) then
		local VIPToggleMenu = vgui.Create( "DFrame" ) 
		VIPToggleMenu:SetSize( 300, 150 )
		VIPToggleMenu:Center()
		VIPToggleMenu:SetTitle( " " ) 
		VIPToggleMenu:SetVisible( true )
		VIPToggleMenu:SetDraggable( false ) 
		VIPToggleMenu:ShowCloseButton( false ) 				
		VIPToggleMenu:MakePopup() 
		VIPToggleMenu.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 10, 10, w-20, h-20, BA.Colors.SecondaryBG )
			draw.SimpleText( title, "Advertise_VIP", w-150, 30, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( status, "Advertise_VIP", w-150, 50, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( title2, "Advertise_VIP", w-150, 80, BA.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local ChangeButton = vgui.Create( "DButton", VIPToggleMenu )
		ChangeButton:SetSize( 100, 30 )
		ChangeButton:SetPos( (VIPToggleMenu:GetWide()/2)-105, VIPToggleMenu:GetTall()-50 )
		ChangeButton:SetText( "Yes" )
		ChangeButton:SetFont("Advertise_CancelSend")
		ChangeButton:SetTextColor( Color(216, 222, 229 ) )
		ChangeButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 3, 3, w-6, h-6, BA.Colors.SecondaryBG )
			--OrionDrawBoxLine( 1, 1, w-2, h-2, Color(249, 65, 78, 255) )
			--OrionDrawBoxLine( 0, 0, w, h, Color(0, 0, 0, 190) )
		end
		ChangeButton.DoClick = function()
			if table.HasValue(BA.DonationRank, ply:GetRank()) then
				net.Start("Change_Stat_ToServer")
					net.WriteBool(stat)
					net.WriteEntity(FindPlayer(LocalPlayer():Nick()))
				net.SendToServer()
			end
			print(stat)
			VIPToggleMenu:Remove()
		end
		ChangeButton.OnCursorEntered = function( self )
			self.hover = true
		end
		ChangeButton.OnCursorExited = function( self )
			self.hover = false
		end

		local CloseButton = vgui.Create( "DButton", VIPToggleMenu )
		CloseButton:SetSize( 100, 30 )
		CloseButton:SetPos( (VIPToggleMenu:GetWide()/2)+5, VIPToggleMenu:GetTall()-50 )
		CloseButton:SetText( "No" )
		CloseButton:SetFont("Advertise_CancelSend")
		CloseButton:SetTextColor( Color(216, 222, 229 ) )
		CloseButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, BA.Colors.MainBG )
			draw.RoundedBox( 0, 3, 3, w-6, h-6, BA.Colors.SecondaryBG )
			--OrionDrawBoxLine( 1, 1, w-2, h-2, Color(249, 65, 78, 255) )
			--OrionDrawBoxLine( 0, 0, w, h, Color(0, 0, 0, 190) )
		end
		CloseButton.DoClick = function()
			VIPToggleMenu:Remove()			
		end
		CloseButton.OnCursorEntered = function( self )
			self.hover = true
		end
		CloseButton.OnCursorExited = function( self )
			self.hover = false
		end
	end
end