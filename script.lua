local Entity = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVilisz/Platinum/main/Entity.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()

repeat wait() until game:IsLoaded()

local Window = Library:AddWindow({
	title = {"Platinum", "GG"},
	theme = {
		Accent = Color3.fromRGB(255, 0, 0)
	},
	key = nil,
	default = true
})

Window:Background(false)

local Tab = Window:AddTab("Blatant", {default = true})
local Section = Tab:AddSection("Flight", {default = false})
local networkownerswitch = tick()
local isnetworkowner = function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
local function calculateMoveVector(cameraRelativeMoveVector)
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = game:GetService("Workspace").CurrentCamera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01*math.sign(R12)
	end
	local norm = math.sqrt(c*c + s*s)
	return Vector3.new(
		(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
		0,
		(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
	)
end

local Fly = {Enabled = false, Connections = {}, OnlyConnection = nil}
local FlySpeed = {Value = 1}
local FlyVerticalSpeed = {Value = 1}
local FlyTPOff = {Value = 10}
local FlyTPOn = {Value = 10}
local FlyBounceSpeed = {Value = 10}
local FlyCFrameVelocity = {Enabled = false}
local FlyWallCheck = {Enabled = false}
local FlyVertical = {Enabled = false}
local FlyMethod = {Value = "Normal"}
local FlyMoveMethod = {Value = "MoveDirection"}
local FlyKeys = {Value = "Space/LeftControl"}
local FlyState = {Value = "Normal"}
local FlyBlockMethod = {Value = "NewPart"}
local FlyPlatformStanding = {Enabled = false}
local FlyNoRagdoll = {Enabled = false}
local FlyOldPartData = {Anchored = nil, CanCollide = nil, Size = nil, Transparency = nil, Position = nil}
local FlyAllowedParts = {Enabled = true}
local FlyAllowedMeshs = {Enabled = false}
local FlyAllowedTruss = {Enabled = false}
local FlyAllowedWedge = {Enabled = false}
local FlyAllowedBases = {Enabled = false}
local FlyRaycast = RaycastParams.new()
FlyRaycast.FilterType = Enum.RaycastFilterType.Blacklist
FlyRaycast.RespectCanCollide = true
local FlyJumpCFrame = CFrame.new(0, 0, 0)
local FlyAliveCheck = false
local FlyUp = false
local FlyDown = false
local FlyY = 0
local FlyPlatform
local FlyBlockpart
local w = 0
local s = 0
local a = 0
local d = 0
local FlyPlatformTick = tick() + 0.2
w = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and -1 or 0
s = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) and 1 or 0
a = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) and -1 or 0
d = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) and 1 or 0
table.insert(Fly.Connections, game:GetService("UserInputService").InputBegan:Connect(function(input1)
	if game:GetService("UserInputService"):GetFocusedTextBox() ~= nil then return end
	if input1.KeyCode == Enum.KeyCode.W then
		w = -1
	elseif input1.KeyCode == Enum.KeyCode.S then
		s = 1
	elseif input1.KeyCode == Enum.KeyCode.A then
		a = -1
	elseif input1.KeyCode == Enum.KeyCode.D then
		d = 1
	end
	if FlyVertical.Enabled then
		local divided = FlyKeys.Value:split("/")
		if input1.KeyCode == Enum.KeyCode[divided[1]] then
			FlyUp = true
		elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
			FlyDown = true
		end
	end
end))
table.insert(Fly.Connections, game:GetService("UserInputService").InputEnded:Connect(function(input1)
	local divided = FlyKeys.Value:split("/")
	if input1.KeyCode == Enum.KeyCode.W then
		w = 0
	elseif input1.KeyCode == Enum.KeyCode.S then
		s = 0
	elseif input1.KeyCode == Enum.KeyCode.A then
		a = 0
	elseif input1.KeyCode == Enum.KeyCode.D then
		d = 0
	elseif input1.KeyCode == Enum.KeyCode[divided[1]] then
		FlyUp = false
	elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
		FlyDown = false
	end
end))
if game:GetService("UserInputService").TouchEnabled then
	pcall(function()
		local jumpButton = Entity.LocalPlayer.PlayerGui.TouchGui.TouchControlFrame.JumpButton
		table.insert(Fly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
			FlyUp = jumpButton.ImageRectOffset.X == 146
		end))
		FlyUp = jumpButton.ImageRectOffset.X == 146
	end)
