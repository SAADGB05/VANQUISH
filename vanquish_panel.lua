local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local camera = game.Workspace.CurrentCamera
local mouse = player:GetMouse()

if coreGui:FindFirstChild("VanquishPanel") then
    coreGui.VanquishPanel:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanquishPanel"
screenGui.Parent = coreGui

-- THEME SYSTEM VARIABLES
local currentThemeIndex = 1
local activeTab = 1
local themeNames = {"Green & Black", "Red & Black", "White & Black", "Blue & Black"}
local themeColors = {
    Color3.fromRGB(0, 255, 0),      -- Green
    Color3.fromRGB(255, 0, 0),      -- Red
    Color3.fromRGB(255, 255, 255),  -- White
    Color3.fromRGB(0, 150, 255)     -- Blue
}

local slidersToTheme = {}
local togglesToTheme = {}
local textLabelsToTheme = {}

-- toggle button (circle)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
toggleBtn.BorderSizePixel = 2
toggleBtn.Text = "V"
toggleBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 24
toggleBtn.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = toggleBtn

-- main panel
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Visible = false
mainFrame.Parent = screenGui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local title = Instance.new("TextButton")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
title.Text = "VANQUISH PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 18
title.AutoButtonColor = false
title.Parent = mainFrame

-- CUSTOM DRAG LOGIC
local draggingPanel = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = false
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- color pulsing effect
local hue = 0
runService.RenderStepped:Connect(function()
    hue = hue + 0.01
    if hue > 1 then hue = 0 end
    local intensity = math.floor(math.sin(hue * math.pi) * 127 + 128)
    local color
    
    if currentThemeIndex == 1 then
        color = Color3.fromRGB(0, intensity, 0)
    elseif currentThemeIndex == 2 then
        color = Color3.fromRGB(intensity, 0, 0)
    elseif currentThemeIndex == 3 then
        color = Color3.fromRGB(intensity, intensity, intensity)
    elseif currentThemeIndex == 4 then
        color = Color3.fromRGB(0, math.floor(intensity * 0.58), intensity)
    end

    title.BackgroundColor3 = color
    mainFrame.BorderColor3 = color
    toggleBtn.BorderColor3 = color
    toggleBtn.TextColor3 = color
end)

-- tabs container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabContainer.Parent = mainFrame

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(0.333, 0, 1, 0)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainTabBtn.Text = "Main"
mainTabBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
mainTabBtn.Font = Enum.Font.Code
mainTabBtn.TextSize = 14
mainTabBtn.Parent = tabContainer

local playerTabBtn = Instance.new("TextButton")
playerTabBtn.Size = UDim2.new(0.334, 0, 1, 0)
playerTabBtn.Position = UDim2.new(0.333, 0, 0, 0)
playerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerTabBtn.Text = "Player"
playerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTabBtn.Font = Enum.Font.Code
playerTabBtn.TextSize = 14
playerTabBtn.Parent = tabContainer

local settingsTabBtn = Instance.new("TextButton")
settingsTabBtn.Size = UDim2.new(0.333, 0, 1, 0)
settingsTabBtn.Position = UDim2.new(0.667, 0, 0, 0)
settingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
settingsTabBtn.Text = "Settings"
settingsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTabBtn.Font = Enum.Font.Code
settingsTabBtn.TextSize = 14
settingsTabBtn.Parent = tabContainer

-- pages
local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.new(1, 0, 1, -60)
mainPage.Position = UDim2.new(0, 0, 0, 60)
mainPage.BackgroundTransparency = 1
mainPage.Parent = mainFrame

local playerPage = Instance.new("Frame")
playerPage.Size = UDim2.new(1, 0, 1, -60)
playerPage.Position = UDim2.new(0, 0, 0, 60)
playerPage.BackgroundTransparency = 1
playerPage.Visible = false
playerPage.Parent = mainFrame

local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1, 0, 1, -60)
settingsPage.Position = UDim2.new(0, 0, 0, 60)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = mainFrame

local function updateThemeStatic()
    local tColor = themeColors[currentThemeIndex]
    mainTabBtn.TextColor3 = (activeTab == 1) and tColor or Color3.fromRGB(255, 255, 255)
    playerTabBtn.TextColor3 = (activeTab == 2) and tColor or Color3.fromRGB(255, 255, 255)
    settingsTabBtn.TextColor3 = (activeTab == 3) and tColor or Color3.fromRGB(255, 255, 255)
    for _, fill in ipairs(slidersToTheme) do fill.BackgroundColor3 = tColor end
    for _, label in ipairs(textLabelsToTheme) do label.TextColor3 = tColor end
    for _, t in ipairs(togglesToTheme) do
        if t.getState() then t.btn.BackgroundColor3 = tColor end
    end
