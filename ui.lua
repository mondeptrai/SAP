-- ui.lua
local petList = require(script.Parent.config)

-- Globals
getgenv().selectedPets    = {}
getgenv().autoBuySelected = false

local Players = game:GetService("Players")
local player  = Players.LocalPlayer

-- Tạo GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoBuyPetGUI"
local frame = Instance.new("Frame", gui)
frame.Position, frame.Size = UDim2.new(0,60,0,60), UDim2.new(0,350,0,450)
frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
frame.Active, frame.Draggable = true, true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,36); title.BackgroundTransparency = 1
title.Text = "Auto Buy Pet - Select Pet(s)"
title.Font = Enum.Font.GothamBold; title.TextColor3 = Color3.fromRGB(255,255,127); title.TextSize = 20

-- Scrolling list + layout
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position, scroll.Size = UDim2.new(0,10,0,46), UDim2.new(1,-20,1,-106)
scroll.BackgroundColor3 = Color3.fromRGB(40,40,40); scroll.ScrollBarThickness = 6
local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder, layout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0,4)
scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y)
end)

-- Fill checkboxes
for rarity,pets in pairs(petList) do
    -- Rarity label
    local rl = Instance.new("TextLabel", scroll)
    rl.Size = UDim2.new(1,0,0,24); rl.BackgroundTransparency = 1
    rl.Text, rl.Font, rl.TextSize, rl.TextXAlignment = rarity, Enum.Font.GothamBold, 18, Enum.TextXAlignment.Left
    rl.TextColor3 = (rarity=="Divine"   and Color3.fromRGB(156,93,246))
                 or (rarity=="Secret"   and Color3.fromRGB(255,174,0))
                 or (rarity=="Exclusive"and Color3.fromRGB(0,255,174))
                 or (rarity=="Mythical" and Color3.fromRGB(255,215,0))
                 or Color3.fromRGB(255,125,125)
    -- Pet buttons
    for _,name in ipairs(pets) do
        local cb = Instance.new("TextButton", scroll)
        cb.Size = UDim2.new(1,0,0,28); cb.BackgroundColor3 = Color3.fromRGB(48,48,48)
        cb.Text, cb.Font, cb.TextSize, cb.TextXAlignment = "[ ] "..name, Enum.Font.Gotham, 15, Enum.TextXAlignment.Left
        cb.TextColor3 = Color3.fromRGB(255,255,255)
        cb.MouseButton1Click:Connect(function()
            if getgenv().selectedPets[name] then
                getgenv().selectedPets[name] = nil; cb.Text = "[ ] "..name
            else
                getgenv().selectedPets[name] = true; cb.Text = "[✓] "..name
            end
        end)
    end
end

-- Toggle button
local toggle = Instance.new("TextButton", frame)
toggle.Size, toggle.Position = UDim2.new(0,150,0,36), UDim2.new(0.5,-75,1,-44)
toggle.BackgroundColor3 = Color3.fromRGB(156,40,40)
toggle.Font, toggle.TextSize = Enum.Font.GothamBold, 18
toggle.TextColor3, toggle.Text = Color3.fromRGB(255,255,255), "AUTO BUY: OFF"
toggle.MouseButton1Click:Connect(function()
    getgenv().autoBuySelected = not getgenv().autoBuySelected
    if getgenv().autoBuySelected then
        toggle.Text = "AUTO BUY: ON"; toggle.BackgroundColor3 = Color3.fromRGB(31,198,91)
    else
        toggle.Text = "AUTO BUY: OFF"; toggle.BackgroundColor3 = Color3.fromRGB(156,40,40)
    end
end)

-- Close button
local close = Instance.new("TextButton", frame)
close.Size, close.Position = UDim2.new(0,24,0,24), UDim2.new(1,-28,0,6)
close.Text, close.Font, close.TextSize = "✖", Enum.Font.GothamBold, 18
close.TextColor3, close.BackgroundColor3 = Color3.fromRGB(255,100,100), Color3.fromRGB(44,44,44)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