end
if FlyMethod.Value == "Jump" and Entity.IsAlive then
	Entity.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
local FlyTP = false
local FlyTPTick = tick()
local FlyTPY
local Key = nil
Section:AddBind("Bind", Enum.KeyCode.F, {toggleable = true, default = true, flag = "Bind_Flag"}, function(keycode)
	Key = keycode
	Fly.Enabled = not Fly.Enabled
	print(Key, Fly.Enabled)
	if Fly.Enabled == false then
		if Fly.OnlyConnection ~= nil then Fly.OnlyConnection:Disconnect() Fly.OnlyConnection = nil end
		if FlyBlockpart then
			if FlyBlockpart.Name == "FlyPart" and FlyBlockpart.Parent == game:GetService("Workspace").CurrentCamera then
				FlyBlockpart:Destroy()
				FlyBlockpart = nil
			else
				FlyBlockpart.Anchored = FlyOldPartData.Anchored
				FlyBlockpart.CanCollide = FlyOldPartData.CanCollide
				FlyBlockpart.Size = FlyOldPartData.Size
				FlyBlockpart.Transparency = FlyOldPartData.Transparency
				FlyBlockpart.CFrame = FlyOldPartData.Position
				FlyBlockpart = nil
			end
		end
		FlyUp = false
		FlyDown = false
		FlyY = nil
		if Entity.IsAlive then
			if FlyPlatformStanding.Enabled then
				Entity.Humanoid.PlatformStand = false
			end
			if FlyNoRagdoll.Enabled then
				if Entity.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
					Entity.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end
		end
	end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Key then
		Library:Notify({title = "Flight", text = Fly.Enabled == true and "Enabled" or "Disabled", duration = Fly.Enabled == true and 1 or 3, color = Fly.Enabled == true and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)})
		Fly.OnlyConnection = game:GetService("RunService").Heartbeat:Connect(function(delta)
			if Fly.Enabled == true and Entity.IsAlive and (typeof(Entity.HumanoidRootPart) ~= "Instance" or isnetworkowner(Entity.HumanoidRootPart)) then
				Entity.Humanoid.PlatformStand = FlyPlatformStanding.Enabled
				if not FlyY then FlyY = Entity.HumanoidRootPart.CFrame.p.Y end
				local movevec = (FlyMoveMethod.Value == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or Entity.Humanoid.MoveDirection).Unit
				movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
				if FlyState.Value ~= "None" then 
					Entity.Humanoid:ChangeState(Enum.HumanoidStateType[FlyState.Value])
				end
				if FlyMethod.Value == "Normal" or FlyMethod.Value == "Bounce" then
					if FlyPlatformStanding.Enabled then
						Entity.HumanoidRootPart.CFrame = CFrame.new(Entity.HumanoidRootPart.CFrame.p, Entity.HumanoidRootPart.CFrame.p + game:GetService("Workspace").CurrentCamera.CFrame.lookVector)
						Entity.HumanoidRootPart.RotVelocity = Vector3.zero
					end
					Entity.HumanoidRootPart.Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, 0.85 + (FlyMethod.Value == "Bounce" and (tick() % 0.5 > 0.25 and -FlyBounceSpeed.Value or FlyBounceSpeed.Value) or 0) + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
				else
					if FlyUp then
						FlyY = FlyY + (FlyVerticalSpeed.Value * delta)
					end
					if FlyDown then
						FlyY = FlyY - (FlyVerticalSpeed.Value * delta)
					end
					local newMovementPosition = (movevec * (math.max(FlySpeed.Value - Entity.Humanoid.WalkSpeed, 0) * delta))
					newMovementPosition = Vector3.new(newMovementPosition.X, (FlyY - Entity.HumanoidRootPart.CFrame.p.Y), newMovementPosition.Z)
					if FlyWallCheck.Enabled then
						FlyRaycast.FilterDescendantsInstances = {Entity.Character, game:GetService("Workspace").CurrentCamera}
						local ray = workspace:Raycast(Entity.HumanoidRootPart.Position, newMovementPosition, FlyRaycast)
						if ray and ray.Instance.CanCollide then 
							newMovementPosition = (ray.Position - Entity.HumanoidRootPart.Position)
							FlyY = ray.Position.Y
						end
					end
					local origvelo = Entity.HumanoidRootPart.Velocity
					if FlyMethod.Value == "CFrame" then
						Entity.HumanoidRootPart.CFrame = Entity.HumanoidRootPart.CFrame + newMovementPosition
						if FlyCFrameVelocity.Enabled then 
							Entity.HumanoidRootPart.Velocity = Vector3.new(origvelo.X, 0, origvelo.Z)
						end
						if FlyPlatformStanding.Enabled then
							Entity.HumanoidRootPart.CFrame = CFrame.new(Entity.HumanoidRootPart.CFrame.p, Entity.HumanoidRootPart.CFrame.p + game:GetService("Workspace").CurrentCamera.CFrame.lookVector)
						end
					elseif FlyMethod.Value == "Jump" then
						Entity.HumanoidRootPart.CFrame = Entity.HumanoidRootPart.CFrame + Vector3.new(newMovementPosition.X, 0, newMovementPosition.Z)
						if Entity.HumanoidRootPart.Velocity.Y < -(Entity.Humanoid.JumpPower - ((FlyUp and FlyVerticalSpeed.Value or 0) - (FlyDown and FlyVerticalSpeed.Value or 0))) then
							FlyJumpCFrame = Entity.HumanoidRootPart.CFrame * CFrame.new(0, -Entity.Humanoid.HipHeight, 0)
							Entity.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					elseif FlyMethod.Value == "Block" then
						if not FlyBlockpart then
							if FlyBlockMethod.Value == "NewPart" then
								FlyBlockpart = Instance.new("Part")
								FlyBlockpart.Name = "FlyPart"
								FlyBlockpart.Anchored = true
								FlyBlockpart.CanCollide = true
								FlyBlockpart.Size = Vector3.new(2, 1, 2)
								FlyBlockpart.Transparency = 1
								FlyBlockpart.Parent = game.Workspace.CurrentCamera
							elseif FlyBlockMethod.Value == "RandomPart" then
								local parts = game:GetService("Workspace"):GetDescendants()
								local filteredParts = {}
								for _, part in ipairs(parts) do
									if (FlyAllowedParts.Enabled and part:IsA("Part")) or 
										(FlyAllowedMeshs.Enabled and part:IsA("MeshPart")) or 
										(FlyAllowedTruss.Enabled and part:IsA("TrussPart")) or 
										(FlyAllowedWedge.Enabled and part:IsA("WedgePart")) or 
										(FlyAllowedBases.Enabled and part:IsA("BasePart")) then
										if part.Parent ~= Entity.Character and part.Name ~= "Baseplate" then
											table.insert(filteredParts, part)
										end
									end
								end
								if #filteredParts > 0 then
									local randomIndex = math.random(1, #filteredParts)
									FlyBlockpart = filteredParts[randomIndex]
									FlyOldPartData.Anchored = FlyBlockpart.Anchored
									FlyOldPartData.CanCollide = FlyBlockpart.CanCollide
									FlyOldPartData.Size = FlyBlockpart.Size
									FlyOldPartData.Transparency = FlyBlockpart.Transparency
									FlyOldPartData.Position = FlyBlockpart.CFrame
									FlyBlockpart.Anchored = true
									FlyBlockpart.CanCollide = true
									FlyBlockpart.Size = Vector3.new(2, 1, 2)
									FlyBlockpart.Transparency = 1
								end

							end
						else
							FlyBlockpart.CFrame = Entity.HumanoidRootPart.CFrame * CFrame.new(0, -(Entity.Humanoid.HipHeight + (Entity.HumanoidRootPart.Size.Y / 2) + 0.53) + 0.0295, 0)
							Entity.HumanoidRootPart.Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Running and -1 or 0.85 + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
						end
					elseif FlyMethod.Value == "Buffer" then
						Entity.HumanoidRootPart.Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, 0.85 + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
						Entity.HumanoidRootPart.CFrame = Entity.HumanoidRootPart.CFrame + newMovementPosition
					else
						if FlyTPTick <= tick() then 
							FlyTP = not FlyTP
							if FlyTP then
								if FlyTPY then FlyY = FlyTPY end
							else
								FlyTPY = FlyY
								FlyRaycast.FilterDescendantsInstances = {Entity.Character, game:GetService("Workspace").CurrentCamera}
								local ray = workspace:Raycast(Entity.HumanoidRootPart.Position, Vector3.new(0, -10000, 0), FlyRaycast)
								if ray then FlyY = ray.Position.Y + ((Entity.HumanoidRootPart.Size.Y / 2) + Entity.Humanoid.HipHeight) end
							end
							FlyTPTick = tick() + ((FlyTP and FlyTPOn.Value or FlyTPOff.Value) / 10)
						end
						Entity.HumanoidRootPart.CFrame = Entity.HumanoidRootPart.CFrame + newMovementPosition
						if FlyPlatformStanding.Enabled then
							Entity.HumanoidRootPart.CFrame = CFrame.new(Entity.HumanoidRootPart.CFrame.p, Entity.HumanoidRootPart.CFrame.p + game:GetService("Workspace").CurrentCamera.CFrame.lookVector)
							Entity.HumanoidRootPart.RotVelocity = Vector3.zero
						end
					end
				end
				if FlyNoRagdoll.Enabled then
					if Entity.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
						Entity.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end
				end
			else
				FlyY = nil
			end
		end)
	end
end)
Section:AddSlider("Speed", 1, 500, 10, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val)
	FlySpeed.Value = val
