-- GOJO MM2 HUB V4
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PG = LP:WaitForChild("PlayerGui")

local RED = Color3.fromRGB(230, 20, 45)
local DARK = Color3.fromRGB(13, 13, 17)
local PANEL = Color3.fromRGB(27, 27, 34)
local WHITE = Color3.new(1,1,1)

local AimEnabled = false
local AimSmoothness = 0.15
local AimFOV = 250
local SpeedEnabled = false
local JumpEnabled = false

local old = PG:FindFirstChild("GOJO_V4")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GOJO_V4"
gui.ResetOnSpawn = false
gui.Parent = PG

local function corner(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

-- MAIN WINDOW

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromOffset(350,420)
main.Position = UDim2.new(.5,-175,.5,-210)
main.BackgroundColor3 = DARK
main.Active = true
corner(main,15)

local stroke = Instance.new("UIStroke",main)
stroke.Color = RED
stroke.Thickness = 2

-- HEADER

local header = Instance.new("TextLabel",main)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundColor3 = RED
header.Text = "GOJO MM2 HUB V4"
header.TextColor3 = WHITE
header.Font = Enum.Font.GothamBold
header.TextSize = 19
corner(header,12)

-- CLOSE BUTTON

local close = Instance.new("TextButton",main)
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-42,0,6)
close.Text = "X"
close.BackgroundColor3 = DARK
close.TextColor3 = WHITE
corner(close,8)

local floating = Instance.new("TextButton",gui)
floating.Size = UDim2.fromOffset(60,60)
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

-- DRAG WINDOW

local dragging
local dragStart
local startPos

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
    l.TextSize = 13
end

local function button(txt,callback)
    local b = Instance.new("TextButton",content)
    b.Size = UDim2.new(1,-12,0,40)
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

-- AIM SYSTEM
-- Camera aim assist for your own Studio game.

local function GetMurderer()

    if LP:GetAttribute("Role") ~= "Sheriff" then
        return nil
    end

    local target = nil
    local shortest = AimFOV

    for _,p in pairs(Players:GetPlayers()) do

        if p ~= LP
        and p:GetAttribute("Role") == "Murderer"
        and p.Character then

            local head = p.Character:FindFirstChild("Head")

            if head then

                local pos,visible =
                    Camera:WorldToViewportPoint(head.Position)

                local center = Camera.ViewportSize/2

                local distance = (
                    Vector2.new(pos.X,pos.Y)-center
                ).Magnitude

                if visible and distance < shortest then
                    shortest = distance
                    target = head
                end
            end
        end
    end

    return target
end

RunService.RenderStepped:Connect(function()

    if not AimEnabled then return end

    local target = GetMurderer()

    if target then

        local goal = CFrame.lookAt(
            Camera.CFrame.Position,
            target.Position
        )

        Camera.CFrame = Camera.CFrame:Lerp(
            goal,
            AimSmoothness
        )
    end

end)

-- TAB SYSTEM

local function showTab(name)

    clear()

    if name == "COMBAT" then

        label("SHERIFF AIM SYSTEM")

        button("AIM ASSIST ON / OFF",function()
            AimEnabled = not AimEnabled
        end)

        button("AIM SMOOTHNESS 0.3",function()
            AimSmoothness = 0.3
        end)

        button("AIM FOV 350",function()
            AimFOV = 350
        end)

        button("AIM FOV 150",function()
            AimFOV = 150
        end)

        label("COMBAT STATUS")

        button("VIEW MY ROLE",function()
            label("ROLE: "..tostring(
                LP:GetAttribute("Role") or "Unknown"
            ))
        end)

    elseif name == "VISUAL" then

        label("PLAYER VISUAL")

        button("PLAYER HIGHLIGHT",function()

            for _,p in pairs(Players:GetPlayers()) do

                if p ~= LP and p.Character then

                    local oldHighlight =
                        p.Character:FindFirstChild("GojoHighlight")

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

                    local h =
                        p.Character:FindFirstChild("GojoHighlight")

                    if h then h:Destroy() end

                end
            end
        end)

    elseif name == "MOVEMENT" then

        label("MOVEMENT CONTROL")

        button("SPEED 32",function()
            local
