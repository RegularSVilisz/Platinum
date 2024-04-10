local Entity = {}

local networkownerswitch=tick()local isnetworkowner=function(part)local suc,res=pcall(function()return gethiddenproperty(part,"NetworkOwnershipRule")end);if(suc)and(res)==(Enum.NetworkOwnership.Manual)then sethiddenproperty(part,"NetworkOwnershipRule",Enum.NetworkOwnership.Automatic)networkownerswitch=tick()+8;end;return(networkownerswitch<=tick());end

Entity.LocalPlayer = nil
Entity.Character = nil
Entity.Humanoid = nil
Entity.HumanoidRootPart = nil
Entity.Mouse = nil
Entity.IsAlive = nil
Entity.Backpack = nil
Entity.Camera = nil
Entity.HeartBeat = game:GetService("RunService").Heartbeat:Connect(function()
	local Players = game:GetService("Players") or game:FindFirstChild("Players") or game.Players or nil
	local workSpace = game:GetService("Workspace") or game:FindFirstChild("Workspace") or game.Workspace or workspace or nil
	Entity.LocalPlayer = Players and Players.LocalPlayer ~= nil and Players.LocalPlayer or nil
	Entity.Character = Entity.LocalPlayer ~= nil and Entity.LocalPlayer and Entity.LocalPlayer.Character ~= nil and Entity.LocalPlayer.Character or nil
	Entity.Humanoid = Entity.Character ~= nil and Entity.Character:FindFirstChild("Humanoid") ~= nil and Entity.Character:FindFirstChild("Humanoid") or Entity.Character:FindFirstChildWhichIsA("Humanoid") ~= nil and Entity.Character:FindFirstChildWhichIsA("Humanoid") or nil
	Entity.HumanoidRootParts = Entity.Humanoid ~= nil and Entity.Humanoid.RootPart ~= nil and Entity.Humanoid.RootPart or Entity.Character ~= nil and Entity.Character:FindFirstChild("HumanoidRootPart") ~= nil and Entity.Character:FindFirstChild("HumanoidRootPart") or Entity.Character ~= nil and Entity.Character.PrimaryPart ~= nil and Entity.Character.PrimaryPart or nil
	Entity.Mouse = Entity.LocalPlayer ~= nil and Entity.LocalPlayer:GetMouse() ~= nil and Entity.LocalPlayer:GetMouse() or nil
	Entity.IsAlive = Entity.Humanoid ~= nil and Entity.Humanoid.Health ~= 0 and true or Entity.Humanoid ~= nil and Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and true or false
	Entity.Backpack = Entity.LocalPlayer ~= nil and Entity.LocalPlayer:FindFirstChild("Backpack") ~= nil and Entity.LocalPlayer:FindFirstChild("Backpack") or Entity.LocalPlayer:FindFirstChildWhichIsA("Backpack") ~= nil and Entity.LocalPlayer:FindFirstChildWhichIsA("Backpack") or nil
	Entity.Camera = workSpace ~= nil and workSpace.CurrentCamera ~= nil and workSpace.CurrentCamera or workSpace:FindFirstChildWhichIsA("Camera") ~= nil and workSpace:FindFirstChildWhichIsA("Camera") or nil
end)

return Entity