end)
Section:AddSlider("Vertical Speed", 1, 500, 10, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val, bool)
	FlyVerticalSpeed.Value = val
	FlyVertical.Enabled = bool
end)
Section:AddDropdown("Method", {"Normal", "CFrame", "Jump", "TP", "Bounce", "Block", "Buffer"}, {default = "Normal"}, function(selected)
	FlyMethod.Value = selected
end)
Section:AddDropdown("Movement", {"Manual", "MoveDirection"}, {default = "MoveDirection"}, function(selected)
	FlyMoveMethod.Value = selected
end)
local states = {"None"}
for i,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do if v.Name ~= "Dead" and v.Name ~= "None" then table.insert(states, v.Name) end end
Section:AddDropdown("State", states, {default = "None"}, function(selected)
	FlyState.Value = selected
end)
local SubSection4 = Section:AddSubSection("Block Adjustments (Beta)", {default = false})
SubSection4:AddDropdown("Method", {"NewPart", "RandomPart"}, {default = "NewPart"}, function(selected)
	FlyBlockMethod.Value = selected
end)
SubSection4:AddToggle("Parts", {flag = "Toggle_Flag", default = true}, function(bool)
	FlyAllowedParts.Enabled = bool
end)
SubSection4:AddToggle("MeshParts", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyAllowedMeshs.Enabled = bool
end)
SubSection4:AddToggle("Truss", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyAllowedTruss.Enabled = bool
end)
SubSection4:AddToggle("Wedge", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyAllowedWedge.Enabled = bool
end)
SubSection4:AddToggle("Base (Bug)", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyAllowedBases.Enabled = bool
end)
SubSection4:AddLabel("Do Not Change Method During Flying.")
local SubSection3 = Section:AddSubSection("TP Adjustments", {default = false})
SubSection3:AddSlider("Air", 1, 30, 5, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val)
	FlyTPOff.Value = val
