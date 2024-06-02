local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVilisz/Platinum/main/scriptdrakein.lua"))()

local Window = Library:AddWindow({
	title = {"SVilisz", game.PlaceId == 3851622790 and "Break In (Lobby)" or game.PlaceId == 4620170611 and "Break In (Main)" or "Universal"},
	theme = {
		Accent = Color3.fromRGB(85, 38, 198)
	},
	key = Enum.KeyCode.RightAlt,
	default = false
})

local Fonts = {}
for _,v in pairs(Enum.Font:GetEnumItems()) do
	if v ~= Enum.Font.Unknown then
		table.insert(Fonts, v.Name)
	end
end

local Connections = {}
local List = {
	LocalPlayer = {
		Character = {
			WalkSpeed = {
				Value = 16,
				Function = function(Self, bool)
					if bool == true and Connections.WalkSpeed == nil then
						Connections.WalkSpeed = game:GetService("RunService").Heartbeat:Connect(function()
							if bool == true and game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
								local movevec = game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Unit
								movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new(0, 0, 0)
								local newvelo = movevec * Self.Value
								game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Velocity.Y, newvelo.Z)
							end
						end)
					elseif bool == false and Connections.WalkSpeed ~= nil then
						Connections.WalkSpeed:Disconnect()
						Connections.WalkSpeed = nil
					end
				end,
			},
			JumpPower = {
				Value = 16,
				Function = function(Self, bool)
					if bool == true and Connections.JumpPower == nil then
						Connections.JumpPower = game:GetService("RunService").Heartbeat:Connect(function()
							warn("JumpPower")
							if bool == true and game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
								local newy = Self.Value
								if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):GetState() == Enum.HumanoidStateType.Jumping then
									game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.X, newy, game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Z)
								end
							end
						end)
					elseif bool == false and Connections.JumpPower then
						Connections.JumpPower:Disconnect()
						Connections.JumpPower = nil
					end
				end,
			},
			FieldOfView = {
				Value = 16,
				OldValue = nil,
				Function = function(Self, bool)
					if bool == true and Connections.FieldOfView == nil then
						Connections.FieldOfView = game:GetService("RunService").Heartbeat:Connect(function()
							warn("FieldOfView")
							if bool == true and game:GetService("Workspace").CurrentCamera ~= nil then
								local newfov = Self.Value
								if Self.OldValue == nil then Self.OldValue = game:GetService("Workspace").CurrentCamera.FieldOfView end
								game:GetService("Workspace").CurrentCamera.FieldOfView = newfov
							end
						end)
					elseif bool == false and Connections.FieldOfView then
						Connections.FieldOfView:Disconnect()
						Connections.FieldOfView = nil
						if game:GetService("Workspace").CurrentCamera ~= nil then
							game:GetService("Workspace").CurrentCamera.FieldOfView = Self.OldValue
							Self.OldValue = nil
						end
					end
				end,
			},
			Gravity = {
				Value = 16,
				OldValue = nil,
				Function = function(Self, bool)
					if bool == true and Connections.Gravity == nil then
						Connections.Gravity = game:GetService("RunService").Heartbeat:Connect(function()
							warn("Gravity")
							if bool == true and game:GetService("Workspace").Gravity then
								local newgrav = Self.Value
								if Self.OldValue == nil then Self.OldValue = game:GetService("Workspace").Gravity end
								game:GetService("Workspace").Gravity = newgrav
							end
						end)
					elseif bool == false and Connections.Gravity then
						Connections.Gravity:Disconnect()
						Connections.Gravity = nil
						if game:GetService("Workspace").Gravity then
							game:GetService("Workspace").Gravity = Self.OldValue
							Self.OldValue = nil
						end
					end
				end,
			},
			InfJumps = {
				Function = function(bool)
					if bool == true then
						Connections.InfJumps = game:GetService("UserInputService").JumpRequest:Connect(function()
							if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
								game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							end
						end)
					elseif bool == false and Connections.InfJumps then
						Connections.InfJumps:Disconnect()
					end
				end,
			},
			NoClip = {
				List = {},
				Function = function(Self, bool)
					if bool == true then
						Connections.NoClip = game:GetService("RunService").Stepped:Connect(function()
							if game:GetService("Players").LocalPlayer.Character ~= nil then
								for i, part in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
									if part:IsA("BasePart") and part.CanCollide then
										Self.List[part] = true
										part.CanCollide = false
									end
								end
							end
						end)
					elseif bool == false and Connections.NoClip then
						Connections.NoClip:Disconnect()
						for i,v in pairs(Self.List) do if i then i.CanCollide = true end end
						table.clear(Self.List)
					end
				end,
			},
		},
	},
	Utilities = {
		Utilities = {
			BasementDoor = {
				Function = function()
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
						game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Basement")
					end
				end,
			},
			AtticDoor = {
				Function = function()
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
						game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Attic")
					end
				end,
			},
			FrontDoor = {
				Function = function()
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
						game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Front")
					end
				end,
			},
			BypassPadLock = {
				Function = function()
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PadlockDetector") ~= nil then
						game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PadlockDetector"):FireServer(game:GetService("Players").LocalPlayer)
					end
				end,
			},
			FriendCat = {
				Function = function()
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery") ~= nil then
						game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery"):FireServer()
					end
				end,
			},
			InfinitePlanks = {
				Function = function(bool)
					if bool == true then
						Connections.InfinitePlanks = game:GetService("RunService").PreSimulation:Connect(function()
							if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RefreshPlanks") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RefreshPlanks"):FireServer()
							end
						end)
					elseif bool == false and Connections.InfinitePlanks then
						Connections.InfinitePlanks:Disconnect()
					end
				end,
			},
			LoopBasementDoor = {
				Function = function(bool)
					if bool == true then
						Connections.LoopBasementDoor = game:GetService("RunService").PreRender:Connect(function()
							if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Basement")
							end
						end)
					elseif bool == false and Connections.LoopBasementDoor then
						Connections.LoopBasementDoor:Disconnect()
					end
				end,
			},
			LoopAtticDoor = {
				Function = function(bool)
					if bool == true then
						Connections.LoopAtticDoor = game:GetService("RunService").PreRender:Connect(function()
							if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Attic")
							end
						end)
					elseif bool == false and Connections.LoopAtticDoor then
						Connections.LoopAtticDoor:Disconnect()
					end
				end,
			},
			LoopFrontDoor = {
				Function = function(bool)
					if bool == true then
						Connections.LoopFrontDoor = game:GetService("RunService").PreRender:Connect(function()
							if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Door"):FireServer("Front")
							end
						end)
					elseif bool == false and Connections.LoopFrontDoor then
						Connections.LoopFrontDoor:Disconnect()
					end
				end,
			},
			LoopDrawers = {
				Function = function(bool)
					if bool == true then
						Connections.LoopDrawers = game:GetService("RunService").PreRender:Connect(function()
							if game:GetService("Workspace"):FindFirstChild("Drawers") ~= nil and fireclickdetector then
								for _,v in pairs(game:GetService("Workspace"):FindFirstChild("Drawers"):GetDescendants()) do
									if v:IsA("ClickDetector") and v.Name == "Drawer" then
										fireclickdetector(v)
									end
								end
							end
						end)
					elseif bool == false and Connections.LoopDrawers then
						Connections.LoopDrawers:Disconnect()
					end
				end,
			},
			Healing = {
				Enabled = {
					Function = function(bool, method, speed, health)
						if bool == true then
							Connections.PlayerAutoHeal = game:GetService("RunService").PreRender:Connect(function()
								if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Energy") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BedTime") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("GiveTool") ~= nil then
									if method == "Cat" then
										for i = 1, speed do
											game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Energy"):FireServer("Cat")
											game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BedTime"):FireServer()
										end
									elseif method == "Eat" then
										for i = 1, speed do
											game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("GiveTool"):FireServer("Cookie")
											game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Energy"):FireServer(15, "Cookie")
										end
									end
								end
							end)
						elseif bool == false and Connections.PlayerAutoHeal then
							Connections.PlayerAutoHeal:Disconnect()
						end
					end,
				},
				HealthRate = {
					Enabled = false,
					Value = 100,
				},
				Speed = {
					Value = 1,
				},
				Method = {
					Selected = "Cat",
				},
			},
			Enemies = {
				Enabled = {
					Function = function(bool, damage, distance)
						if bool == true then
							Connections.BadGuysKillAura = game:GetService("RunService").PreRender:Connect(function()
								if game:GetService("Workspace"):FindFirstChild("BadGuys") ~= nil then
									for _,v in pairs(game:GetService("Workspace"):FindFirstChild("BadGuys"):GetChildren()) do
										if v ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("HitBadguy") ~= nil then
											if distance.Enabled == true and game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
												local DistanceBetween = (game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.HumanoidRootPart.Position).Magnitude
												if DistanceBetween > distance.Distance then
													game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("HitBadguy"):FireServer(v, damage)
												end
											else
												game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("HitBadguy"):FireServer(v, damage)
											end
										end
									end
								end
							end)
						elseif bool == false and Connections.BadGuysKillAura then
							Connections.BadGuysKillAura:Disconnect()
						end
					end,
				},
				Damage = {
					Value = 0,
				},
				Distance = {
					Enabled = false,
					Value = 0,
				},
			},
			Features = {
				UnlockEggPortal = {
					Function = function()
						for i = 1,3 do
							if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("EggHuntEvent") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("EggHuntEvent"):FireServer(2, "IcePart1")
							end
						end
					end
				},
				UnlockBasement = {
					Function = function()
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor"):FireServer()
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission"):FireServer()
						end
					end,
				},
				UnlockAttic = {
					Function = function()
						if fireclickdetector and game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil and game:GetService("Workspace"):FindFirstChild("Basement") ~= nil and game:GetService("Workspace"):FindFirstChild("Basement"):FindFirstChild("Ladder") ~= nil and game:GetService("Workspace"):FindFirstChild("Basement"):FindFirstChild("Ladder"):FindFirstChild("ClickDetector") ~= nil then
							fireclickdetector(game:GetService("Workspace"):FindFirstChild("Basement"):FindFirstChild("Ladder"):FindFirstChild("ClickDetector"))
							game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-20.21592140197754, 20.379079818725586, -227.04872131347656)
						end
					end,
				},
				OpenSafe = {
					Function = function()
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Safe") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked"):FireServer("rbxassetid://3195645674")
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked"):FireServer("rbxassetid://3195645922")
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked"):FireServer("http://www.roblox.com/asset/?id=363240671")
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked"):FireServer("http://www.roblox.com/asset/?id=178210631")
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("PaintingClicked"):FireServer("http://www.roblox.com/asset/?id=3246691515")
							if game:GetService("Workspace"):FindFirstChild("CodeNote") ~= nil and game:GetService("Workspace"):FindFirstChild("CodeNote"):FindFirstChild("SurfaceGui") ~= nil and game:GetService("Workspace"):FindFirstChild("CodeNote"):FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Safe"):FireServer(game:GetService("Workspace"):FindFirstChild("CodeNote"):FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").Text)
							end
						end
					end,
				},
			},
		},
		Items = {
			Select = {
				selected = "Chips",
			},
			Amount = {
				Value = 1,
			},
			Give = {
				Function = function(String, Amount)
					if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("GiveTool") ~= nil then
						if String == "BloxyCola" or String == "Cookie" or String == "Apple" then
							for i = 1,Amount do
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("GiveTool"):FireServer(String)
							end
						elseif String == "Hammer" then
							game:GetService("ReplicatedStorage").RemoteEvents.BasementWeapon:FireServer(true, "Hammer")
						else
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("GiveTool"):FireServer(String)
						end
					end
				end,
			},
		},
		Trolling = {
			KillOthers = {
				Username = {
					Text = "",
				},
				Kill = {
					Function = function(String)
						for _,v in pairs(game:GetService("Players"):GetPlayers()) do
							if v ~= game:GetService("Players").LocalPlayer and v.Name:lower():find(String:lower()) == 1 or v.DisplayName:lower():find(String:lower()) == 1 and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("ToxicDrown") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("ToxicDrown"):FireServer(1, v)
							end
						end
					end,
				},
				KillAll = {
					Function = function()
						for _,v in pairs(game:GetService("Players"):GetPlayers()) do
							if v ~= game:GetService("Players").LocalPlayer and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("ToxicDrown") ~= nil then
								game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("ToxicDrown"):FireServer(1, v)
							end
						end
					end,
				},
			},
			Server = {
				Lag = {
					Function = function(bool)
						if bool == true then
							Connections.LagServer = game:GetService("RunService").Heartbeat:Connect(function()
								if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission") ~= nil then
									game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery"):FireServer()
									game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor"):FireServer()
									game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission"):FireServer()
								end
							end)
						elseif bool == false and Connections.LagServer then
							Connections.LagServer:Disconnect()
						end
					end,
				},
				Crash = {
					Enabled = false,
					Function = function()
						if Connections.CrashServer == nil then
							Library:Notify({title = "Crash", text = "This action is permanet, Click accept to start.", duration = 10, color = Color3.fromRGB(255, 100, 100)}, function(bool2)
								if bool2 == true then
									Library:Notify({title = "Crash", text = "Starting.", duration = 1.5, color = Color3.fromRGB(100, 255, 100)})
									task.wait(math.random(1,3))
									Connections.CrashServer = game:GetService("RunService").Heartbeat:Connect(function()
										if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission") ~= nil then
											for i = 1,10 do
												game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("Cattery"):FireServer()
												game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("UnlockDoor"):FireServer()
												game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("BasementMission"):FireServer()
											end
										end
									end)
								end
							end)
						end
					end,
				},
			},
		},
		Roles = {
			Role = {
				Stealthy = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("TeddyBloxpin", bool)
						end
					end,
				},
				Hungry = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("Chips", bool)
						end
					end,
				},
				Lollipop = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("Lollipop", bool)
						end
					end,
				},
				Fighter = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("Sword", bool)
						end
					end,
				},
				Officer = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("Gun", bool)
						end
					end,
				},
				Medic = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("MedKit", bool)
						end
					end,
				},
				Protector = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("Bat", bool)
						end
					end,
				},
				Swat = {
					Function = function(bool)
						if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents") ~= nil and game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole") ~= nil then
							game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("OutsideRole"):FireServer("SwatGun", bool)
						end
					end,
				},
			},
			Avatar = {
				Enabled = false,
			},
		},
		Lobby = {
			BypassBadgeGaurd = {}, -- Toggle
		}, -- Section
	}, -- Tab
	Visual = {
		Chams = {
			Players = {
				Enabled = {
					Function = function(Self, bool)
						if bool == true then
							Connections.PlayersCham = game:GetService("RunService").Heartbeat:Connect(function()
								for _,v in pairs(game:GetService("Players"):GetPlayers()) do
									if v.Character ~= nil then
										if v.Character:FindFirstChild(v.Name.."_Chams") == nil then
											local Chams = Instance.new("Highlight")
											Chams.Name = v.Name.."_Chams"
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
											Chams.Parent = v.Character
										else
											local Chams = v.Character:FindFirstChild(v.Name.."_Chams")
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
										end
									end
								end
							end)
						elseif bool == false and Connections.PlayersCham then
							Connections.PlayersCham:Disconnect()
							for _,v in pairs(game:GetService("Players"):GetPlayers()) do
								if v.Character ~= nil then
									if v.Character:FindFirstChild(v.Name.."_Chams") ~= nil then
										v.Character:FindFirstChild(v.Name.."_Chams"):Destroy()
									end
								end
							end
						end
					end,
				},
				FillTransparency = {
					Value = 0,
				},
				FillColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				OutlineTransparency = {
					Value = 0,
				},
				OutlineColor = {
					Coloe = Color3.fromRGB(255, 255, 255)
				},
			},
			Enemies = {
				Enabled = {
					Function = function(Self, bool)
						if bool == true then
							Connections.EnemiesCham = game:GetService("RunService").Heartbeat:Connect(function()
								for _,v in pairs(game:GetService("Workspace"):FindFirstChild("BadGuys"):GetChildren()) do
									if v ~= nil then
										if v:FindFirstChild(v.Name.."_Chams") == nil then
											local Chams = Instance.new("Highlight")
											Chams.Name = v.Name.."_Chams"
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
											Chams.Parent = v
										else
											local Chams = v:FindFirstChild(v.Name.."_Chams")
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
										end
									end
								end
							end)
						elseif bool == false and Connections.EnemiesCham then
							Connections.EnemiesCham:Disconnect()
							for _,v in pairs(game:GetService("Players"):GetPlayers()) do
								if v ~= nil then
									if v:FindFirstChild(v.Name.."_Chams") ~= nil then
										v:FindFirstChild(v.Name.."_Chams"):Destroy()
									end
								end
							end
						end
					end,
				},
				FillTransparency = {
					Value = 0,
				},
				FillColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				OutlineTransparency = {
					Value = 0,
				},
				OutlineColor = {
					Coloe = Color3.fromRGB(255, 255, 255)
				},
			},
			Items = {
				Enabled = {
					Function = function(Self, bool)
						if bool == true then
							Connections.ItemsCham = game:GetService("RunService").Heartbeat:Connect(function()
								for _,v in pairs(game:GetService("Workspace"):GetChildren()) do
									if v.Name == "Apple" or v.Name == "Apple2" or v.Name == "Apple3" or v.Name == "Cookie" or v.Name == "Cookie2" or v.Name == "Cookie3" or v.Name == "Money" or v.Name == "Money2" or v.Name == "Money3" or v.Name == "BloxyCola" or v.Name == "BloxyCola2" or v.Name == "BloxyCola3" then
										if v:FindFirstChild(v.Name.."_Chams") == nil then
											local Chams = Instance.new("Highlight")
											Chams.Name = v.Name.."_Chams"
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
											Chams.Parent = v
										else
											local Chams = v:FindFirstChild(v.Name.."_Chams")
											Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
											Chams.FillTransparency = Self.FillTransparency.Value
											Chams.FillColor = Self.FillColor.Color
											Chams.OutlineTransparency = Self.OutlineTransparency.Value
											Chams.OutlineColor = Self.OutlineColor.Color
										end
									end
								end
							end)
						elseif bool == false and Connections.ItemsCham then
							Connections.ItemsCham:Disconnect()
							for _,v in pairs(game:GetService("Players"):GetPlayers()) do
								if v ~= nil then
									if v:FindFirstChild(v.Name.."_Chams") ~= nil then
										v:FindFirstChild(v.Name.."_Chams"):Destroy()
									end
								end
							end
						end
					end,
				},
				FillTransparency = {
					Value = 0,
				},
				FillColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				OutlineTransparency = {
					Value = 0,
				},
				OutlineColor = {
					Coloe = Color3.fromRGB(255, 255, 255)
				},
			},
		},
		Tracer = {
			Players = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
			Enemies = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
			Items = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
		}, -- Section
		Boxes = {
			Players = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
			Enemies = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
			Items = {
				Enabled = {}, -- Toggle
				Transparency = {}, -- Slider
				Thickness = {}, -- Slider
				Color = {}, -- Picker
			}, -- SubSection
		}, -- Section
		Text = {
			Players = {
				Enabled = {
					Function = function(Self, bool)
						if bool == true then
							Connections.PlayersText = game:GetService("RunService").Heartbeat:Connect(function()
								for _,v in pairs(game:GetService("Players"):GetPlayers()) do
									if v.Character ~= nil and v.Character:FindFirstChild("Head") ~= nil then
										if v.Character:FindFirstChild("Head"):FindFirstChild(v.Name.."Text") == nil then
											local BillboardGui = Instance.new("BillboardGui")
											local TextLabel = Instance.new("TextLabel")
											local UIListLayout = Instance.new("UIListLayout")
											BillboardGui.Name = v.Name.."Text"
											BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											BillboardGui.Active = true
											BillboardGui.AlwaysOnTop = true
											BillboardGui.LightInfluence = 1.000
											BillboardGui.Size = UDim2.new(0, 200, 0, 50)
											BillboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
											BillboardGui.ResetOnSpawn = false
											TextLabel.Parent = BillboardGui
											TextLabel.BackgroundColor3 = Self.BackgroundColor.Color
											TextLabel.BackgroundTransparency = Self.Background.Enabled == true and 0.5 + (Self.Transparency.Value/2) or 1
											TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
											TextLabel.BorderSizePixel = 0
											TextLabel.Text = Self.DisplayName.Enabled == true and v.DisplayName or v.Name
											TextLabel.Size = UDim2.fromOffset(TextLabel.TextBounds.X + 43, TextLabel.TextBounds.Y + 17)
											TextLabel.Font = Enum.Font[Self.Fonts.Font]
											TextLabel.TextColor3 = Self.TextColor.Color
											TextLabel.TextSize = Self.Size.Value
											TextLabel.TextTransparency = Self.Transparency.Value
											TextLabel.TextStrokeTransparency = Self.Shadow.Enabled == true and 0.850 or 1
											UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
											UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
											UIListLayout.Parent = BillboardGui
											BillboardGui.Parent = v.Character:FindFirstChild("Head")
										else
											local BillboardGui = v.Character:FindFirstChild("Head"):FindFirstChild(v.Name.."Text")
											local TextLabel = BillboardGui:FindFirstChildWhichIsA("TextLabel")
											TextLabel.BackgroundColor3 = Self.BackgroundColor.Color
											TextLabel.BackgroundTransparency = Self.Background.Enabled == true and 0.5 + (Self.Transparency.Value/2) or 1
											TextLabel.Text = Self.DisplayName.Enabled == true and v.DisplayName or v.Name
											TextLabel.Size = UDim2.fromOffset(TextLabel.TextBounds.X + 43, TextLabel.TextBounds.Y + 17)
											TextLabel.Font = Enum.Font[Self.Fonts.Font]
											TextLabel.TextColor3 = Self.TextColor.Color
											TextLabel.TextSize = Self.Size.Value
											TextLabel.TextTransparency = Self.Transparency.Value
											TextLabel.TextStrokeTransparency = Self.Shadow.Enabled == true and 0.850 or 1
										end
									end
								end
							end)
						elseif bool == false and Connections.PlayersText then
							Connections.PlayersText:Disconnect()
							for _,v in pairs(game:GetService("Players"):GetPlayers()) do
								if v.Character ~= nil and v.Character:FindFirstChild("Head") ~= nil then
									if v.Character:FindFirstChild("Head"):FindFirstChild(v.Name.."Text") ~= nil then
										v.Character:FindFirstChild("Head"):FindFirstChild(v.Name.."Text"):Destroy()
									end
								end
							end
						end
					end,
				},
				DisplayName = {
					Enabled = false,
				},
				Background = {
					Enabled = false,
				},
				Shadow = {
					Enabled = false,
				},
				Transparency = {
					Value = 0,
				},
				Size = {
					Value = 24,
				},
				TextColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				BackgroundColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				Fonts = {
					Font = "SourceSans",
				},
			},
			Enemies = {
				Enabled = {
					Function = function(Self, bool)
						if bool == true then
							Connections.EnemiesText = game:GetService("RunService").Heartbeat:Connect(function()
								if game:GetService("Workspace"):FindFirstChild("BadGuys") ~= nil then
									for _,v in pairs(game:GetService("Workspace"):FindFirstChild("BadGuys"):GetChildren()) do
										if v ~= nil and v:FindFirstChild("Head") ~= nil then
											if v:FindFirstChild("Head"):FindFirstChild(v.Name.."Text") == nil then
												local BillboardGui = Instance.new("BillboardGui")
												local TextLabel = Instance.new("TextLabel")
												local UIListLayout = Instance.new("UIListLayout")
												BillboardGui.Name = v.Name.."Text"
												BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
												BillboardGui.Active = true
												BillboardGui.AlwaysOnTop = true
												BillboardGui.LightInfluence = 1.000
												BillboardGui.Size = UDim2.new(0, 200, 0, 50)
												BillboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
												BillboardGui.ResetOnSpawn = false
												TextLabel.Parent = BillboardGui
												TextLabel.BackgroundColor3 = Self.BackgroundColor.Color
												TextLabel.BackgroundTransparency = Self.Background.Enabled == true and 0.5 + (Self.Transparency.Value/2) or 1
												TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
												TextLabel.BorderSizePixel = 0
												TextLabel.Text = "Enemie"
												TextLabel.Size = UDim2.fromOffset(TextLabel.TextBounds.X + 43, TextLabel.TextBounds.Y + 17)
												TextLabel.Font = Enum.Font[Self.Fonts.Font]
												TextLabel.TextColor3 = Self.TextColor.Color
												TextLabel.TextSize = Self.Size.Value
												TextLabel.TextTransparency = Self.Transparency.Value
												TextLabel.TextStrokeTransparency = Self.Shadow.Enabled == true and 0.850 or 1
												UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
												UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
												UIListLayout.Parent = BillboardGui
												BillboardGui.Parent = v:FindFirstChild("Head")
											else
												local BillboardGui = v:FindFirstChild("Head"):FindFirstChild(v.Name.."Text")
												local TextLabel = BillboardGui:FindFirstChildWhichIsA("TextLabel")
												TextLabel.BackgroundColor3 = Self.BackgroundColor.Color
												TextLabel.BackgroundTransparency = Self.Background.Enabled == true and 0.5 + (Self.Transparency.Value/2) or 1
												TextLabel.Text = "Enemie"
												TextLabel.Size = UDim2.fromOffset(TextLabel.TextBounds.X + 43, TextLabel.TextBounds.Y + 17)
												TextLabel.Font = Enum.Font[Self.Fonts.Font]
												TextLabel.TextColor3 = Self.TextColor.Color
												TextLabel.TextSize = Self.Size.Value
												TextLabel.TextTransparency = Self.Transparency.Value
												TextLabel.TextStrokeTransparency = Self.Shadow.Enabled == true and 0.850 or 1
											end
										end
									end
								end
							end)
						elseif bool == false and Connections.EnemiesText then
							Connections.EnemiesText:Disconnect()
							if game:GetService("Workspace"):FindFirstChild("BadGuys") ~= nil then
								for _,v in pairs(game:GetService("Workspace"):FindFirstChild("BadGuys"):GetChildren()) do
									if v ~= nil and v:FindFirstChild("Head") ~= nil then
										if v:FindFirstChild("Head"):FindFirstChild(v.Name.."Text") ~= nil then
											v:FindFirstChild("Head"):FindFirstChild(v.Name.."Text"):Destroy()
										end
									end
								end
							end
						end
					end,
				},
				Background = {
					Enabled = false,
				},
				Shadow = {
					Enabled = false,
				},
				Transparency = {
					Value = 0,
				},
				Size = {
					Value = 24,
				},
				TextColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				BackgroundColor = {
					Color = Color3.fromRGB(255, 255, 255),
				},
				Fonts = {
					Font = "SourceSans",
				},
			}, -- SubSection
			Items = {
				Enabled = {}, -- Toggle
				DisplayName = {}, -- Toggle
				Background = {}, -- Toggle
				Shadow = {}, -- Toggle
				Transparency = {}, -- Slider
				Size = {}, -- Slider
				TextColor = {}, -- Picker
				BackgroundColor = {}, -- Picker
				Fonts = {}, -- Dropdown
			}, -- SubSection
		}, -- Section
	}, -- Tab
	Teleport = {
		Locations = {},
		Players = {
			Username = {
				Text = "",
			},
			Teleport = {
				Function = function(String)
					for _,v in pairs(game:GetService("Players"):GetPlayers()) do
						if v ~= game:GetService("Players").LocalPlayer and v.Name:lower():find(String:lower()) == 1 or v.DisplayName:lower():find(String:lower()) == 1 then
							game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
						end
					end
				end,
			},
		},
	},
	Settings = {
		Credits = {
			CopyDiscord = {
				Function = function()
					if setclipboard then
						setclipboard("DiscordLink/Test")
					end
				end,
			},
		},
		Extras = {
			Bind = {
				Function = function(keycode)
					Window:SetKey(keycode)
				end,
			},
			RainbowUI = {
				Function = function(bool)
					if bool == true then
						Connections.RainbowUI = game:GetService("RunService").Heartbeat:Connect(function()
							Window:SetAccent((Color3.fromHSV(tick() % 5 / 5, 1, 1)))
						end)
					elseif bool == false and Connections.RainbowUI then
						Connections.RainbowUI:Disconnect()
						Window:SetAccent(Color3.fromRGB(85, 38, 198))
					end
				end,
			},
			DebugMode = {
				Enabled = false
			}
		},
	},
}

