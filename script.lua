local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local PG = LP:WaitForChild("PlayerGui")

local old = PG:FindFirstChild("GOJO_V3")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GOJO_V3"
gui.ResetOnSpawn = false
gui.Parent = PG

local RED = Color3.fromRGB(220,20,45)
local DARK = Color3.fromRGB(13,13,17)
local PANEL = Color3.fromRGB(24,24,30)
local WHITE = Color3.new(1,1,1)

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = o
end

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromOffset(340,390)
main.Position = UDim2.new(.5,-170,.5,-195)
main.BackgroundColor3 = DARK
main.Active = true
corner(main,14)

local stroke = Instance.new("UIStroke",main)
stroke.Color = RED
stroke.Thickness = 2

local header = Instance.new("TextLabel",main)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundColor3 = RED
header.Text = "GOJO MM2 HUB  V3"
header.TextColor3 = WHITE
header.Font = Enum.Font.GothamBold
header.TextSize = 19
corner(header,12)

local close = Instance.new("TextButton",main)
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-42,0,6)
close.Text = "X"
close.BackgroundColor3 = DARK
close.TextColor3 = WHITE
corner(close,8)

local floating = Instance.new("TextButton",gui)
floating.Size = UDim2.fromOffset(55,55)
floating.Position = UDim2.new(0,15,.5,0)
floating.Text = "GOJO"
floating.TextColor3 = WHITE
floating.BackgroundColor3 = RED
floating.Font = Enum.Font.GothamBold
floating.Visible = false
corner(floating,15)

close.Activated:Connect(function()
    main.Visible = false
    floating.Visible = true
end)

floating.Activated:Connect(function()
    main.Visible = true
    floating.Visible = false
end)

-- DRAG
local dragging, dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function()
    dragging = false
end)

-- SIDEBAR
local sidebar = Instance.new("Frame",main)
sidebar.Position = UDim2.fromOffset(8,58)
sidebar.Size = UDim2.new(0,105,1,-68)
sidebar.BackgroundColor3 = PANEL
corner(sidebar,10)

local sideLayout = Instance.new("UIListLayout",sidebar)
sideLayout.Padding = UDim.new(0,5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT
local content = Instance.new("ScrollingFrame",main)
content.Position = UDim2.fromOffset(121,58)
content.Size = UDim2.new(1,-130,1,-68)
content.BackgroundColor3 = PANEL
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(content,10)

local layout = Instance.new("UIListLayout",content)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function clear()
    for _,v in pairs(content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= layout then
            v:Destroy()
        end
    end
end

local function label(txt)
    local l = Instance.new("TextLabel",content)
    l.Size = UDim2.new(1,-12,0,35)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = RED
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
end

local function button(txt,callback)
    local b = Instance.new("TextButton",content)
    b.Size = UDim2.new(1,-12,0,38)
    b.BackgroundColor3 = Color3.fromRGB(42,42,50)
    b.Text = txt
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    corner(b,8)
    b.Activated:Connect(callback)
    return b
end

local function getHumanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local tabs = {}

local function showTab(name)
    clear()

    if name == "COMBAT" then
        label("COMBAT STATUS")

        button("VIEW MY ROLE",function()
            local role = LP:GetAttribute("Role") or "Unknown"
            label("ROLE: "..tostring(role))
        end)

        button("VIEW ALIVE PLAYERS",function()
            local n = 0
            for _,p in pairs(Players:GetPlayers()) do
                local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then n += 1 end
            end
            label("ALIVE: "..n)
        end)

    elseif name == "VISUAL" then
        label("VISUAL SETTINGS")

        button("PLAYER HIGHLIGHT ON/OFF",function()
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local oldHighlight = p.Character:FindFirstChild("GojoHighlight")
                    if oldHighlight then
                        oldHighlight:Destroy()
                    else
                        local h = Instance.new("Highlight")
                        h.Name = "GojoHighlight"
                        h.FillColor = RED
                        h.OutlineColor = WHITE
                        h.Parent = p.Character
                    end
                end
            end
        end)

        button("REMOVE HIGHLIGHTS",function()
            for _,p in pairs(Players:GetPlayers()) do
                if p.Character then
                    local h = p.Character:FindFirstChild("GojoHighlight")
                    if h then h:Destroy() end
                end
            end
        end)

    elseif name == "MOVEMENT" then
        label("MOVEMENT CONTROL")

        button("SPEED 32",function()
            local h = getHumanoid()
            if h then h.WalkSpeed = 32 end
        end)

        button("SPEED 50",function()
            local h = getHumanoid()
            if h then h.WalkSpeed = 50 end
        end)

        button("NORMAL SPEED",function()
            local h = getHumanoid()
            if h then h.WalkSpeed = 16 end
        end)

        button("JUMP POWER 75",function()
            local h = getHumanoid()
            if h then
                h.UseJumpPower = true
                h.JumpPower = 75
            end
        end)

        button("NORMAL JUMP",function()
            local h = getHumanoid()
            if h then h.JumpPower = 50 end
        end)

    elseif name == "FARM" then
        label("COIN STATISTICS")

        button("REFRESH COIN COUNTER",function()
            local stats = LP:FindFirstChild("leaderstats")
            if stats then
                for _,v in pairs(stats:GetChildren()) do
                    if v:IsA("IntValue") or v:IsA("NumberValue") then
                        label(v.Name..": "..v.Value)
                    end
                end
            else
                label("NO LEADERSTATS FOUND")
            end
        end)

    elseif name == "WEAPON" then
        label("INVENTORY INFORMATION")

        button("SHOW INVENTORY",function()
            local count = 0
            for _,v in pairs(LP.Backpack:GetChildren()) do
                count += 1
                label(v.Name)
            end
            label("TOTAL ITEMS: "..count)
        end)

    elseif name == "SETTINGS" then
        label("HUB SETTINGS")

        button("FOV 90",function()
            workspace.CurrentCamera.FieldOfView = 90
        end)

        button("FOV 70",function()
            workspace.CurrentCamera.FieldOfView = 70
        end)

        button("RESET CHARACTER",function()
            local h = getHumanoid()
            if h then h.Health = 0 end
        end)

        button("RESET MOVEMENT",function()
            local h = getHumanoid()
            if h then
                h.WalkSpeed = 16
                h.JumpPower = 50
            end
        end)
    end
end

local names = {
    "COMBAT",
    "VISUAL",
    "MOVEMENT",
    "FARM",
    "WEAPON",
    "SETTINGS"
}

for _,name in ipairs(names) do
    local b = Instance.new("TextButton",sidebar)
    b.Size = UDim2.new(1,-8,0,42)
    b.BackgroundColor3 = Color3.fromRGB(40,20,25)
    b.Text = name
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    corner(b,8)

    b.Activated:Connect(function()
        showTab(name)
    end)
end

showTab("COMBAT")

print("GOJO MM2 HUB V3 LOADED")