end)
SubSection3:AddSlider("Ground", 1, 100, 10, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val)
	FlyTPOn.Value = val
end)
local SubSection2 = Section:AddSubSection("Bounce Adjustments", {default = false})
SubSection2:AddSlider("Bounce Speed", 1, 50, 5, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val)
	FlyBounceSpeed.Value = val
end)
Section:AddDropdown("Keys", {"Space/LeftControl", "Space/LeftShift", "E/Q", "Z/X", "Q/Z", "Space/Q", "Space/X", "Space/Z"}, {default = "E/Q"}, function(selected)
	FlyKeys.Value = selected
end)
local ExtraSubSection = Section:AddSubSection("Extra", {default = false})
ExtraSubSection:AddToggle("No Velocity", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyCFrameVelocity.Enabled = bool
end)
ExtraSubSection:AddToggle("Wall Check", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyWallCheck.Enabled = bool
end)
ExtraSubSection:AddToggle("PlatformStand", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyPlatformStanding.Enabled = bool
end)
ExtraSubSection:AddToggle("No Ragdoll", {flag = "Toggle_Flag", default = false}, function(bool)
	FlyNoRagdoll.Enabled = bool
end)
local dual1 = Section:AddDualLabel({"State", "Nil"})
game:GetService("RunService").Heartbeat:Connect(function()
	dual1.Label2.Text = Entity.Humanoid:GetState().Name
end)
local fonts = {}
for i,v in pairs(Enum.Font:GetEnumItems()) do if v.Name ~= "Unknown" then table.insert(fonts, v.Name) end end
local Settings = Window:AddTab("Settings", {default = false})
local SettingsUISection = Settings:AddSection("UI", {Default = false})
SettingsUISection:AddDropdown("Font", fonts, {default = "SourceSans"}, function(selected)
	for _,element in pairs(Library.ScreenGui:GetDescendants()) do
		if element:IsA("TextLabel") or element:IsA("TextBox") or element:IsA("TextButton") then
			element.Font = selected
		end
	end
end)
SettingsUISection:AddPicker("Accent", {color = Color3.fromRGB(255, 0, 0)}, function(color)
	Window:SetAccent(color)
end)
local SettingsUISubSection1 = SettingsUISection:AddSubSection("Background", {Default = false})
SettingsUISubSection1:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool)
	Window.Frame.Background.Tabs.Holder.BackgroundTransparency = bool == true and 1 or 0
	Window.Frame.Background.Tabs.Holder.ImageBackGround.ImageTransparency = bool == true and 0 or 1
	Window.Frame.Background.Tabs.Holder.ImageBackGround.BackgroundTransparency = bool == true and 0 or 1