local LocalPlayer = Window:AddTab("LocalPlayer", {default = true})
local Character = LocalPlayer:AddSection("Character", {default = false})
local WalkSpeed = Character:AddSubSection("WalkSpeed", {default = false})
WalkSpeed:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.WalkSpeed.Function(List.LocalPlayer.Character.WalkSpeed, bool) end)
WalkSpeed:AddSlider("WalkSpeed", 0, 200, 16, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.LocalPlayer.Character.WalkSpeed.Value = val end)
local JumpPower = Character:AddSubSection("JumpPower", {default = false})
JumpPower:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.JumpPower.Function(List.LocalPlayer.Character.JumpPower, bool) end)
JumpPower:AddSlider("JumpPower", 0, 300, 50, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.LocalPlayer.Character.JumpPower.Value = val end)
local FieldOfView = Character:AddSubSection("FieldOfView", {default = false})
FieldOfView:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.FieldOfView.Function(List.LocalPlayer.Character.FieldOfView, bool) end)
FieldOfView:AddSlider("FieldOfView", 30, 120, 70, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.LocalPlayer.Character.FieldOfView.Value = val end)
local Gravity = Character:AddSubSection("Gravity", {default = false})
Gravity:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.Gravity.Function(List.LocalPlayer.Character.Gravity, bool) end)
Gravity:AddSlider("Gravity", 0, 196, 196, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.LocalPlayer.Character.Gravity.Value = val end)
local ExtraLocal = Character:AddSubSection("Extra", {default = false})
ExtraLocal:AddToggle("InfJumps", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.InfJumps.Function(bool) end)
ExtraLocal:AddToggle("NoClip", {flag = "Toggle_Flag", default = false}, function(bool) List.LocalPlayer.Character.NoClip.Function(List.LocalPlayer.Character.NoClip, bool) end)

