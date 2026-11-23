local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "GOJO_MM2"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,150)
frame.Position = UDim2.new(0.5,-110,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(180,0,0)
title.Text = "GOJO MM2 HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18

local button = Instance.new("TextButton",frame)
button.Position = UDim2.new(0,10,0,55)
button.Size = UDim2.new(1,-20,0,35)
button.Text = "SPEED 32"
button.MouseButton1Click:Connect(function()
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 32 end
end)

local close = Instance.new("TextButton",frame)
close.Position = UDim2.new(0,10,0,100)
close.Size = UDim2.new(1,-20,0,35)
close.Text = "CLOSE"
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
