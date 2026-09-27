-- ============================================================================
-- 👑 STEAL AN EGG: V40.7 (SAFE PERFORMANCE EDITION)
-- ============================================================================

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local Lighting        = game:GetService("Lighting")
local VirtualUser     = game:GetService("VirtualUser")

local player          = Players.LocalPlayer

task.wait(0.2)

local uiParent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
if uiParent:FindFirstChild("StealAnEggHub_UI") then
    uiParent.StealAnEggHub_UI:Destroy()
end

-- ============================================================================
-- ⚙️ CONFIGURATION SETTINGS
-- ============================================================================
_G.AutoSteal   = false
_G.TomatoMode  = false
_G.NoClip      = false 
_G.OnlyHighTier= false 

-- ============================================================================
-- 🛡️ ANTI-AFK SYSTEM
-- ============================================================================
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================================
-- 📍 BASE & TELEPORT UTILITIES
-- ============================================================================
local function GetMyBasePosition()
    local char = player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return nil end
    
    for _, folderName in ipairs({"Bases", "Plots", "Islands", "PlayerBases"}) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            local folderChildren = folder:GetChildren()
            for i = 1, #folderChildren do
                local base = folderChildren[i]
                if string.find(string.lower(base.Name), string.lower(player.Name)) or (base:GetAttribute("Owner") == player.UserId) then
                    if base:IsA("Model") and base.PrimaryPart then 
                        return base.PrimaryPart.Position 
                    elseif base:FindFirstChild("Core") then
                        return base.Core.Position
                    elseif base:IsA("BasePart") then
                        return base.Position
                    end
                end
            end
        end
    end
    
    local descendants = workspace:GetDescendants()
    for i = 1, #descendants do
        local obj = descendants[i]
        if obj:IsA("SpawnLocation") then
            return obj.Position + Vector3.new(0, 3, 0) 
        end
    end
    return Vector3.new(0, 10, 0)
end

-- ============================================================================
-- 🥚 EGG DETECTION SYSTEM
-- ============================================================================
local function GetHighestPriceEgg()
    local bestEgg       = nil
    local highestWeight = -1
    local shortestDist  = math.huge
    
    local char = player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return nil end
    local hrp = char.HumanoidRootPart

    local descendants = workspace:GetDescendants()
    for i = 1, #descendants do
        local prompt = descendants[i]
        if prompt:IsA("ProximityPrompt") and prompt.Parent then
            local parentObj  = prompt.Parent
            local targetPart = parentObj:IsA("BasePart") and parentObj or parentObj:FindFirstChildWhichIsA("BasePart")
            
            if targetPart and targetPart.Parent and targetPart:IsDescendantOf(workspace) then
                local nameLower = string.lower(parentObj.Name)
                local parentNameLower = parentObj.Parent and string.lower(parentObj.Parent.Name) or ""
                
                if string.find(nameLower, "group") or string.find(nameLower, "chest") or string.find(nameLower, "reward") or string.find(nameLower, "shop") or string.find(nameLower, "code") or
                   string.find(parentNameLower, "group") or string.find(parentNameLower, "chest") or string.find(parentNameLower, "reward") or string.find(parentNameLower, "shop") then
                    continue
                end

                local currentWeight = 1
                local isDivineOrSecret = string.find(nameLower, "divine") or string.find(nameLower, "secret") or string.find(parentNameLower, "divine") or string.find(parentNameLower, "secret")
                
                if _G.OnlyHighTier and not isDivineOrSecret then
                    continue 
                end

                if string.find(nameLower, "divine") or string.find(parentNameLower, "divine") then
                    currentWeight = 9999999
                elseif string.find(nameLower, "secret") or string.find(parentNameLower, "secret") then
                    currentWeight = 5000000
                elseif string.find(nameLower, "epic") or string.find(parentNameLower, "epic") then
                    currentWeight = 100000
                elseif string.find(nameLower, "rare") or string.find(parentNameLower, "rare") then
                    currentWeight = 10000
                end
                
                local dist = (hrp.Position - targetPart.Position).Magnitude
                if currentWeight > highestWeight then
                    highestWeight = currentWeight
                    shortestDist  = dist
                    bestEgg       = targetPart
                elseif currentWeight == highestWeight and dist < shortestDist then
                    shortestDist  = dist
                    bestEgg       = targetPart
                end
            end
        end
    end
    return bestEgg
end

-- ============================================================================
-- 🖥️ USER INTERFACE (UI DESIGN & SETUP)
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name  = "StealAnEggHub_UI"
screenGui.Parent= uiParent
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn   = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size  = UDim2.new(0, 350, 0, 320)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(255, 215, 0)
mainStroke.Thickness = 1.5

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size  = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 18, 10)
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size  = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text  = "STEAL AN EGG • V40.7 SAFE"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextSize = 11
titleLabel.Font  = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size  = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -34, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text  = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font  = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 4)

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size  = UDim2.new(1, -30, 0, 25)
statusLabel.Position = UDim2.new(0, 15, 0, 52)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Font  = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.Text  = "STATUS: IDLE"
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

local statusCorner = Instance.new("UICorner", statusLabel)
statusCorner.CornerRadius = UDim.new(0, 6)

local floatLogo = Instance.new("TextButton", screenGui)
floatLogo.Size  = UDim2.new(0, 46, 0, 46)
floatLogo.Position = UDim2.new(0, 20, 0.3, 0)
floatLogo.BackgroundColor3 = Color3.fromRGB(15, 14, 10)
floatLogo.Text  = "👑"
floatLogo.TextColor3 = Color3.fromRGB(255, 215, 0)
floatLogo.Font  = Enum.Font.GothamBold
floatLogo.TextSize = 18
floatLogo.Visible = false 
floatLogo.BorderSizePixel = 0
floatLogo.Active = true