local Utilities = Window:AddTab("Utilities", {default = false})
local UtilitiesFeatures = Utilities:AddSection("Utilities", {default = false})
UtilitiesFeatures:AddButton("Basement Door", function() List.Utilities.Utilities.BasementDoor.Function() end)
UtilitiesFeatures:AddButton("Attic Door", function() List.Utilities.Utilities.AtticDoor.Function() end)
UtilitiesFeatures:AddButton("Front Door", function() List.Utilities.Utilities.FrontDoor.Function() end)
UtilitiesFeatures:AddButton("Bypass PadLock", function() List.Utilities.Utilities.BypassPadLock.Function() end)
UtilitiesFeatures:AddButton("Friend Cat", function() List.Utilities.Utilities.FriendCat.Function() end)
UtilitiesFeatures:AddToggle("Infinite Planks", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.InfinitePlanks.Function(bool) end)
UtilitiesFeatures:AddToggle("Loop Basement Door", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.LoopBasementDoor.Function(bool) end)
UtilitiesFeatures:AddToggle("Loop Attic Door", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.LoopAtticDoor.Function(bool) end)
UtilitiesFeatures:AddToggle("Loop Front Door", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.LoopFrontDoor.Function(bool) end)
UtilitiesFeatures:AddToggle("Loop Drawers", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.LoopDrawers.Function(bool) end)
local Healing = UtilitiesFeatures:AddSubSection("Healing", {default = false})
Healing:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.Healing.Enabled.Function(bool, List.Utilities.Utilities.Healing.Method.Selected, List.Utilities.Utilities.Healing.Speed.Value, {Enabled = nil, Value = nil}) end)
Healing:AddSlider("Health Rate", 10, 100, 100, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val, bool) List.Utilities.Utilities.Healing.HealthRate.Enabled = bool; List.Utilities.Utilities.Healing.HealthRate.Value = val end)
Healing:AddSlider("Speed", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Utilities.Utilities.Healing.Speed.Value = val end)
Healing:AddDropdown("Method", {"Cat", "Eat"}, {default = "Cat"}, function(selected) List.Utilities.Utilities.Healing.Method.Selected = selected end)
local Enemies = UtilitiesFeatures:AddSubSection("Enemies", {default = false})
Enemies:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Utilities.Enemies.Enabled.Function(bool, List.Utilities.Utilities.Enemies.Damage.Value, {Distance = List.Utilities.Utilities.Enemies.Distance.Value, Enabled = List.Utilities.Utilities.Enemies.Distance.Enabled}) end)
Enemies:AddSlider("Damage", 1, 100, 20, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Utilities.Utilities.Enemies.Damage.Value = val end)
Enemies:AddSlider("Distance", 10, 100, 50, {toggleable = true, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val, bool) List.Utilities.Utilities.Enemies.Distance.Value = val; List.Utilities.Utilities.Enemies.Distance.Enabled = bool end)
local Features = UtilitiesFeatures:AddSubSection("Features", {default = false})
Features:AddButton("Unlock EggPortal", function() List.Utilities.Utilities.Features.UnlockEggPortal.Function() end)
Features:AddButton("Unlock Basement", function() List.Utilities.Utilities.Features.UnlockBasement.Function() end)
Features:AddButton("Unlock Attic", function() List.Utilities.Utilities.Features.UnlockAttic.Function() end)
Features:AddButton("Open Safe", function() List.Utilities.Utilities.Features.OpenSafe.Function() end)
local Items = Utilities:AddSection("Items", {default = false})
Items:AddDropdown("Select", {"Chips", "BloxyCola", "ExpiredBloxyCola", "Cookie", "Teddy", "Hammer", "Cure", "Plank", "Sword", "Key", "ExpiredPizza", "MiniPizza", "Pizza", "Medkit", "Apple", "Bat", "Lollipop"}, {default = "Chips"}, function(selected) List.Utilities.Items.Select.selected = selected end)
Items:AddSlider("Amount", 1, 100, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Utilities.Items.Amount.Value = val end)
Items:AddButton("Give", function() List.Utilities.Items.Give.Function(List.Utilities.Items.Select.selected, List.Utilities.Items.Amount.Value) end)
local Trolling = Utilities:AddSection("Trolling", {default = false})
local Kill = Trolling:AddSubSection("Kill Others", {default = false})
Kill:AddBox("Username", {clearonfocus = false, fireonempty = true}, function(String) List.Utilities.Trolling.KillOthers.Username.Text = String end)
Kill:AddButton("Kill", function() List.Utilities.Trolling.KillOthers.Kill.Function(List.Utilities.Trolling.KillOthers.Username.Text) end)
Kill:AddButton("Kill All", function() List.Utilities.Trolling.KillOthers.KillAll.Function() end)
local Server = Trolling:AddSubSection("Server", {default = false})
Server:AddToggle("Lag", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Trolling.Server.Lag.Function(bool) end)
Server:AddButton("Crash", function() List.Utilities.Trolling.Server.Crash.Function() end)
local Roles = Utilities:AddSection("Roles", {default = false})
local Role = Roles:AddSubSection("Role", {default = false})
Role:AddButton("Stealthy", function() List.Utilities.Roles.Role.Stealthy.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Hungry", function() List.Utilities.Roles.Role.Hungry.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Lollipop", function() List.Utilities.Roles.Role.Lollipop.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Fighter", function() List.Utilities.Roles.Role.Fighter.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Officer", function() List.Utilities.Roles.Role.Officer.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Medic", function() List.Utilities.Roles.Role.Medic.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Protector", function() List.Utilities.Roles.Role.Protector.Function(List.Utilities.Roles.Avatar.Enabled) end)
Role:AddButton("Swat", function() List.Utilities.Roles.Role.Swat.Function(List.Utilities.Roles.Avatar.Enabled) end)
Roles:AddToggle("Avatar", {flag = "Toggle_Flag", default = false}, function(bool) List.Utilities.Roles.Avatar.Enabled = bool end)
local Lobby = Utilities:AddSection("Lobby", {default = false})
Lobby:AddToggle("Bypass BadgeGaurd", {flag = "Toggle_Flag", default = false})

