local Verification = {State = false}

-- Services

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local TXS = game:GetService("TextService")
local HS = game:GetService("HttpService")
local CG = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Variables

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local SelfModules = {UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVilisz/Platinum/main/UI.lua"))()}
local Storage = { Connections = {}, Items = {}, Tween = { Cosmetic = {} } }
local StartedVerify = false

local ScreenGui = SelfModules.UI.Create("ScreenGui", {
	Name = "SVilisz UI Verification",
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local VerifiyMenu

function Verification:Start(options, KeySystem)
	if KeySystem and typeof(KeySystem) == "string" and not StartedVerify then
		StartedVerify = true

		VerifiyMenu = {
			Type = "VerifiyMenu",
			Selection = nil,
			Callback = nil,
		}

		local VerifiyListModifier = SelfModules.UI.Create("UIListLayout", {
			Name = "Modifier",
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		VerifiyMenu.Frame = SelfModules.UI.Create("Frame", {
			Name = "Window",
			Size = UDim2.new(0, 325, 0, 330),
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),

			SelfModules.UI.Create("Frame", {
				Name = "Handler",
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				BorderSizePixel = 0,

				SelfModules.UI.Create("UICorner", {
					Name = "UICorner",
					CornerRadius = UDim.new(0, 12),
				}),

				SelfModules.UI.Create("Frame", {
					Name = "TextBox",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 260, 0, 51),
					Position = UDim2.new(0, 31,0, 154),
					BorderSizePixel = 0,

					SelfModules.UI.Create("TextBox", {
						Name = "Box",
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 226, 0, 20),
						Position = UDim2.new(0, 6,0, 24),
						Font = Enum.Font.SourceSans,
						PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
						PlaceholderText = "Key",
						Text = "",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						ClearTextOnFocus = false,
						TextSize = 15.000,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
					}),

					SelfModules.UI.Create("Frame", {
						Name = "Fill",
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						Position = UDim2.new(0, 0, 0, 48),
						Size = UDim2.new(1, 0, 0, 2),
						BorderSizePixel = 0,

						SelfModules.UI.Create("Frame", {
							Name = "ActualFill",
							BackgroundColor3 = Color3.fromRGB(70,70,70),
							Size = UDim2.new(0, 0, 0, 2),
							BorderSizePixel = 0,

							SelfModules.UI.Create("UICorner", {
								Name = "UICorner",
								CornerRadius = UDim.new(1, 0),
							}),
						}),
					}),

					SelfModules.UI.Create("ImageButton", {
						Name = "Submit",
						Image = "rbxassetid://9243354333",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 234,0, 24),
						Rotation = 270.000,
						Size = UDim2.new(0, 20, 0, 20),
						BorderSizePixel = 0,
					}),
				}),

				SelfModules.UI.Create("Frame", {
					Name = "Icon",
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					Size = UDim2.new(0, 95, 0, 95),
					Position = UDim2.new(0, 113,0, 35),
					BorderSizePixel = 0,

					SelfModules.UI.Create("UICorner", {
						Name = "UICorner",
						CornerRadius = UDim.new(1, 0),
					}),

					SelfModules.UI.Create("ImageLabel", {
						Name = "ImageLabel",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 3, 0, 3),
						Size = UDim2.new(1, -6, 1, -6),
						Image = "http://www.roblox.com/asset/?id=14211860571",
						BorderSizePixel = 0,

						SelfModules.UI.Create("UICorner", {
							Name = "UICorner",
							CornerRadius = UDim.new(1, 0),
						}),
					}),
				}),

				SelfModules.UI.Create("Frame", {
					Visible = options ~= nil and options.Invite ~= nil and typeof(options.Invite) == "string" and true or false,
					Name = "Discord",
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					Position = UDim2.new(0, 32,0, 235),
					Size = UDim2.new(0, 260, 0, 62),
					BorderSizePixel = 0,

					SelfModules.UI.Create("Frame", {
						Name = "Button",
						BackgroundColor3 = Color3.fromRGB(98, 111, 252),
						Position = UDim2.new(0, 16,0, 13),
						Size = UDim2.new(0, 223, 0, 34),
						ZIndex = 2,

						SelfModules.UI.Create("TextButton", {
							Name = "TextButton",
							BackgroundColor3 = Color3.fromRGB(88, 101, 242),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							Font = Enum.Font.SourceSansBold,
							Text = "Join Discord Server",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 15.000,
							AutoButtonColor = false,
							ZIndex = 3,

							SelfModules.UI.Create("UICorner", {
								Name = "UICorner",
								CornerRadius = UDim.new(0, 6),
							}),
						}),

						SelfModules.UI.Create("UICorner", {
							Name = "UICorner",
							CornerRadius = UDim.new(0, 6),
						}),
					}),

					SelfModules.UI.Create("Frame", {
						Name = "View",
						BackgroundColor3 = Color3.fromRGB(30, 30, 30),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),
						BorderSizePixel = 0,

						SelfModules.UI.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 71,0, -13),
							Size = UDim2.new(0, 115, 0, 20),
							Font = Enum.Font.SourceSans,
							Text = "How Do I Get Key?",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 14.000,
							ZIndex = 2,
							BorderSizePixel = 0,

							SelfModules.UI.Create("UIStroke", {
								Name = "UIStroke",
								Thickness = 0.8,
								Color = Color3.fromRGB(35, 35, 35),
							}),
						}),

						SelfModules.UI.Create("Frame", {
							Name = "Liner",
							BackgroundColor3 = Color3.fromRGB(30, 30, 30),
							Position = UDim2.new(0, 60,0, -2),
							Size = UDim2.new(0, 130, 0, 2),
							BorderSizePixel = 0,

							SelfModules.UI.Create("UIStroke", {
								Name = "UIStroke",
								Color = Color3.fromRGB(30, 30, 30)
							})
						}),

						SelfModules.UI.Create("UICorner", {
							Name = "UICorner",
							CornerRadius = UDim.new(0, 14),
						}),
					}),

					SelfModules.UI.Create("UICorner", {
						Name = "UICorner",
						CornerRadius = UDim.new(0, 14),
					}),

					SelfModules.UI.Create("UIStroke", {
						Name = "UIStroke",
						Thickness = 0.8,
						Color = Color3.fromRGB(35, 35, 35),
					}),

				}),
			}),

			SelfModules.UI.Create("UICorner", {
				Name = "UICorner",
				CornerRadius = UDim.new(0, 12),
			}),
		})

		VerifiyListModifier.Parent = ScreenGui
		VerifiyMenu.Frame.Parent = ScreenGui

		local Tinfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local Tinfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

		if options and options.Invite ~= nil and typeof(options.Invite) == "string" then
			VerifiyMenu.Frame.Handler.Discord.Visible = true
			Storage.Connections.MouseEnter2 = VerifiyMenu.Frame.Handler.Discord.Button.TextButton.MouseEnter:Connect(function()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button.TextButton, Tinfo2, { BackgroundColor3 = Color3.fromRGB(68, 81, 222) }):Play()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button, Tinfo2, { BackgroundColor3 = Color3.fromRGB(78, 91, 232) }):Play()
			end)

			Storage.Connections.MouseLeave2 = VerifiyMenu.Frame.Handler.Discord.Button.TextButton.MouseLeave:Connect(function()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button.TextButton, Tinfo2, { BackgroundColor3 = Color3.fromRGB(88, 101, 242) }):Play()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button, Tinfo2, { BackgroundColor3 = Color3.fromRGB(98, 111, 252) }):Play()
			end)

			Storage.Connections.MouseButton1Down2 = VerifiyMenu.Frame.Handler.Discord.Button.TextButton.MouseButton1Down:Connect(function()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button.TextButton, Tinfo2, { BackgroundColor3 = Color3.fromRGB(48, 61, 202) }):Play()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button, Tinfo2, { BackgroundColor3 = Color3.fromRGB(58, 71, 212) }):Play()
			end)

			Storage.Connections.MouseButton1Up2 = VerifiyMenu.Frame.Handler.Discord.Button.TextButton.MouseButton1Up:Connect(function()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button.TextButton, Tinfo2, { BackgroundColor3 = Color3.fromRGB(88, 101, 242) }):Play()
				T:Create(VerifiyMenu.Frame.Handler.Discord.Button, Tinfo2, { BackgroundColor3 = Color3.fromRGB(98, 111, 252) }):Play()
			end)

			local CurrentlyState = false

			Storage.Connections.MouseButton1Click2 = VerifiyMenu.Frame.Handler.Discord.Button.TextButton.MouseButton1Click:Connect(function()
				if CurrentlyState == false then
					CurrentlyState = true
					if setclipboard then
						setclipboard(options.Invite)
						VerifiyMenu.Frame.Handler.Discord.Button.TextButton.Text = "Discord Link Copied"
					else
						VerifiyMenu.Frame.Handler.Discord.Button.TextButton.Text = "Try Again Later"
					end
					wait(1)
					VerifiyMenu.Frame.Handler.Discord.Button.TextButton.Text = "Join Discord Server"
					CurrentlyState = false
				end
			end)
		end

		local function Finished(KeyCheck)
			if KeyCheck == KeySystem then
				for i,v in pairs(Storage.Connections) do
					if v then v:Disconnect() end
				end
				T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { ImageColor3 = Color3.fromRGB(255,255,255) }):Play()
				if VerifiyMenu.Frame.Handler.TextBox.Submit.Rotation ~= 270 then
					T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { Rotation = 270 }):Play()
				end
				task.wait(1)
				if ScreenGui then ScreenGui:Destroy() end
				Verification.State = true
			end
		end

		Storage.Connections.Focus = VerifiyMenu.Frame.Handler.TextBox.Box.Focused:Connect(function()
			if VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill and VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill.Parent == VerifiyMenu.Frame.Handler.TextBox.Fill then
				T:Create(VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill, Tinfo2, { Size = UDim2.new(1,0,0,2) }):Play()
			end
		end)

		Storage.Connections.LostFocus = VerifiyMenu.Frame.Handler.TextBox.Box.FocusLost:Connect(function()

		end)

		Storage.Connections.TextChanged = R.Heartbeat:Connect(function()
			if VerifiyMenu.Frame.Handler.TextBox.Box then
				if VerifiyMenu.Frame.Handler.TextBox.Box.Text == KeySystem then
					T:Create(VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill, Tinfo2, { BackgroundColor3 = Color3.fromRGB(125,255,125) }):Play()
				elseif VerifiyMenu.Frame.Handler.TextBox.Box.Text ~= "" then
					T:Create(VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill, Tinfo2, { BackgroundColor3 = Color3.fromRGB(255,125,125) }):Play()
				else
					T:Create(VerifiyMenu.Frame.Handler.TextBox.Fill.ActualFill, Tinfo2, { BackgroundColor3 = Color3.fromRGB(70,70,70) }):Play()
				end
			end
		end)

		Storage.Connections.MouseEnter1 = VerifiyMenu.Frame.Handler.TextBox.Submit.MouseEnter:Connect(function()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { ImageColor3 = Color3.fromRGB(200,200,200) }):Play()
		end)

		Storage.Connections.MouseLeave1 = VerifiyMenu.Frame.Handler.TextBox.Submit.MouseLeave:Connect(function()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { ImageColor3 = Color3.fromRGB(255,255,255) }):Play()
			if VerifiyMenu.Frame.Handler.TextBox.Submit.Rotation ~= 270 then
				T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { Rotation = 270 }):Play()
			end
		end)

		Storage.Connections.MouseButton1Down1 = VerifiyMenu.Frame.Handler.TextBox.Submit.MouseButton1Down:Connect(function()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { ImageColor3 = Color3.fromRGB(125,125,125) }):Play()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { Rotation = 280 }):Play()
		end)

		Storage.Connections.MouseButton1Up1 = VerifiyMenu.Frame.Handler.TextBox.Submit.MouseButton1Up:Connect(function()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { ImageColor3 = Color3.fromRGB(200,200,200) }):Play()
			T:Create(VerifiyMenu.Frame.Handler.TextBox.Submit, Tinfo2, { Rotation = 270 }):Play()
		end)

		Storage.Connections.MouseButton1Click1 = VerifiyMenu.Frame.Handler.TextBox.Submit.MouseButton1Click:Connect(function()
			if VerifiyMenu.Frame.Handler.TextBox.Box and VerifiyMenu.Frame.Handler.TextBox.Box.Text == KeySystem then
				Finished(VerifiyMenu.Frame.Handler.TextBox.Box.Text)
			end
		end)
	end
end

ScreenGui.Parent = CG

return Verification
