-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Player
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MamiTeleportPanel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 220) -- Diperbesar untuk tombol tambahan
main.Position = UDim2.new(0.35, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Header (Drag Area)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

-- Button Container
local buttonContainer = Instance.new("Frame", main)
buttonContainer.Size = UDim2.new(1, 0, 1, -40)
buttonContainer.Position = UDim2.new(0, 0, 0, 40)
buttonContainer.BackgroundTransparency = 1

-- Button Goa
local btnGoa = Instance.new("TextButton", buttonContainer)
btnGoa.Size = UDim2.new(0.9, 0, 0, 35)
btnGoa.Position = UDim2.new(0.05, 0, 0, 15)
btnGoa.Text = "Teleport Christmas Goa"
btnGoa.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
btnGoa.TextColor3 = Color3.new(1, 1, 1)
btnGoa.Font = Enum.Font.Gotham
btnGoa.TextSize = 13
btnGoa.BorderSizePixel = 0
Instance.new("UICorner", btnGoa).CornerRadius = UDim.new(0, 8)

-- Button Christmas
local btnChristmas = Instance.new("TextButton", buttonContainer)
btnChristmas.Size = UDim2.new(0.9, 0, 0, 35)
btnChristmas.Position = UDim2.new(0.05, 0, 0, 60)
btnChristmas.Text = "Teleport Christmas"
btnChristmas.BackgroundColor3 = Color3.fromRGB(70, 200, 130)
btnChristmas.TextColor3 = Color3.new(1, 1, 1)
btnChristmas.Font = Enum.Font.Gotham
btnChristmas.TextSize = 13
btnChristmas.BorderSizePixel = 0
Instance.new("UICorner", btnChristmas).CornerRadius = UDim.new(0, 8)

-- Button Teleport ke Tobelii_20
local btnTobelli = Instance.new("TextButton", buttonContainer)
btnTobelli.Size = UDim2.new(0.9, 0, 0, 35)
btnTobelli.Position = UDim2.new(0.05, 0, 0, 105)
btnTobelli.Text = "Teleport to Tobelii_20"
btnTobelli.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
btnTobelli.TextColor3 = Color3.new(1, 1, 1)
btnTobelli.Font = Enum.Font.Gotham
btnTobelli.TextSize = 13
btnTobelli.BorderSizePixel = 0
Instance.new("UICorner", btnTobelli).CornerRadius = UDim.new(0, 8)

-- Status Label
local statusLabel = Instance.new("TextLabel", buttonContainer)
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
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

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
minimizeBtn.Text = "_"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

-- Drag System Variables
local dragging = false
local dragInput
local dragStart
local startPos
local isMinimized = false

-- Fungsi untuk mendapatkan HRP dengan aman
local function getHRP()
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp
        end
    end
    return nil
end

-- Fungsi untuk menemukan player Tobelii_20
local function findTobelliPlayer()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Name == "Tobelii_20" then
            return targetPlayer
        end
    end
    return nil
end

-- Fungsi untuk mendapatkan posisi player target
local function getPlayerPosition(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
        
        -- Jika tidak ada HRP, coba cari bagian tubuh lain
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            local torso = targetPlayer.Character:FindFirstChild("Torso") or 
                          targetPlayer.Character:FindFirstChild("UpperTorso")
            if torso then
                return torso.Position
            end
        end
    end
    return nil
end

-- Fungsi untuk teleport dengan safety check
local function safeTeleport(cframe)
    local hrp = getHRP()
    if hrp then
        local success, errorMsg = pcall(function()
            hrp.CFrame = cframe
        end)
        
        if success then
            statusLabel.Text = "Status: Teleported!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Reset status setelah 2 detik
            task.delay(2, function()
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end)
        else
            statusLabel.Text = "Status: Failed - " .. tostring(errorMsg):sub(1, 30)
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            task.delay(3, function()
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end)
        end
    else
        statusLabel.Text = "Status: Waiting for character..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        -- Coba lagi setelah character load
        player.CharacterAdded:Wait()
        task.wait(0.5)
        safeTeleport(cframe)
    end
end

-- Fungsi untuk teleport ke player Tobelii_20
local function teleportToTobelli()
    statusLabel.Text = "Status: Searching for Tobelii_20..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local tobelliPlayer = findTobelliPlayer()
    
    if not tobelliPlayer then
        statusLabel.Text = "Status: Tobelii_20 not found in server"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        task.delay(3, function()
            statusLabel.Text = "Status: Ready"
            statusLabel.TextColor3 = Color3.new(1, 1, 1)
        end)
        return
    end
    
    if tobelliPlayer == player then
        statusLabel.Text = "Status: You are Tobelii_20!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
        
        task.delay(2, function()
            statusLabel.Text = "Status: Ready"
            statusLabel.TextColor3 = Color3.new(1, 1, 1)
        end)
        return
    end
    
    local targetPosition = getPlayerPosition(tobelliPlayer)
    
    if not targetPosition then
        statusLabel.Text = "Status: Waiting for Tobelii_20's character..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        -- Tunggu character Tobelii_20 load
        local connection
        connection = tobelliPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            targetPosition = getPlayerPosition(tobelliPlayer)
            if targetPosition then
                connection:Disconnect()
                safeTeleport(CFrame.new(targetPosition + Vector3.new(0, 3, 0)))
            end
        end)
        
        -- Timeout setelah 10 detik
        task.delay(10, function()
            if connection then
                connection:Disconnect()
            end
            statusLabel.Text = "Status: Tobelii_20 character not found"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            task.delay(3, function()
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end)
        end)
        return
    end
    
    -- Teleport dengan offset agar tidak menumpuk
    safeTeleport(CFrame.new(targetPosition + Vector3.new(0, 3, 0)))
end

-- Drag System Functions
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Teleport Functions
btnGoa.MouseButton1Click:Connect(function()
    safeTeleport(CFrame.new(553, -581, 8840))
end)

btnChristmas.MouseButton1Click:Connect(function()
    safeTeleport(CFrame.new(672, 5, 1607))
end)

btnTobelli.MouseButton1Click:Connect(function()
    teleportToTobelli()
end)

-- Close Button Function
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize Button Function
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize: hanya tampilkan header
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonContainer, tweenInfo, {Position = UDim2.new(0, 0, 1, 0)})
        tween:Play()
        
        task.delay(0.3, function()
            buttonContainer.Visible = false
            main.Size = UDim2.new(0, 260, 0, 40)
        end)
    else
        -- Maximize: tampilkan semua
        buttonContainer.Visible = true
        main.Size = UDim2.new(0, 260, 0, 220)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(buttonContainer, tweenInfo, {Position = UDim2.new(0, 0, 0, 40)})
        tween:Play()
    end
