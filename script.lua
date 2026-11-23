-- GOJO HUB V5 | MM2 TEST EDITION
-- Roblox Studio - LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "GOJO_HUB_V5"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 390)
main.Position = UDim2.new(0.5, -150, 0.5, -195)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(220, 0, 40)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(100, 0, 20)
title.Text = "GOJO HUB V5"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

local function button(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Parent = main
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local aim = false
local esp = false
local fovEnabled = false

button("AIM ASSIST: OFF", 60, function()
    aim = not aim
end)

button("MURDERER ESP: OFF", 105, function()
    esp = not esp
end)

button("FOV CIRCLE: OFF", 150, function()
    fovEnabled = not fovEnabled
end)

button("SPEED +", 195, function()
    local h = player.Character and
        player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 24 end
end)

button("JUMP +", 240, function()
    local h = player.Character and
        player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 65 end
end)

button("RESET MOVEMENT", 285, function()
    local h = player.Character and
        player.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = 16
        h.JumpPower = 50
    end
end)

local close = button("CLOSE HUB", 330, function()
    main.Visible = false
end)

local floating = Instance.new("TextButton")
floating.Size = UDim2.fromOffset(55,55)
floating.Position = UDim2.new(0,15,0.5,0)
floating.Text = "GOJO"
floating.BackgroundColor3 = Color3.fromRGB(130,0,30)
floating.TextColor3 = Color3.new(1,1,1)
floating.Parent = gui
Instance.new("UICorner", floating).CornerRadius = UDim.new(1,0)

floating.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Drag UI
local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
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
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- FOV visualization
local circle = Instance.new("Frame")
circle.Size = UDim2.fromOffset(180,180)
circle.AnchorPoint = Vector2.new(0.5,0.5)
circle.Position = UDim2.fromScale(0.5,0.5)
circle.BackgroundTransparency = 1
circle.Visible = false
circle.Parent = gui

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(255,0,50)
circleStroke.Thickness = 2
circleStroke.Parent = circle

Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

-- Role-based test aim assist
RunService.RenderStepped:Connect(function()
    circle.Visible = fovEnabled

    if not aim then return end

    if player:GetAttribute("Role") ~= "Sheriff" then
        return
    end

    local target

    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player
        and other:GetAttribute("Role") == "Murderer"
        and other.Character then

            local root = other.Character:FindFirstChild("HumanoidRootPart")
            local hum = other.Character:FindFirstChildOfClass("Humanoid")

            if root and hum and hum.Health > 0 then
                target = root
                break
            end
        end
    end

    if target then
        local desired = CFrame.lookAt(
            camera.CFrame.Position,
            target.Position
        )

        camera.CFrame = camera.CFrame:Lerp(desired, 0.08)
    end
end)

-- ESP for test game
local highlights = {}

RunService.Heartbeat:Connect(function()
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local char = other.Character

            if esp and other:GetAttribute("Role") == "Murderer" and char then
                if not highlights[other] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255,0,0)
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.Parent = char
                    highlights[other] = hl
                end
            elseif highlights[other] then
                highlights[other]:Destroy()
                highlights[other] = nil
            end
        end
    end
end)
