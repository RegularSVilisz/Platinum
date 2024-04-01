local Entity = {}

Entity.LocalPlayer = nil
Entity.Character = nil
Entity.Humanoid = nil
Entity.HumanoidRootPart = nil
Entity.Mouse = nil
Entity.IsAlive = nil
Entity.Backpack = nil

game:GetService("RunService").Heartbeat:Connect(function()
	Entity.LocalPlayer = game:GetService("Players") and game:GetService("Players").LocalPlayer ~= nil and game:GetService("Players").LocalPlayer or nil
	Entity.Character = Entity.LocalPlayer ~= nil and Entity.LocalPlayer and Entity.LocalPlayer.Character ~= nil and Entity.LocalPlayer.Character or nil
	Entity.Humanoid = Entity.Character ~= nil and Entity.Character:FindFirstChildWhichIsA("Humanoid") ~= nil and Entity.Character:FindFirstChildWhichIsA("Humanoid") or nil
	Entity.HumanoidRootPart = Entity.Humanoid ~= nil and Entity.Humanoid.RootPart or Entity.Character ~= nil and Entity.Character:FindFirstChild("HumanoidRootPart") ~= nil and Entity.Character:FindFirstChild("HumanoidRootPart") or Entity.Character ~= nil and Entity.Character.PrimaryPart ~= nil and Entity.Character.PrimaryPart or nil
	Entity.Mouse = Entity.LocalPlayer ~= nil and Entity.LocalPlayer:GetMouse() ~= nil and Entity.LocalPlayer:GetMouse() or nil
	Entity.IsAlive = Entity.Humanoid ~= nil and Entity.Humanoid.Health ~= 0 and true or Entity.Humanoid ~= nil and Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and true or false
	Entity.Backpack = Entity.LocalPlayer ~= nil and Entity.LocalPlayer:FindFirstChildWhichIsA("Backpack") ~= nil and Entity.LocalPlayer:FindFirstChildWhichIsA("Backpack") or nil
end)

return Entity