end)

-- Auto-respawn handler
player.CharacterAdded:Connect(function(character)
    statusLabel.Text = "Status: Character loaded"
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    
    task.delay(1, function()
        if statusLabel.Text == "Status: Character loaded" then
            statusLabel.Text = "Status: Ready"
            statusLabel.TextColor3 = Color3.new(1, 1, 1)
        end
    end)
end)

-- Character removal handler
player.CharacterRemoving:Connect(function()
    statusLabel.Text = "Status: Respawning..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
end)

-- Monitor jika Tobelii_20 join/leave
Players.PlayerAdded:Connect(function(addedPlayer)
    if addedPlayer.Name == "Tobelii_20" then
        statusLabel.Text = "Status: Tobelii_20 joined!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
        
        task.delay(3, function()
            if statusLabel.Text == "Status: Tobelii_20 joined!" then
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(removedPlayer)
    if removedPlayer.Name == "Tobelii_20" then
        statusLabel.Text = "Status: Tobelii_20 left"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        task.delay(3, function()
            if statusLabel.Text == "Status: Tobelii_20 left" then
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Color3.new(1, 1, 1)
            end
        end)
    end
end)

-- Initialize status
if player.Character then
    statusLabel.Text = "Status: Ready"
else
    statusLabel.Text = "Status: Waiting for character..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
end

-- Cek apakah Tobelii_20 sudah ada di server
if findTobelliPlayer() then
    btnTobelli.BackgroundColor3 = Color3.fromRGB(180, 80, 230)
    btnTobelli.Text = "Teleport to Tobelii_20 ✓"
end

return gui