local floatStroke = Instance.new("UIStroke", floatLogo)
floatStroke.Color = Color3.fromRGB(255, 215, 0)
floatStroke.Thickness = 1.5

local floatCorner = Instance.new("UICorner", floatLogo)
floatCorner.CornerRadius = UDim.new(0, 8)

local function ApplyDrag(trigger, target)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            dragStart  = input.Position
            startPos   = target.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then dragging = false end 
            end)
        end
    end)
    trigger.InputChanged:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end 
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

ApplyDrag(titleBar, mainFrame)
ApplyDrag(floatLogo, floatLogo)

closeBtn.Activated:Connect(function() 
    mainFrame.Visible = false 
    floatLogo.Visible = true 
end)

floatLogo.Activated:Connect(function() 
    mainFrame.Visible = true 
    floatLogo.Visible = false 
end)

local function CreateToggle(text, yPos, callback)
    local container = Instance.new("Frame", mainFrame)
    container.Size  = UDim2.new(1, -30, 0, 45)
    container.Position = UDim2.new(0, 15, 0, yPos)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size  = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text  = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font  = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", container)
    toggleBtn.Size  = UDim2.new(0, 60, 0, 28)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -14)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    toggleBtn.Text  = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    toggleBtn.Font  = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    
    local corner = Instance.new("UICorner", toggleBtn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", toggleBtn)
    stroke.Color = Color3.fromRGB(60, 60, 65)

    local state = false
    toggleBtn.Activated:Connect(function()
        state = not state
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            toggleBtn.Text = "ON"
            stroke.Color = Color3.fromRGB(255, 215, 0)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            toggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            toggleBtn.Text = "OFF"
            stroke.Color = Color3.fromRGB(60, 60, 65)
        end
        callback(state)
    end)
end

CreateToggle("Auto Global Steal",   85,  function(val) _G.AutoSteal = val end)
CreateToggle("Only Divine / Secret", 140, function(val) _G.OnlyHighTier = val end)
CreateToggle("No Lag Tomato Mode",   195, function(val)
    _G.TomatoMode = val
    if val then
        -- ปรับเฉพาะ Lighting ป้องกันโดน Anti-Cheat เตะเรื่องเปลี่ยนพาร์ท
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
    else
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
    end
end)
CreateToggle("NoClip Safe Mode",     250, function(val) _G.NoClip = val end)

-- ============================================================================
-- 🚀 CORE LOOPS & SYSTEMS
-- ============================================================================
RunService.Stepped:Connect(function()
    if _G.NoClip and player.Character then
        local parts = player.Character:GetDescendants()
        for i = 1, #parts do
            local part = parts[i]
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    local lastPos = Vector3.new(0,0,0)
    local stuckTicks = 0

    while task.wait(0.8) do
        if not _G.AutoSteal then
            statusLabel.Text = "STATUS: IDLE (OFF)"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            continue
        end

        pcall(function()
            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not hum or hum.Health <= 0 then 
                statusLabel.Text = "STATUS: WAITING FOR CHARACTER..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                return 
            end
            
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            if (hrp.Position - lastPos).Magnitude < 1.5 then
                stuckTicks = stuckTicks + 1
                if stuckTicks >= 3 then
                    hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3), 5, math.random(-3,3))
                    stuckTicks = 0
                    task.wait(0.5)
                    return
                end
            else
                stuckTicks = 0
            end
            lastPos = hrp.Position
            
            local eggCount = 0
            local charChildren = char:GetChildren()
            for i = 1, #charChildren do
                local child = charChildren[i]
                if string.find(string.lower(child.Name), "egg") or child:IsA("Tool") then
                    eggCount = eggCount + 1
                end
            end
            
            local holdingEgg = (eggCount > 0)
            
            if not holdingEgg and player:FindFirstChild("Backpack") then
                local backpackChildren = player.Backpack:GetChildren()
                for i = 1, #backpackChildren do
                    local tool = backpackChildren[i]
                    if string.find(string.lower(tool.Name), "egg") then
                        holdingEgg = true
                        hum:EquipTool(tool)
                        break
                    end
                end
            end
            
            if holdingEgg then
                statusLabel.Text = "STATUS: 📦 RETURNING EGG TO BASE"
                statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)

                local basePos = GetMyBasePosition()
                if basePos then
                    hum:MoveTo(basePos + Vector3.new(math.random(-2,2), 0, math.random(-2,2)))
                    task.wait(1.2)
                end
            else
                statusLabel.Text = "STATUS: 🔍 SEARCHING FOR EGGS..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

                local targetEgg = GetHighestPriceEgg()
                if targetEgg and targetEgg.Parent and targetEgg:IsDescendantOf(workspace) then
                    statusLabel.Text = "STATUS: ⚡ WALKING TO EGG!"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)

                    hum:MoveTo(targetEgg.Position + Vector3.new(0, 2, 0))
                    task.wait(0.8)
                    
                    local prompt = targetEgg:FindFirstChildWhichIsA("ProximityPrompt") or targetEgg.Parent:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and prompt.Parent then
                        pcall(function()
                            fireproximityprompt(prompt)
                        end)
                    end
                    task.wait(0.5)
                else
                    statusLabel.Text = "STATUS: ⏳ WAITING FOR HIGH-TIER EGG..."
                    statusLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
                end
            end
        end)
    end
end)
