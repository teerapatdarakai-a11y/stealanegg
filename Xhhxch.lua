-- ============================================================================
-- 1. ลบ UI เก่าหากมีรันอยู่ก่อนหน้า
-- ============================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("StealEggClassicHub") then
    CoreGui.StealEggClassicHub:Destroy()
end

-- ============================================================================
-- 2. สร้างโครงสร้างหน้าต่างหลัก (ปรับขนาดเป็น 200 x 165 เพื่อไม่ให้ปุ่มทับกัน)
-- ============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggClassicHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 165)
MainFrame.Position = UDim2.new(0.5, -100, 0.3, -80)
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

-- ----------------------------------------------------------------------------
-- ส่วนควบคุมระบบที่ 1: SPEED BYPASS
-- ----------------------------------------------------------------------------
local WalkInput = Instance.new("TextBox")
WalkInput.Size = UDim2.new(1, -20, 0, 22)
WalkInput.Position = UDim2.new(0, 10, 0, 8)
WalkInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WalkInput.BorderSizePixel = 0
WalkInput.Text = "2.5"
WalkInput.PlaceholderText = "Speed Multiplier"
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
WalkToggle.Position = UDim2.new(0, 10, 0, 34)
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

-- ----------------------------------------------------------------------------
-- ส่วนควบคุมระบบที่ 2: FLY BYPASS
-- ----------------------------------------------------------------------------
local FlyInput = Instance.new("TextBox")
FlyInput.Size = UDim2.new(1, -20, 0, 22)
FlyInput.Position = UDim2.new(0, 10, 0, 68)
FlyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyInput.BorderSizePixel = 0
FlyInput.Text = "150"
FlyInput.PlaceholderText = "Fly Speed Value"
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
FlyToggle.Position = UDim2.new(0, 10, 0, 94)
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

-- ============================================================================
-- 3. สร้างปุ่มโลโก้ลอยแบบเหลี่ยม (Floating Box Icon)
-- ============================================================================
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

-- ============================================================================
-- 4. ระบบการทำงานเบื้องหลังความปลอดภัยและ LOGIC
-- ============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ค่าเริ่มต้นของระบบ
_G.SuperSpeedEnabled = false
_G.SpeedMultiplier = 2.5
_G.FlyEnabled = false
_G.FlySpeed = 150

-- ฟังก์ชันสลับย่อ/ขยายหน้าต่าง
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

-- ควบคุมสวิตช์เปิด/ปิด Walk
WalkToggle.MouseButton1Click:Connect(function()
    _G.SuperSpeedEnabled = not _G.SuperSpeedEnabled
    WalkToggle.Text = _G.SuperSpeedEnabled and "SPEED BYPASS: ON" or "SPEED BYPASS: OFF"
    WalkToggle.TextColor3 = _G.SuperSpeedEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- ดักจับการแก้ไขค่าช่องกรอก Walk Input
WalkInput.FocusLost:Connect(function()
    local num = tonumber(WalkInput.Text)
    if num then
        _G.SpeedMultiplier = num
    else
        WalkInput.Text = tostring(_G.SpeedMultiplier)
    end
end)

-- ควบคุมสวิตช์เปิด/ปิด Fly
FlyToggle.MouseButton1Click:Connect(function()
    _G.FlyEnabled = not _G.FlyEnabled
    FlyToggle.Text = _G.FlyEnabled and "FLY BYPASS: ON" or "FLY BYPASS: OFF"
    FlyToggle.TextColor3 = _G.FlyEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    
    if not _G.FlyEnabled then
        pcall(function()
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end)
    end
end)

-- ดักจับการแก้ไขค่าช่องกรอก Fly Input
FlyInput.FocusLost:Connect(function()
    local num = tonumber(FlyInput.Text)
    if num then
        _G.FlySpeed = num
    else
        FlyInput.Text = tostring(_G.FlySpeed)
    end
end)

-- ระบบ Anti-AFK
local afkConnection = LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ลูปรันระบบคำนวณตำแหน่งการเคลื่อนที่ (Heartbeat Engine)
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end
    
    local moveDirection = humanoid.MoveDirection
    
    -- Auto Noclip ขณะบิน
    if _G.FlyEnabled then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    
    -- ระบบเดินเร็ว CFrame
    if _G.SuperSpeedEnabled and not _G.FlyEnabled then
        local currentSpeed = humanoid.WalkSpeed
        if moveDirection.Magnitude > 0 then
            local calculateSpeed = currentSpeed * _G.SpeedMultiplier
            rootPart.CFrame = rootPart.CFrame + (moveDirection * calculateSpeed * deltaTime)
        end
    end
    
    -- ระบบบินตามทิศทางกล้อง
    if _G.FlyEnabled then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        if moveDirection.Magnitude > 0 and camera then
            local cameraCFrame = camera.CFrame
            local flyVelocity = (cameraCFrame.LookVector * (moveDirection.Z * -1) + cameraCFrame.RightVector * moveDirection.X).Unit
            local nextPosition = rootPart.CFrame + (flyVelocity * _G.FlySpeed * deltaTime)
            
            -- ล็อคขอบเขตความสูงป้องกันร่วงตกแมพ
            if nextPosition.Y < -50 then
                nextPosition = CFrame.new(nextPosition.X, -50, nextPosition.Z)
            elseif nextPosition.Y > 1000 then
                nextPosition = CFrame.new(nextPosition.X, 1000, nextPosition.Z)
            end
            
            rootPart.CFrame = nextPosition
        end
    end
end)

-- ปุ่มปิดสคริปต์แบบถาวร (×)
CloseBtn.MouseButton1Click:Connect(function()
    if heartbeatConnection then heartbeatConnection:Disconnect() end
    if afkConnection then afkConnection:Disconnect() end
    
    _G.SuperSpeedEnabled = false
    _G.FlyEnabled = false
    
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end)
    
    ScreenGui:Destroy()
end)
