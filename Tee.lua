-- ==========================================
-- STEAL AN EGG: PROFESSIONAL EDITION V2
-- FULLY INTERACTIVE & MINIMIZABLE UI
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
-- UI GENERATION: LOADING SCREEN
-- ==========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealAnEggHub_UI"
screenGui.Parent = CoreGui
screenGui.IgnoreGuiInset = true

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1, 0, 1, 0)
loadFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
loadFrame.Parent = screenGui

local loadText = Instance.new("TextLabel")
loadText.Size = UDim2.new(0, 450, 0, 100)
loadText.Position = UDim2.new(0.5, -225, 0.45, -50)
loadText.BackgroundTransparency = 1
loadText.TextColor3 = Color3.fromRGB(255, 215, 0)
loadText.TextSize = 24
loadText.Font = Enum.Font.GothamBold
loadText.Text = "INITIALIZING CORE SYSTEMS..."
loadText.Parent = loadFrame

task.wait(1.0)
loadText.Text = "LOADING INTERACTIVE MODULES..."
task.wait(1.0)

TweenService:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(loadText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
task.wait(0.5)
loadFrame:Destroy()

-- ==========================================
-- UI GENERATION: MAIN INTERFACE
-- ==========================================

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 310)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(88, 101, 242)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
titleLabel.Text = "    ⚡ STEAL AN EGG | ADVANCED MODULE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ==========================================
-- MINIMIZE / CLOSE BUTTON (X BUTTON)
-- ==========================================

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Floating Logo (เปิดขึ้นมาแทนตอนกดกากบาท)
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

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = floatLogo

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatLogo.Visible = true
end)

floatLogo.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatLogo.Visible = false
end)

-- ==========================================
-- COMPONENTS: SWITCH 1 (AUTO SECRET & ESCAPE)
-- ==========================================

local toggle1Btn = Instance.new("TextButton")
toggle1Btn.Size = UDim2.new(0, 380, 0, 50)
toggle1Btn.Position = UDim2.new(0.5, -190, 0, 70)
toggle1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
toggle1Btn.Text = "SWITCH 1: AUTO SECRET EGG [OFF]"
toggle1Btn.TextColor3 = Color3.fromRGB(255, 90, 90)
toggle1Btn.TextSize = 14
toggle1Btn.Font = Enum.Font.GothamBold
toggle1Btn.Parent = mainFrame

local t1Corner = Instance.new("UICorner")
t1Corner.CornerRadius = UDim.new(0, 6)
t1Corner.Parent = toggle1Btn

-- ==========================================
-- COMPONENTS: SWITCH 2 (SPEED CONTROLLER)
-- ==========================================

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 380, 0, 20)
speedLabel.Position = UDim2.new(0.5, -190, 0, 135)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "SWITCH 2: RUN SPEED [CURRENT: 16]"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.Parent = mainFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 380, 0, 45)
speedInput.Position = UDim2.new(0.5, -190, 0, 160)
speedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 15
speedInput.Font = Enum.Font.GothamBold
speedInput.PlaceholderText = "Input speed range 0 - 200..."
speedInput.Parent = mainFrame

local s2Corner = Instance.new("UICorner")
s2Corner.CornerRadius = UDim.new(0, 6)
s2Corner.Parent = speedInput

-- ==========================================
-- FOOTER CREDITS
-- ==========================================

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 30)
credit.Position = UDim2.new(0, 0, 1, -30)
credit.BackgroundTransparency = 1
credit.Text = "INTERACTIVE MODE ACTIVE"
credit.TextColor3 = Color3.fromRGB(100, 100, 130)
credit.TextSize = 10
credit.Font = Enum.Font.GothamItalic
credit.Parent = mainFrame

-- ==========================================
-- CORE LOGIC IMPLEMENTATION
-- ==========================================

local autoSecretActive = false
local targetSpeed = 16

-- SWITCH 1 EVENT (กดเปิด-ปิดสวิตช์ได้ทันที)
toggle1Btn.MouseButton1Click:Connect(function()
    autoSecretActive = not autoSecretActive
    if autoSecretActive then
        toggle1Btn.Text = "SWITCH 1: AUTO SECRET EGG [ON]"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
        toggle1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        toggle1Btn.Text = "SWITCH 1: AUTO SECRET EGG [OFF]"
        toggle1Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        toggle1Btn.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
end)

-- AUTOMATED EXECUTION LOOP (SECRET EGG & CHICKEN EVASION)
task.spawn(function()
    while true do
        task.wait(0.3)
        if autoSecretActive then
            pcall(function()
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local rootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                for _, entity in pairs(workspace:GetDescendants()) do
                    if entity:IsA("Model") then
                        local entityName = entity.Name:lower()
                        if string.find(entityName, "secret") or string.find(entityName, "divine") then
                            local primaryPart = entity.PrimaryPart or entity:FindFirstChildWhichIsA("BasePart")
                            if primaryPart then
                                rootPart.CFrame = primaryPart.CFrame + Vector3.new(0, 3, 0)
                                
                                if humanoid and humanoid.Health < 75 then
                                    rootPart.CFrame = primaryPart.CFrame + Vector3.new(0, 20, 0)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- SWITCH 2 EVENT (กดพิมพ์เปลี่ยนความเร็วแล้วกด Enter หรือกดคลิกออก)
speedInput.FocusLost:Connect(function()
    local parsedSpeed = tonumber(speedInput.Text)
    if parsedSpeed then
        if parsedSpeed < 0 then parsedSpeed = 0 end
        if parsedSpeed > 200 then parsedSpeed = 200 end
        
        targetSpeed = parsedSpeed
        speedLabel.Text = "SWITCH 2: RUN SPEED [CURRENT: " .. targetSpeed .. "]"
        
        local character = player.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid").WalkSpeed = targetSpeed
        end
    end
end)

-- SPEED LOCK SERVICE
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
