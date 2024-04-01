local Arraylist = {}

local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CG = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local SelfModules = {UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularSVilisz/Platinum/main/UI.lua"))()}
local Storage = { Connections = {}, Tween = { Cosmetic = {} } }

Arraylist.ScreenGui = {}

Arraylist.ScreenGui.UI = SelfModules.UI.Create("ScreenGui", {
	Name = "SVilisz Arraylist",
	DisplayOrder = 999,
	Enabled = true,
	ResetOnSpawn = false,

	SelfModules.UI.Create("Frame", {
		Name = "Main",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),

		SelfModules.UI.Create("UIListLayout", {
			Name = "UIListLayout",
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
			VerticalFlex = Enum.UIFlexAlignment.None,

		}),

		SelfModules.UI.Create("UIPadding", {
			Name = "UIPadding",
			PaddingBottom = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		}),

		SelfModules.UI.Create("Frame", {
			Name = "Frame",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0.119, 100, 1, 0),

			SelfModules.UI.Create("UIListLayout", {
				Name = "UIListLayout",
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalFlex = Enum.UIFlexAlignment.None,
				ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
				VerticalFlex = Enum.UIFlexAlignment.None, 
			}),
		}),

		SelfModules.UI.Create("TextLabel", {
			Name = "TextLabel",
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSans,
			RichText = true,
			Text = "",
			Visible = true,
			TextSize = 38,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
			TextStrokeTransparency = 0.85,

			--[[SelfModules.UI.Create("UIAspectRatioConstraint", {
				Name = "UIAspectRatioConstraint",
				AspectRatio = 4.057,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width,
			}),]]
		}),
	}),
})

Arraylist.ScreenGui.UI.Parent = CG

local Loops = {}

local ItemsList = {}

local Order = 2

function Arraylist:Add(ItemName, Table)
	if ItemsList[ItemName] then
		print("Item Already Exists")
		return
	end

	local Frame = Instance.new("Frame")
	local Frame_2 = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")

	ItemsList[ItemName] = {
		Frame = Frame,
		Frame_2 = Frame_2,
		TextLabel = TextLabel,
		UIListLayout = UIListLayout,
		Strings = {Left = Table.Strings.Left, Right = Table.Strings.Right, Space = Table.Strings.Space, Color2 = Table.Color2 or Color3.fromRGB(255, 255, 255)},
	}

	Frame.Parent = Arraylist.ScreenGui.UI.Main.Frame
	Frame.Size = UDim2.new(0,0,0,0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = Table.Background and 0.25 or 1
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Name = ItemName

	Frame_2.Parent = Frame
	Frame_2.BackgroundColor3 = Table.Color1 or Color3.fromRGB(255, 255, 255)
	Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame_2.BorderSizePixel = 0
	Frame_2.LayoutOrder = 2
	Frame_2.Position = UDim2.new(0.90336132, 0, 0, 0)
	Frame_2.Size = UDim2.new(0, 3, 1, 0)

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.LayoutOrder = 1
	TextLabel.Position = UDim2.new(0.0549490787, 0, 0, 0)
	TextLabel.Size = UDim2.new(1, 0, 0.5, 0)
	TextLabel.Font = Table.Font or Enum.Font.Unknown
	local BooleanSpace = Table.Strings and Table.Strings.Space ~= nil and typeof(Table.Strings.Space) == "boolean"
	TextLabel.Text = Table.Strings and string.format("%s<font color='%s'>%s</font>", Table.Strings.Left or "", SelfModules.UI.Color.ToFormat(Table.Color2 or Color3.fromRGB(255, 255, 255)), BooleanSpace == true and  " "..Table.Strings.Right or Table.Strings.Right or "")
	TextLabel.TextColor3 = Table.Color1 or Color3.fromRGB(255, 255, 255)
	TextLabel.TextStrokeTransparency = Table.Shadow ~= nil and Table.Shadow and 0.85 or 1
	TextLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	TextLabel.TextSize = 14
	TextLabel.RichText = true
	TextLabel.TextScaled = false
	TextLabel.TextXAlignment = Enum.TextXAlignment.Right

	UIListLayout.Parent = Frame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 5)

	local textBounds = TextLabel.TextBounds.X
	if Table.LayoutOrder then
		if Table.LayoutOrder == 1 then
			local firstLetter = string.sub(TextLabel.Text, 1, 1):upper()
			local layoutOrder = (string.byte(firstLetter) - string.byte('A')) + 1
			Frame.LayoutOrder = layoutOrder
		elseif Table.LayoutOrder == 2 then
			Frame.LayoutOrder = -textBounds
		end
	end

	local TweenItem = TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 30)})
	TweenItem:Play()
	TweenItem.Completed:Connect(function()
		Loops[ItemName] = RS.PreRender:Connect(function()
			TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, textBounds + 16, 0, 30)}):Play()
		end)
	end)

