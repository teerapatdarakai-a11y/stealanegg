-- [[ 1. ลบ UI เก่าหากมีรันอยู่ก่อนหน้า ]] --
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("StealEggClassicHub") then
    CoreGui.StealEggClassicHub:Destroy()
end

-- [[ 2. สร้างโครงสร้างหน้าต่างหลัก (มุมเหลี่ยม 90° ขอบแดงสด) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggClassicHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 140)
MainFrame.Position = UDim2.new(0.5, -100, 0.3, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- แถบหัวข้อด้านบน
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Text = "  STEAL EGG HARDCORE"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Font = Enum.Font.Code
TitleBar.TextSize = 11
TitleBar.Parent = MainFrame

-- ปุ่มย่อหน้าต่าง (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 2.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = MainFrame

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(255, 0, 0)
MinStroke.Thickness = 1
MinStroke.Parent = MinimizeBtn

-- ปุ่มปิดถาวร (×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -22, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 0, 0)
CloseStroke.Thickness = 1
CloseStroke.Parent = CloseBtn

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 1, -25)
ButtonContainer.Position = UDim2.new(0, 0, 0, 25)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- --- SPEED BYPASS ---
local WalkInput = Instance.new("TextBox")
WalkInput.Size = UDim2.new(1, -20, 0, 22)
WalkInput.Position = UDim2.new(0, 10, 0, 6)
WalkInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WalkInput.BorderSizePixel = 0
WalkInput.Text = "2.5"
WalkInput.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkInput.Font = Enum.Font.Code
WalkInput.TextSize = 11
WalkInput.Parent = ButtonContainer

local WalkInputStroke = Instance.new("UIStroke")
WalkInputStroke.Color = Color3.fromRGB(150, 0, 0)
WalkInputStroke.Thickness = 1
WalkInputStroke.Parent = WalkInput

local WalkToggle = Instance.new("TextButton")
WalkToggle.Size = UDim2.new(1, -20, 0, 24)
WalkToggle.Position = UDim2.new(0, 10, 0, 32)
WalkToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
WalkToggle.BorderSizePixel = 0
WalkToggle.Text = "SPEED BYPASS: OFF"
WalkToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
WalkToggle.Font = Enum.Font.Code
WalkToggle.TextSize = 11
WalkToggle.Parent = ButtonContainer

local WalkStroke = Instance.new("UIStroke")
WalkStroke.Color = Color3.fromRGB(255, 0, 0)
WalkStroke.Thickness = 1
WalkStroke.Parent = WalkToggle

-- --- FLY BYPASS ---
local FlyInput = Instance.new("TextBox")
FlyInput.Size = UDim2.new(1, -20, 0, 22)
FlyInput.Position = UDim2.new(0, 10, 0, 62)
FlyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyInput.BorderSizePixel = 0
FlyInput.Text = "150"
FlyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyInput.Font = Enum.Font.Code
FlyInput.TextSize = 11
FlyInput.Parent = ButtonContainer

local FlyInputStroke = Instance.new("UIStroke")
FlyInputStroke.Color = Color3.fromRGB(150, 0, 0)
FlyInputStroke.Thickness = 1
FlyInputStroke.Parent = FlyInput

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, -20, 0, 24)
FlyToggle.Position = UDim2.new(0, 10, 0, 88)
FlyToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FlyToggle.BorderSizePixel = 0
FlyToggle.Text = "FLY BYPASS: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyToggle.Font = Enum.Font.Code
FlyToggle.TextSize = 11
FlyToggle.Parent = ButtonContainer

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Color = Color3.fromRGB(255, 0, 0)
FlyStroke.Thickness = 1
FlyStroke.Parent = FlyToggle

-- โลโก้ลอยแบบเหลี่ยม
local FloatingLogo = Instance.new("TextButton")
FloatingLogo.Name = "FloatingLogo"
FloatingLogo.Size = UDim2.new(0, 40, 0, 40)
FloatingLogo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FloatingLogo.BorderSizePixel = 0
FloatingLogo.Text = "SYS"
FloatingLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingLogo.Font = Enum.Font.Code
FloatingLogo.TextSize = 12
FloatingLogo.Visible = false
FloatingLogo.Active = true
FloatingLogo.Draggable = true
FloatingLogo.Parent = ScreenGui

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(255, 0, 0)
LogoStroke.Thickness = 2
LogoStroke.Parent = FloatingLogo

-- [[ 3. ระบบ Dynamic Loop & Safety ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SuperSpeedEnabled = false
local SpeedMultiplier = 2.5
local FlyEnabled = false
local FlySpeed = 150

local speedConnection = nil
local flyConnection = nil

local function updateBypassLoops()
    if speedConnection then speedConnection:Disconnect(); speedConnection = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end

    if SuperSpeedEnabled and not FlyEnabled then
        speedConnection = RunService.Heartbeat:Connect(function(deltaTime)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and root and hum.MoveDirection.Magnitude > 0 then
                local currentSpeed = hum.WalkSpeed
                root.CFrame = root.CFrame + (hum.MoveDirection * (currentSpeed * SpeedMultiplier) * deltaTime)
            end
        end)
    end

    if FlyEnabled then
        flyConnection = RunService.Heartbeat:Connect(function(deltaTime)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if not root or not hum then return end
            
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            
            root.Velocity = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            if hum.MoveDirection.Magnitude > 0 and camera then
                local flyVelocity = (camera.CFrame.LookVector * (hum.MoveDirection.Z * -1) + camera.CFrame.RightVector * hum.MoveDirection.X).Unit
                local nextCFrame = root.CFrame + (flyVelocity * FlySpeed * deltaTime)
                
                local currentY = nextCFrame.Y
                if currentY < -50 then
                    nextCFrame = CFrame.new(nextCFrame.X, -50, nextCFrame.Z)
                elseif currentY > 1000 then
                    nextCFrame = CFrame.new(nextCFrame.X, 1000, nextCFrame.Z)
                end
                
                root.CFrame = nextCFrame
            end
        end)
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingLogo.Position = UDim2.new(0, MainFrame.AbsolutePosition.X + 80, 0, MainFrame.AbsolutePosition.Y + 50)
    FloatingLogo.Visible = true
end)

FloatingLogo.MouseButton1Click:Connect(function()
    FloatingLogo.Visible = false
    MainFrame.Position = UDim2.new(0, FloatingLogo.AbsolutePosition.X - 80, 0, FloatingLogo.AbsolutePosition.Y - 50)
    MainFrame.Visible = true
end)

WalkToggle.MouseButton1Click:Connect(function()
    SuperSpeedEnabled = not SuperSpeedEnabled
    if SuperSpeedEnabled then FlyEnabled = false end
    
    WalkToggle.Text = SuperSpeedEnabled and "SPEED BYPASS: ON" or "SPEED BYPASS: OFF"
    WalkToggle.TextColor3 = SuperSpeedEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    FlyToggle.Text = "FLY BYPASS: OFF"
    FlyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    updateBypassLoops()
end)

WalkInput.FocusLost:Connect(function()
    local num = tonumber(WalkInput.Text)
    if num then SpeedMultiplier = num else WalkInput.Text = tostring(SpeedMultiplier) end
    if SuperSpeedEnabled then updateBypassLoops() end
end)

FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then SuperSpeedEnabled = false end
    
    FlyToggle.Text = FlyEnabled and "FLY BYPASS: ON" or "FLY BYPASS: OFF"
    FlyToggle.TextColor3 = FlyEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    WalkToggle.Text = "SPEED BYPASS: OFF"
    WalkToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    
    if not FlyEnabled then
        pcall(function() LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end)
    end
    updateBypassLoops()
end)

FlyInput.FocusLost:Connect(function()
    local num = tonumber(FlyInput.Text)
    if num then FlySpeed = num else FlyInput.Text = tostring(FlySpeed) end
    if FlyEnabled then updateBypassLoops() end
end)

local VirtualUser = game:GetService("VirtualUser")
local afkConnection = LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SuperSpeedEnabled = false
    FlyEnabled = false
    if speedConnection then speedConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if afkConnection then afkConnection:Disconnect() end
    pcall(function() LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end)
    ScreenGui:Destroy()
end)