end)
local Method = "rbxassetid://"
local ID = ""
local textbox = SettingsUISubSection1:AddBox("ID", {fireonempty = false, clearonfocus = true}, function(text)
	Window.Frame.Background.Tabs.Holder.ImageBackGround.Image = Method..text
	ID = text
end)
SettingsUISubSection1:AddDropdown("Method", {"rbxassetid://", "http://www.roblox.com/asset/?id="}, {default = "rbxassetid://"}, function(selected)
	Method = selected
	if ID ~= "" then Window.Frame.Background.Tabs.Holder.ImageBackGround.Image = Method..ID end
end)
SettingsUISubSection1:AddDropdown("ScaleType", {"Crop", "Stretch"}, {default = "Crop"}, function(selected)
	Window.Frame.Background.Tabs.Holder.ImageBackGround.ScaleType = Enum.ScaleType[selected]
end)
SettingsUISubSection1:AddPicker("Color", {color = Color3.fromRGB(0, 0, 0)}, function(color)
	Window.Frame.Background.Tabs.Holder.ImageBackGround.BackgroundColor3 = color
end)
local SettingsUISubSection2 = SettingsUISection:AddSubSection("Extra", {Default = false})
SettingsUISubSection2:AddSlider("Stroke", 10, 100, 25, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(value, bool)
	Window.Frame.Handler.UIStroke.Enabled = bool
	Window.Frame.Handler.UIStroke.Thickness = value/10
end)
SettingsUISubSection2:AddSlider("Glow", 90, 150, 90, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(value, bool)
	Window:Glow(bool, value)
end)
SettingsUISubSection2:AddSlider("InnerGlow", 10, 100, 25, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(value, bool)
	Window.Frame.InnerGlow.Visible = bool
	Window.Frame.InnerGlow.Left.BackgroundTransparency = value/100
	Window.Frame.InnerGlow.Right.BackgroundTransparency = value/100
	Window.Frame.InnerGlow.Top.BackgroundTransparency = value/100
	Window.Frame.InnerGlow.Bottom.BackgroundTransparency = value/100
end)