end

function Arraylist:Edit(ItemName, Table)
	if not ItemsList[ItemName] then
		return
	end

	local Frame = ItemsList[ItemName].Frame
	local TextLabel = ItemsList[ItemName].TextLabel
	local Frame_2 = ItemsList[ItemName].Frame_2

	if Table.Background ~= nil then
		local targetTransparency = Table.Background and 0.25 or 1
		if not Frame then return print("Frame is missing") end
		TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundTransparency = targetTransparency
		}):Play()
	end

	if Table.Shadow ~= nil then
		local target = Table.Shadow ~= nil and Table.Shadow and 0.85 or 1
		TS:Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			TextStrokeTransparency = target
		}):Play()
	end

	if Table.Color1 then
		TS:Create(Frame_2, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundColor3 = Table.Color1
		}):Play()
		game:GetService("TweenService"):Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			TextColor3 = Table.Color1
		}):Play()
	end

	if Table.Font then
		TextLabel.Font = Table.Font or TextLabel.Font
	end

	if Table.Strings then
		local BooleanSpace = Table.Strings and Table.Strings.Space and Table.Strings.Space == true and true or nil
		TextLabel.Text = Table.Strings and string.format("%s<font color='%s'>%s</font>", Table.Strings.Left or "", SelfModules.UI.Color.ToFormat(ItemsList[ItemName].Strings.Color2 or Color3.fromRGB(255, 255, 255)), BooleanSpace == true and  " "..Table.Strings.Right or Table.Strings.Right or "")
	end

	local textBounds = TextLabel.TextBounds.X
	if Table.LayoutOrder then
		if Table.LayoutOrder == 1 then
			local firstLetter = string.sub(TextLabel.Text, 1, 1):upper()
			local layoutOrder = (string.byte(firstLetter) - string.byte('A')) + 1
			Frame.LayoutOrder = layoutOrder
		elseif Table.LayoutOrder == 2 then
			Frame.LayoutOrder = -textBounds
		end
	end

	TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, textBounds + 16, 0, 30)}):Play()

end

function Arraylist:EditAll(Table)
	for _,item in pairs(ItemsList) do
		local Frame = item.Frame
		local TextLabel = item.TextLabel
		local Frame_2 = item.Frame_2

		if Table.Background ~= nil then
			local targetTransparency = Table.Background and 0.25 or 1
			if not Frame then return print("Frame is missing") end
			TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundTransparency = targetTransparency
			}):Play()
		end

		if Table.Shadow ~= nil then
			local target = Table.Shadow ~= nil and Table.Shadow and 0.85 or 1
			TS:Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				TextStrokeTransparency = target
			}):Play()
		end

		if Table.LeftColor then
			TS:Create(Frame_2, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundColor3 = Table.LeftColor
			}):Play()
		end

		TextLabel.Font = Table.Font or TextLabel.Font
		if Table.LeftColor then
			TS:Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				TextColor3 = Table.LeftColor
			}):Play()
		end

		if Table.RightColor then
			TextLabel.Text = string.format("%s<font color='%s'>%s</font>", item.Strings.Left or "", SelfModules.UI.Color.ToFormat(Table.RightColor or Color3.fromRGB(255, 255, 255)), item.Strings.Space == true and  " "..item.Strings.Right or item.Strings.Right or "")
		end

		local textBounds = TextLabel.TextBounds.X
		if Table.LayoutOrder then
			if Table.LayoutOrder == 1 then
				local firstLetter = string.sub(TextLabel.Text, 1, 1):upper()
				local layoutOrder = (string.byte(firstLetter) - string.byte('A')) + 1
				Frame.LayoutOrder = layoutOrder
			elseif Table.LayoutOrder == 2 then
				Frame.LayoutOrder = -textBounds
			end
		end
		
		TS:Create(Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, textBounds + 16, 0, 30)}):Play()
	end