local Visual = Window:AddTab("Visual", {default = false})
local Chams = Visual:AddSection("Chams", {default = false})
local ChamsPlayer = Chams:AddSubSection("Players", {default = false})
ChamsPlayer:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Chams.Players.Enabled.Function(List.Visual.Chams.Players, bool) end)
ChamsPlayer:AddSlider("FillTransparency", 0, 100, 50, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Players.FillTransparency.Value = val / 100 end)
ChamsPlayer:AddPicker("FillColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Players.FillColor.Color = color end)
ChamsPlayer:AddSlider("OutlineTransparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Players.OutlineTransparency.Value = val / 100 end)
ChamsPlayer:AddPicker("OutlineColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Players.OutlineColor.Color = color end)
local ChamsEnemies = Chams:AddSubSection("Enemies", {default = false})
ChamsEnemies:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Chams.Enemies.Enabled.Function(List.Visual.Chams.Enemies, bool) end)
ChamsEnemies:AddSlider("FillTransparency", 0, 100, 50, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Enemies.FillTransparency.Value = val / 100 end)
ChamsEnemies:AddPicker("FillColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Enemies.FillColor.Color = color end)
ChamsEnemies:AddSlider("OutlineTransparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Enemies.OutlineTransparency.Value = val / 100 end)
ChamsEnemies:AddPicker("OutlineColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Enemies.OutlineColor.Color = color end)
local ChamsItems = Chams:AddSubSection("Items", {default = false})
ChamsItems:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Chams.Items.Enabled.Function(List.Visual.Chams.Items, bool) end)
ChamsItems:AddSlider("FillTransparency", 0, 100, 50, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Items.FillTransparency.Value = val / 100 end)
ChamsItems:AddPicker("FillColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Items.FillColor.Color = color end)
ChamsItems:AddSlider("OutlineTransparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Chams.Items.OutlineTransparency.Value = val / 100 end)
ChamsItems:AddPicker("OutlineColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Chams.Items.OutlineColor.Color = color end)
local Tracer = Visual:AddSection("Tracer", {default = false})
local TracerPlayer = Tracer:AddSubSection("Players", {default = false})
TracerPlayer:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
TracerPlayer:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerPlayer:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerPlayer:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local TracerEmenies = Tracer:AddSubSection("Emenies", {default = false})
TracerEmenies:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
TracerEmenies:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerEmenies:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerEmenies:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local TracerItems = Tracer:AddSubSection("Items", {default = false})
TracerItems:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
TracerItems:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerItems:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TracerItems:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local Boxes = Visual:AddSection("Boxes", {default = false})
local BoxesPlayer = Boxes:AddSubSection("Players", {default = false})
BoxesPlayer:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
BoxesPlayer:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesPlayer:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesPlayer:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local BoxesEmenies = Boxes:AddSubSection("Emenies", {default = false})
BoxesEmenies:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
BoxesEmenies:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesEmenies:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesEmenies:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local BoxesItems = Boxes:AddSubSection("Items", {default = false})
BoxesItems:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
BoxesItems:AddSlider("Transparency", 0, 100, 100, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesItems:AddSlider("Thickness", 1, 10, 1, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
BoxesItems:AddPicker("Color", {color = Color3.fromRGB(255, 255, 255)})
local Text = Visual:AddSection("Text", {default = false})
local TextPlayer = Text:AddSubSection("Players", {default = false})
TextPlayer:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Players.Enabled.Function(List.Visual.Text.Players, bool) end)
TextPlayer:AddToggle("DisplayName", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Players.DisplayName.Enabled = bool end)
TextPlayer:AddToggle("Background", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Players.Background.Enabled = bool end)
TextPlayer:AddToggle("Shadow", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Players.Shadow.Enabled = bool end)
TextPlayer:AddSlider("Transparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Text.Players.Transparency.Value = val / 100 end)
TextPlayer:AddSlider("Size", 8, 100, 14, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Text.Players.Size.Value = val end)
TextPlayer:AddPicker("TextColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Text.Players.TextColor.Color = color end)
TextPlayer:AddPicker("BackgroundColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Text.Players.BackgroundColor.Color = color end)
TextPlayer:AddDropdown("Font", Fonts, {default = "SourceSans"}, function(selected) List.Visual.Text.Players.Fonts.Font = selected end)
local TextEnemies = Text:AddSubSection("Emenies", {default = false})
TextEnemies:AddToggle("Enabled", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Enemies.Enabled.Function(List.Visual.Text.Enemies, bool) end)
TextEnemies:AddToggle("Background", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Enemies.Background.Enabled = bool end)
TextEnemies:AddToggle("Shadow", {flag = "Toggle_Flag", default = false}, function(bool) List.Visual.Text.Enemies.Shadow.Enabled = bool end)
TextEnemies:AddSlider("Transparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Text.Enemies.Transparency.Value = val / 100 end)
TextEnemies:AddSlider("Size", 8, 100, 14, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true}, function(val) List.Visual.Text.Enemies.Size.Value = val end)
TextEnemies:AddPicker("TextColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Text.Enemies.TextColor.Color = color end)
TextEnemies:AddPicker("BackgroundColor", {color = Color3.fromRGB(255, 255, 255)}, function(color) List.Visual.Text.Enemies.BackgroundColor.Color = color end)
TextEnemies:AddDropdown("Font", Fonts, {default = "SourceSans"}, function(selected) List.Visual.Text.Enemies.Fonts.Font = selected end)
local TextItems = Text:AddSubSection("Items", {default = false})
TextItems:AddToggle("Enabled", {flag = "Toggle_Flag", default = false})
TextItems:AddToggle("Background", {flag = "Toggle_Flag", default = false})
TextItems:AddToggle("Shadow", {flag = "Toggle_Flag", default = false})
TextItems:AddSlider("Transparency", 0, 100, 0, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TextItems:AddSlider("Size", 8, 100, 14, {toggleable = false, default = false, flag = "Slider_Flag", fireontoggle = true, fireondrag = true, rounded = true})
TextItems:AddPicker("TextColor", {color = Color3.fromRGB(255, 255, 255)})
TextItems:AddPicker("BackgroundColor", {color = Color3.fromRGB(255, 255, 255)})
TextItems:AddDropdown("Font", Fonts, {default = "SourceSans"})

local Teleport = Window:AddTab("Teleport", {default = false})
local Locations = Teleport:AddSection("Locations", {default = false})
Locations:AddLabel("Not Really Ready, Maybe Later?")
local Players = Teleport:AddSection("Players", {default = false})
Players:AddBox("Username", {clearonfocus = false, fireonempty = true}, function(String) List.Teleport.Players.Username.Text = String end)
Players:AddButton("Teleport", function() List.Teleport.Players.Teleport.Function(List.Teleport.Players.Username.Text) end)

local Settings = Window:AddTab("Settings", {default = false})
local Credits = Settings:AddSection("Credits", {default = true})
Credits:AddDualLabel({"Founder & Script Leader", "RegularSVilisz#7789"})
Credits:AddButton("Copy Discord", function() List.Settings.Credits.CopyDiscord.Function() end)
local Extras = Settings:AddSection("Extras", {default = false})
Extras:AddBind("Bind", Enum.KeyCode.RightAlt, {toggleable = false, default = false, flag = "Bind_Flag"}, function(Key) List.Settings.Extras.Bind.Function(Key) end)
Extras:AddToggle("Rainbow UI", {flag = "Toggle_Flag", default = false}, function(bool) List.Settings.Extras.RainbowUI.Function(bool) end)
Extras:AddToggle("Debug Mode (Disabled)", {flag = "Toggle_Flag", default = false}, function(bool) List.Settings.Extras.DebugMode.Enabled = bool end)

Window:Toggle(true)
