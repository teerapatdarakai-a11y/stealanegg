-- ==========================================
-- STEAL AN EGG: PROFESSIONAL EDITION V6
-- BUG FIXED, OPTIMIZED & ZERO LAG
-- ==========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("StealAnEggHub_UI") then
    CoreGui.StealAnEggHub_UI:Destroy()
end

-- ==========================================
-- UI GENERATION: MAIN INTERFACE
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealAnEggHub_UI"
screenGui.Parent = CoreGui
screenGui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 370)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -185)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(88, 101, 242)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
titleLabel.Text = "    ⚡ STEAL AN EGG | AUTO V6 (OPTIMIZED)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local floatLogo = Instance.new("TextButton")
floatLogo.Size = UDim2.new(0, 50, 0, 50)
floatLogo.Position = UDim2.new(0, 20, 0.5, -25)
floatLogo.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
floatLogo.Text = "EGG"
floatLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
floatLogo.TextSize = 12
floatLogo.Font = Enum.Font.GothamBold
floatLogo.Visible = false
floatLogo.Active = true
floatLogo.Draggable = true
floatLogo.Parent = screenGui
Instance.new("UICorner", floatLogo).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatLogo.Visible = true
end)
floatLogo.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatLogo.Visible = false
end)

-- ==========================================
-- COMPONENTS: SWITCHES
-- ==========================================
local toggle1Btn = Instance.new("TextButton")
toggle1Btn.Size = UDim2.new(0, 380, 0, 45)
toggle1Btn.Position = UDim2.new(0.5, -190, 0, 60)
toggle1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
toggle1Btn.Text = "1. AUTO STEAL & RETURN [OFF]"
toggle1Btn.TextColor3 = Color3.fromRGB(255, 90, 90)
toggle1Btn.TextSize = 13
toggle1Btn.Font = Enum.Font.GothamBold
toggle1Btn.Parent = mainFrame
Instance.new("UICorner", toggle1Btn).CornerRadius = UDim.new(0, 6)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 380, 0, 45)
espBtn.Position = UDim2.new(0.5, -190, 0, 115)
espBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
espBtn.Text = "2. ESP SECRET EGG [OFF]"
espBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
espBtn.TextSize = 13
espBtn.Font = Enum.Font.GothamBold
espBtn.Parent = mainFrame
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 380, 0, 20)
speedLabel.Position = UDim2.new(0.5, -190, 0, 170)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "3. RUN SPEED [CURRENT: 16B]"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.Parent = mainFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 380, 0, 45)
speedInput.Position = UDim2.new(0.5, -190, 0, 195)
speedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
speedInput.Text = "16B"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 15
speedInput.Font = Enum.Font.GothamBold
speedInput.PlaceholderText = "Input speed number..."
speedInput.ClearTextOnFocus = false
speedInput.Parent = mainFrame
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 30)
credit.Position = UDim2.new(0, 0, 1, -30)
credit.BackgroundTransparency = 1
credit.Text = "V6: BUG FIXED & LAG OPTIMIZED"
credit.TextColor3 = Color3.fromRGB(100, 100, 130)
credit.TextSize = 10
credit.Font = Enum.Font.GothamItalic
credit.Parent = mainFrame

-- ==========================================
-- CORE LOGIC & FUNCTIONS
-- ==========================================
local autoSecretActive = false
local espActive = false
local targetSpeed = 16
local basePosition = nil 

local function isSecretEgg(name)
    local n = string.lower(name)
    return string.find(n, "secret") or string.find(n, "divine") or string.find(n, "mythic")
end

-- ==========================================
-- 1. ระบบ AUTO STEAL & RETURN
-- ==========================================
toggle1Btn.MouseButton1Click:Connect(function()
    autoSecretActive = not autoSecretActive
    if autoSecretActive then
        toggle1Btn.Text = "1. AUTO STEAL & RETURN [ON]"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
        toggle1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            basePosition = char.HumanoidRootPart.CFrame
        end
    else
        toggle1Btn.Text = "1. AUTO STEAL & RETURN [OFF]"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        toggle1Btn.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if autoSecretActive and basePosition then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                for _, entity in pairs(workspace:GetDescendants()) do
                    if entity:IsA("Model") and isSecretEgg(entity.Name) then
                        local primaryPart = entity.PrimaryPart or entity:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then
                            -- วาร์ปไปที่ไข่
                            hrp.CFrame = primaryPart.CFrame + Vector3.new(0, 1, 0)
                            task.wait(0.2)
                            
                            -- กดขโมย (กรณีไข่ใช้ ProximityPrompt)
                            for _, prompt in pairs(entity:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt, 1)
                                end
                            end
                            
                            -- เดินชนขโมย (กรณีไข่ใช้ระบบ Touch)
                            if firetouchinterest then
                                firetouchinterest(hrp, primaryPart, 0)
                                task.wait(0.1)
                                firetouchinterest(hrp, primaryPart, 1)
                            end
                            
                            task.wait(0.3)
                            -- วาร์ปกลับฐาน
                            hrp.CFrame = basePosition
                            task.wait(1.0)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 2. ระบบ ESP SECRET EGG (แก้บั๊กไฟค้าง & ลดแลค)
-- ==========================================
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        espBtn.Text = "2. ESP SECRET EGG [ON]"
        espBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espBtn.Text = "2. ESP SECRET EGG [OFF]"
        espBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        espBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
        
        -- ลบ ESP ที่สร้างไว้ออกให้หมด (Fix ลบแสงไม่ยอมหาย)
        for _, obj in pairs(CoreGui:GetChildren()) do
            if obj:IsA("Highlight") and string.find(obj.Name, "_ESP") then
                obj:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do -- รันทุก 1 วิ แทนการรันรัวๆ แบบเดิม ลดแลคลงได้ 99%
        if espActive then
            pcall(function()
                for _, entity in pairs(workspace:GetDescendants()) do
                    if entity:IsA("Model") and isSecretEgg(entity.Name) then
                        local espName = entity.Name .. "_ESP"
                        if not CoreGui:FindFirstChild(espName) then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = espName
                            highlight.FillColor = Color3.fromRGB(255, 50, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.Adornee = entity
                            highlight.Parent = CoreGui
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 3. ระบบ SPEED (200B)
-- ==========================================
speedInput.FocusLost:Connect(function()
    local numStr = string.match(speedInput.Text, "%d+%.?%d*")
    
    if numStr then
        local parsedSpeed = tonumber(numStr)
        if parsedSpeed < 0 then parsedSpeed = 0 end
        
        targetSpeed = parsedSpeed
        speedLabel.Text = "3. RUN SPEED [CURRENT: " .. targetSpeed .. "B]"
        speedInput.Text = tostring(targetSpeed) .. "B"
    else
        speedInput.Text = tostring(targetSpeed) .. "B"
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid.WalkSpeed ~= targetSpeed then
                humanoid.WalkSpeed = targetSpeed
            end
        end
    end)
end)