end

local function switchTab(tabNum)
    activeTab = tabNum
    mainPage.Visible = (tabNum == 1)
    playerPage.Visible = (tabNum == 2)
    settingsPage.Visible = (tabNum == 3)
    mainTabBtn.BackgroundColor3 = (tabNum == 1) and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
    playerTabBtn.BackgroundColor3 = (tabNum == 2) and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
    settingsTabBtn.BackgroundColor3 = (tabNum == 3) and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
    updateThemeStatic()
end

mainTabBtn.MouseButton1Click:Connect(function() switchTab(1) end)
playerTabBtn.MouseButton1Click:Connect(function() switchTab(2) end)
settingsTabBtn.MouseButton1Click:Connect(function() switchTab(3) end)

switchTab(1)

-- SLIDER & TOGGLE HELPERS
local function createSlider(parent, name, yPos, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.Parent = parent

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 200, 0, 16)
    sliderBg.Position = UDim2.new(0, 120, 0, yPos + 7)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.Parent = parent

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = themeColors[currentThemeIndex]
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    table.insert(slidersToTheme, sliderFill)

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 0)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 50, 0, 30)
    valLabel.Position = UDim2.new(0, 330, 0, yPos)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = themeColors[currentThemeIndex]
    valLabel.Font = Enum.Font.Code
    valLabel.TextSize = 14
    valLabel.Parent = parent
    table.insert(textLabelsToTheme, valLabel)

    local controller = { Value = default }

    local dragging = false
    local function updateSlider(inputPosX)
        local relPos = inputPosX - sliderBg.AbsolutePosition.X
        local percent = math.clamp(relPos / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        valLabel.Text = tostring(val)
        controller.Value = val
        callback(val)
    end

    controller.Set = function(newVal)
        local percent = math.clamp((newVal - min) / (max - min), 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        valLabel.Text = tostring(math.floor(newVal))
        controller.Value = newVal
        callback(newVal)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    return controller
end

local function createToggle(parent, name, yPos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.Parent = parent

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 24)
    toggleButton.Position = UDim2.new(0, 330, 0, yPos + 3)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.Code
    toggleButton.TextSize = 12
    toggleButton.Parent = parent

    local state = false
    local controller = { State = false }
    table.insert(togglesToTheme, {btn = toggleButton, getState = function() return state end})

    controller.Set = function(newState)
        state = newState
        controller.State = newState
        toggleButton.BackgroundColor3 = state and themeColors[currentThemeIndex] or Color3.fromRGB(50, 50, 50)
        toggleButton.Text = state and "ON" or "OFF"
        callback(state)
    end

    toggleButton.MouseButton1Click:Connect(function()
        controller.Set(not state)
    end)

    return controller
end

-- Helper for getting closest player
local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = v
                end
            end
        end
    end
    return closest
end

-- ==========================
-- MAIN PAGE
-- ==========================
local speedCtrl = createSlider(mainPage, "Speed", 20, 16, 500, 16, function(val)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = val
    end
end)

local jumpCtrl = createSlider(mainPage, "Jump Power", 70, 50, 500, 50, function(val)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.UseJumpPower = true
        player.Character.Humanoid.JumpPower = val
    end
end)

local infJumpEnabled = false
local infJumpCtrl = createToggle(mainPage, "Inf Jump", 120, function(state)
    infJumpEnabled = state
end)

uis.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ==========================
-- PLAYER PAGE
-- ==========================

-- AIMLOCK CIRCLE LOGIC
local actualAimbotActive = false
local aimlockCircle = nil
local circlePinned = false
local clickCount = 0
local lastClickTime = 0

local camLockCtrl = createToggle(playerPage, "Camera Lock", 10, function(state)
    if state then
        if not aimlockCircle then
            aimlockCircle = Instance.new("TextButton")
            aimlockCircle.Size = UDim2.new(0, 60, 0, 60)
            aimlockCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            aimlockCircle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            aimlockCircle.Text = "PIN ME"
            aimlockCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
            aimlockCircle.Font = Enum.Font.Code
            aimlockCircle.TextSize = 14
            aimlockCircle.Parent = screenGui
            
            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(1, 0)
            cCorner.Parent = aimlockCircle

            local draggingCircle = false
            local dragCircleStart, startCirclePos
            
            aimlockCircle.InputBegan:Connect(function(input)
                if not circlePinned and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    draggingCircle = true
                    dragCircleStart = input.Position
                    startCirclePos = aimlockCircle.Position
                end
            end)
            
            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingCircle = false
                end
            end)
            
            uis.InputChanged:Connect(function(input)
                if draggingCircle and not circlePinned and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragCircleStart
                    aimlockCircle.Position = UDim2.new(startCirclePos.X.Scale, startCirclePos.X.Offset + delta.X, startCirclePos.Y.Scale, startCirclePos.Y.Offset + delta.Y)
                end
            end)

            aimlockCircle.MouseButton1Click:Connect(function()
                if not circlePinned then
                    local now = tick()
                    if now - lastClickTime < 0.6 then
                        clickCount = clickCount + 1
                    else
                        clickCount = 1
                    end
                    lastClickTime = now
                    
                    if clickCount >= 3 then
                        circlePinned = true
                        actualAimbotActive = true
                        aimlockCircle.Text = "ON"
                        aimlockCircle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    end
                else
                    actualAimbotActive = not actualAimbotActive
                    aimlockCircle.Text = actualAimbotActive and "ON" or "OFF"
                    aimlockCircle.BackgroundColor3 = actualAimbotActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                end
            end)
        end
    else
        actualAimbotActive = false
        circlePinned = false
        clickCount = 0
        if aimlockCircle then
            aimlockCircle:Destroy()
            aimlockCircle = nil
        end
    end
end)

local espEnabled = false
local espCtrl = createToggle(playerPage, "ESP", 50, function(state)
    espEnabled = state
    if not state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
        end
    end
end)

local espItemsEnabled = false
local espItemsCtrl = createToggle(playerPage, "ESP Items", 90, function(state)
    espItemsEnabled = state
    if not state then
        for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
            if string.find(obj.Name, "Item_Adorn_") then obj:Destroy() end
        end
    end
end)

local noclipEnabled = false
local noclipCtrl = createToggle(playerPage, "Noclip", 130, function(state)
    noclipEnabled = state
end)

-- ==========================================
-- [UPDATED FOR MOBILE] GHOST MODE LOGIC
-- ==========================================
local ghostModeEnabled = false
local ghostPart = nil

-- جلب إعدادات التحكم الخاصة باللاعب (الجوستيك)
local PlayerModule = nil
local Controls = nil
task.spawn(function()
    local success, result = pcall(function()
        return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    end)
    if success and result then
        PlayerModule = result
        Controls = PlayerModule:GetControls()
    end
end)

local ghostCtrl = createToggle(playerPage, "Ghost Mode", 170, function(state)
    ghostModeEnabled = state
    if state then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- تجميد شخصية اللاعب الحقيقية لكي لا تتحرك
            player.Character.HumanoidRootPart.Anchored = true
            
            ghostPart = Instance.new("Part")
            ghostPart.Size = Vector3.new(1, 1, 1)
            ghostPart.Transparency = 1
            ghostPart.CanCollide = false
            ghostPart.Anchored = true
            ghostPart.CFrame = player.Character.HumanoidRootPart.CFrame
            ghostPart.Parent = workspace
            
            -- نقل الكاميرا إلى الشبح
            camera.CameraSubject = ghostPart
        end
    else
        if ghostPart then ghostPart:Destroy() end
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- إزالة التجميد عن اللاعب ليعود للحركة الطبيعية
            player.Character.HumanoidRootPart.Anchored = false
            camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
        end
    end
end)


runService.RenderStepped:Connect(function()
    -- Ghost Mode Movement (Mobile Joystick Support)
    if ghostModeEnabled and ghostPart then
        local speed = 2.0 -- سرعة طيران الشبح
        local moveVector = Vector3.zero
        
        -- سحب بيانات عصا التحكم (الجوستيك)
        if Controls then
            moveVector = Controls:GetMoveVector()
        end
        
        -- حساب الاتجاه بناءً على زاوية الكاميرا وعصا التحكم
        if moveVector.Magnitude > 0 then
            local lookVec = camera.CFrame.LookVector
            local rightVec = camera.CFrame.RightVector
            
            -- في الجوال محور الـ Z الخاص بالجوستيك يكون سالباً عند الدفع للأمام
            local moveDir = (lookVec * -moveVector.Z) + (rightVec * moveVector.X)
            ghostPart.CFrame = ghostPart.CFrame + (moveDir * speed)
        end
    end

    -- Noclip Logic
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Players ESP
    if espEnabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and not v.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "Highlight"
                hl.Parent = v.Character
                hl.FillColor = themeColors[currentThemeIndex]
                hl.OutlineColor = themeColors[currentThemeIndex]
            end
        end
    end
    
    -- Items ESP
    if espItemsEnabled then
        local function applyItemVisual(tool)
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if handle and not game:GetService("CoreGui"):FindFirstChild("Item_Adorn_" .. tool:GetDebugId()) then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Name = "Item_Adorn_" .. tool:GetDebugId()
                    adorn.Adornee = handle
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 10
                    adorn.Size = handle.Size + Vector3.new(0.1, 0.1, 0.1)
                    adorn.Color3 = Color3.fromRGB(138, 43, 226)
                    adorn.Transparency = 0.5
                    adorn.Parent = game:GetService("CoreGui")
                    tool.AncestryChanged:Connect(function()
                        if not tool:IsDescendantOf(game) then adorn:Destroy() end
                    end)
                end
            end
        end
        for _, obj in pairs(workspace:GetChildren()) do applyItemVisual(obj) end
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                for _, obj in pairs(v.Character:GetChildren()) do applyItemVisual(obj) end
            end
        end
    end

    -- Camera Aimbot
    if actualAimbotActive then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- ==========================
-- SETTINGS PAGE
-- ==========================
local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(0, 200, 0, 30)
themeLabel.Position = UDim2.new(0, 10, 0, 20)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "UI Theme: " .. themeNames[currentThemeIndex]
themeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Font = Enum.Font.Code
themeLabel.TextSize = 14
themeLabel.Parent = settingsPage

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 60, 0, 24)
themeBtn.Position = UDim2.new(0, 320, 0, 23)
themeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
themeBtn.Text = "CHANGE"
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.Font = Enum.Font.Code
themeBtn.TextSize = 12
themeBtn.Parent = settingsPage

themeBtn.MouseButton1Click:Connect(function()
    currentThemeIndex = (currentThemeIndex % #themeColors) + 1
    themeLabel.Text = "UI Theme: " .. themeNames[currentThemeIndex]
    updateThemeStatic()
end)

-- ==========================================
-- SAVE / LOAD & RESET SYSTEM 
-- ==========================================
local HttpService = game:GetService("HttpService")
local saveFile = "VanquishSettings.json"
local autoSaveEnabled = false

local autoSaveCtrl = createToggle(settingsPage, "Save Settings", 70, function(state)
    autoSaveEnabled = state
end)

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 100, 0, 24)
resetBtn.Position = UDim2.new(0, 10, 0, 120)
resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetBtn.BorderSizePixel = 0
resetBtn.Text = "RESET ALL"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.Code
resetBtn.TextSize = 12
resetBtn.Parent = settingsPage

local function SaveSettings()
    if not autoSaveEnabled then return end
    local data = {
        Speed = speedCtrl.Value,
        Jump = jumpCtrl.Value,
        InfJump = infJumpCtrl.State,
        CameraLock = camLockCtrl.State,
        ESP = espCtrl.State,
        ESPItems = espItemsCtrl.State,
        Noclip = noclipCtrl.State,
        GhostMode = ghostCtrl.State,
        Theme = currentThemeIndex,
        AutoSave = autoSaveEnabled
    }
    if writefile then
        pcall(function() writefile(saveFile, HttpService:JSONEncode(data)) end)
    end
end

local function LoadSettings()
    if readfile and isfile and isfile(saveFile) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(saveFile)) end)
        if success and type(decoded) == "table" then
            if decoded.AutoSave then autoSaveCtrl.Set(true) end
            if decoded.Speed then speedCtrl.Set(decoded.Speed) end
            if decoded.Jump then jumpCtrl.Set(decoded.Jump) end
            if decoded.InfJump then infJumpCtrl.Set(decoded.InfJump) end
            if decoded.CameraLock then camLockCtrl.Set(decoded.CameraLock) end
            if decoded.ESP then espCtrl.Set(decoded.ESP) end
            if decoded.ESPItems then espItemsCtrl.Set(decoded.ESPItems) end
            if decoded.Noclip then noclipCtrl.Set(decoded.Noclip) end
            if decoded.GhostMode then ghostCtrl.Set(decoded.GhostMode) end
            if decoded.Theme then 
                currentThemeIndex = decoded.Theme
                themeLabel.Text = "UI Theme: " .. themeNames[currentThemeIndex]
                updateThemeStatic()
            end
        end
    end
end

resetBtn.MouseButton1Click:Connect(function()
    speedCtrl.Set(16)
    jumpCtrl.Set(50)
    infJumpCtrl.Set(false)
    camLockCtrl.Set(false)
    espCtrl.Set(false)
    espItemsCtrl.Set(false)
    noclipCtrl.Set(false)
    ghostCtrl.Set(false)
    autoSaveCtrl.Set(false)
    
    currentThemeIndex = 1 
    themeLabel.Text = "UI Theme: " .. themeNames[currentThemeIndex]
    updateThemeStatic()
end)

task.spawn(function()
    while task.wait(2) do
        SaveSettings()
    end
end)

LoadSettings()

print("[VANQUISH] Mobile Supported Successfully")