end

function Arraylist:Remove(ItemName, Tween)

	if ItemsList[ItemName] then
		local Frame = ItemsList[ItemName].Frame
		Loops[ItemName]:Disconnect()
		ItemsList[ItemName] = nil
		if Tween ~= nil then
			wait()
			local TweenItem1 = TS:Create(Frame, TweenInfo.new(Tween.Speed, Tween.Style, Tween.Direction), {Size = UDim2.new(0,0,0,30)})
			TweenItem1:Play()
			TweenItem1.Completed:Connect(function()
				local TweenItem2 = TS:Create(Frame, TweenInfo.new(Tween.Speed, Tween.Style, Tween.Direction), {Size = UDim2.new(0,0,0,0)})
				TweenItem2:Play()
				TweenItem2.Completed:Connect(function()
					Frame:Destroy()
				end)
			end)
		else
			wait()
			Frame:Destroy()
		end
	end

end

function Arraylist:RemoveAll(Tween)

	for _,item in pairs(ItemsList) do
		local Frame = item.Frame
		for _,loopitem in pairs(Loops) do
			loopitem:Disconnect()
			ItemsList = {}
		end
		if Tween ~= nil then
			wait()
			local TweenItem1 = TS:Create(Frame, TweenInfo.new(Tween.Speed, Tween.Style, Tween.Direction), {Size = UDim2.new(0,0,0,30)})
			TweenItem1:Play()
			TweenItem1.Completed:Connect(function()
				local TweenItem2 = TS:Create(Frame, TweenInfo.new(Tween.Speed, Tween.Style, Tween.Direction), {Size = UDim2.new(0,0,0,0)})
				TweenItem2:Play()
				TweenItem2.Completed:Connect(function()
					Frame:Destroy()
				end)
			end)
		else
			item = nil
			table.clear(ItemsList)
			ItemsList = {}
			wait()
			Frame:Destroy()
		end
	end

end

function Arraylist:Layout(String)
	if String == "UnderLabel" then
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").HorizontalAlignment = Enum.HorizontalAlignment.Left
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").FillDirection = Enum.FillDirection.Vertical
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").HorizontalFlex = Enum.UIFlexAlignment.None
		Arraylist.ScreenGui.UI.Main:FindFirstChild("Frame"):FindFirstChild("UIListLayout").HorizontalAlignment = Enum.HorizontalAlignment.Left
		for _,item in pairs(ItemsList) do
			if item.UIListLayout then
				item.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
				item.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
				item.Frame_2.LayoutOrder = 1
				item.TextLabel.LayoutOrder = 2
				TS:Create(item.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, item.TextLabel.textBounds.X + 16, 0, 30)}):Play()
			end
		end
	end
	if String == "RightSided" then
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").HorizontalAlignment = Enum.HorizontalAlignment.Right
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").FillDirection = Enum.FillDirection.Horizontal
		Arraylist.ScreenGui.UI.Main:FindFirstChild("UIListLayout").HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		Arraylist.ScreenGui.UI.Main:FindFirstChild("Frame"):FindFirstChild("UIListLayout").HorizontalAlignment = Enum.HorizontalAlignment.Right
		for _,item in pairs(ItemsList) do
			if item.UIListLayout then
				item.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				item.TextLabel.TextXAlignment = Enum.TextXAlignment.Right
				item.Frame_2.LayoutOrder = 2
				item.TextLabel.LayoutOrder = 1
				TS:Create(item.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, item.TextLabel.textBounds.X + 16, 0, 30)}):Play()
			end
		end
	end
end

return Arraylist
