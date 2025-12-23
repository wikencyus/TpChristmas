local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MamiTeleportPanel"
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.35, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Header (Drag Area)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.BorderSizePixel = 0
header.Active = true

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🎄 Christmas Teleport"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Button Goa
local btnGoa = Instance.new("TextButton", main)
btnGoa.Size = UDim2.new(0.9, 0, 0, 40)
btnGoa.Position = UDim2.new(0.05, 0, 0, 60)
btnGoa.Text = "Teleport Christmas Goa"
btnGoa.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
btnGoa.TextColor3 = Color3.new(1, 1, 1)
btnGoa.Font = Enum.Font.Gotham
btnGoa.TextSize = 13
btnGoa.BorderSizePixel = 0
Instance.new("UICorner", btnGoa).CornerRadius = UDim.new(0, 10)

-- Button Christmas
local btnChristmas = Instance.new("TextButton", main)
btnChristmas.Size = UDim2.new(0.9, 0, 0, 40)
btnChristmas.Position = UDim2.new(0.05, 0, 0, 110)
btnChristmas.Text = "Teleport Christmas"
btnChristmas.BackgroundColor3 = Color3.fromRGB(70, 200, 130)
btnChristmas.TextColor3 = Color3.new(1, 1, 1)
btnChristmas.Font = Enum.Font.Gotham
btnChristmas.TextSize = 13
btnChristmas.BorderSizePixel = 0
Instance.new("UICorner", btnChristmas).CornerRadius = UDim.new(0, 10)

-- Fungsi Drag System
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

-- Teleport Functions
btnGoa.MouseButton1Click:Connect(function()
    local success, errorMsg = pcall(function()
        hrp.CFrame = CFrame.new(537, -581, 8896)
    end)
    
    if not success then
        warn("Teleport failed: " .. errorMsg)
    end
end)

btnChristmas.MouseButton1Click:Connect(function()
    local success, errorMsg = pcall(function()
        hrp.CFrame = CFrame.new(672, 5, 1607)
    end)
    
    if not success then
        warn("Teleport failed: " .. errorMsg)
    end
end)

-- Close Button (Optional tambahan)
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

return gui