local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local old = game:GetService("CoreGui"):FindFirstChild("GOJO_V2")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GOJO_V2"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = obj
end

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,270,0,360)
main.Position = UDim2.new(0.5,-135,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
corner(main,14)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(220,0,35)
stroke.Thickness = 2

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,48)
title.BackgroundColor3 = Color3.fromRGB(150,0,25)
title.Text = "GOJO  |  MM2 HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
corner(title,12)

local close = Instance.new("TextButton",main)
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-42,0,6)
close.Text = "X"
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(40,0,0)
close.TextColor3 = Color3.new(1,1,1)
corner(close,8)

local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,55,0,55)
open.Position = UDim2.new(0,15,0.5,-27)
open.Text = "GOJO"
open.TextSize = 14
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1,1,1)
open.BackgroundColor3 = Color3.fromRGB(170,0,30)
corner(open,15)
open.Visible = false

close.Activated:Connect(function()
    main.Visible = false
    open.Visible = true
end)

open.Activated:Connect(function()
    main.Visible = true
    open.Visible = false
end)

-- DRAG UI
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local content = Instance.new("Frame",main)
content.Position = UDim2.new(0,10,0,58)
content.Size = UDim2.new(1,-20,1,-68)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",content)
layout.Padding = UDim.new(0,8)

local function addButton(name,callback)
    local b = Instance.new("TextButton",content)
    b.Size = UDim2.new(1,0,0,42)
    b.BackgroundColor3 = Color3.fromRGB(35,35,43)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    corner(b,9)

    b.Activated:Connect(callback)
    return b
end

local speed = false
local jump = false

local function humanoid()
    local char = LP.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

addButton("SPEED : OFF",function(b)
end)

local speedButton
speedButton = addButton("⚡ SPEED : OFF",function()
    speed = not speed
    local h = humanoid()
    if h then h.WalkSpeed = speed and 32 or 16 end
    speedButton.Text = "⚡ SPEED : " .. (speed and "ON" or "OFF")
end)

local jumpButton
jumpButton = addButton("🚀 JUMP : OFF",function()
    jump = not jump
    local h = humanoid()
    if h then
        h.UseJumpPower = true
        h.JumpPower = jump and 75 or 50
    end
    jumpButton.Text = "🚀 JUMP : " .. (jump and "ON" or "OFF")
end)

addButton("📷 CAMERA FOV",function()
    workspace.CurrentCamera.FieldOfView = 90
end)

addButton("🔄 RESET SETTINGS",function()
    speed = false
    jump = false

    local h = humanoid()
    if h then
        h.WalkSpeed = 16
        h.JumpPower = 50
    end

    workspace.CurrentCamera.FieldOfView = 70

    speedButton.Text = "⚡ SPEED : OFF"
    jumpButton.Text = "🚀 JUMP : OFF"
end)

addButton("💀 RESET CHARACTER",function()
    local h = humanoid()
    if h then h.Health = 0 end
end)

-- ANTI AFK
local VirtualUser = game:GetService("VirtualUser")

LP.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

print("GOJO MM2 HUB V2 LOADED!")
