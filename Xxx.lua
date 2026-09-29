-- [[ 1. สั่งล้างระบบเก่าทั้งหมดที่ตกค้างในหน่วยความจำ Delta ]] --
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("StealEggClassicHub") then CoreGui.StealEggClassicHub:Destroy() end
if CoreGui:FindFirstChild("StealEggMiniHub") then CoreGui.StealEggMiniHub:Destroy() end
if CoreGui:FindFirstChild("StealEggRawUI") then CoreGui.StealEggRawUI:Destroy() end

if _G.SpeedConn then _G.SpeedConn:Disconnect() end
if _G.FlyConn then _G.FlyConn:Disconnect() end
if _G.AfkConn then _G.AfkConn:Disconnect() end

-- [[ 2. สร้างสวิตช์ตัวอักษรลอยแบบไร้โครงสร้างหน้าต่าง (Undetectable Setup) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealEggRawUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- สวิตช์อักษรย่อ S (Speed) - ทรงเหลี่ยมมุม 90° ไร้กรอบพื้นหลัง
local S_Button = Instance.new("TextButton")
S_Button.Name = "S"
S_Button.Size = UDim2.new(0, 35, 0, 35)
S_Button.Position = UDim2.new(0.5, -40, 0.1, 0) -- ลอยอยู่บริเวณบนกลางจอขยับได้
S_Button.BackgroundTransparency = 1 -- ล่องหนพื้นหลังทั้งหมดเพื่อไม่ให้เซิร์ฟเวอร์สแกนเจอ
S_Button.Text = "S"
S_Button.TextColor3 = Color3.fromRGB(255, 0, 0) -- เริ่มต้นสีแดงสด (OFF)
S_Button.Font = Enum.Font.Code -- ฟอนต์เหลี่ยมคลาสสิก
S_Button.TextSize = 28
S_Button.Active = true
S_Button.Draggable = true -- ใช้นิ้วลากเคลื่อนย้ายตำแหน่งตัวอักษรบนจอมือถือได้อิสระ
S_Button.Parent = ScreenGui

-- เส้นขอบเหลี่ยมสีแดงสดรอบตัวอักษร S
local S_Stroke = Instance.new("UIStroke")
S_Stroke.Color = Color3.fromRGB(255, 0, 0)
S_Stroke.Thickness = 2
S_Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
S_Stroke.Parent = S_Button

-- สวิตช์อักษรย่อ F (Fly) - ทรงเหลี่ยมมุม 90° ไร้กรอบพื้นหลัง
local F_Button = Instance.new("TextButton")
F_Button.Name = "F"
F_Button.Size = UDim2.new(0, 35, 0, 35)
F_Button.Position = UDim2.new(0.5, 5, 0.1, 0)
F_Button.BackgroundTransparency = 1
F_Button.Text = "F"
F_Button.TextColor3 = Color3.fromRGB(255, 0, 0) -- เริ่มต้นสีแดงสด (OFF)
F_Button.Font = Enum.Font.Code
F_Button.TextSize = 28
F_Button.Active = true
F_Button.Draggable = true -- ใช้นิ้วลากเคลื่อนย้ายทิศทางได้อิสระเช่นกัน
F_Button.Parent = ScreenGui

local F_Stroke = Instance.new("UIStroke")
F_Stroke.Color = Color3.fromRGB(255, 0, 0)
F_Stroke.Thickness = 2
F_Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
F_Stroke.Parent = F_Button


-- [[ 3. ระบบฟังก์ชันเบื้องหลังและตรรกะคำนวณตำแหน่งพิกัด ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SuperSpeedEnabled = false
local SpeedMultiplier = 3.0 -- ปรับแต่งความเร็วเพิ่มที่ตรงนี้ได้ตามสะดวก
local FlyEnabled = false
local FlySpeed = 150 -- ปรับแต่งระดับความเร็วบินตรงนี้ได้ตามสะดวก

local function updateBypassLoops()
    if _G.SpeedConn then _G.SpeedConn:Disconnect(); _G.SpeedConn = nil end
    if _G.FlyConn then _G.FlyConn:Disconnect(); _G.FlyConn = nil end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- ลูปรันเดินเร็ว (เฉพาะเมื่อเปิดใช้งานจริง)
    if SuperSpeedEnabled and not FlyEnabled then
        _G.SpeedConn = RunService.Heartbeat:Connect(function(deltaTime)
            local c = LocalPlayer.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h and r and h.MoveDirection.Magnitude > 0 then
                r.CFrame = r.CFrame + (h.MoveDirection * (h.WalkSpeed * SpeedMultiplier) * deltaTime)
            end
        end)
    end
    
    -- ลูปรันระบบบิน (Bypass ระบบตรวจจับ 1518/2518)
    if FlyEnabled then
        _G.FlyConn = RunService.Heartbeat:Connect(function(deltaTime)
            local c = LocalPlayer.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if not r or not h then return end
            
            r.Velocity = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            if h.MoveDirection.Magnitude > 0 and camera then
                local flyVelocity = (camera.CFrame.LookVector * (h.MoveDirection.Z * -1) + camera.CFrame.RightVector * h.MoveDirection.X).Unit
                local nextCFrame = r.CFrame + (flyVelocity * FlySpeed * deltaTime)
                
                -- ล็อกระดับความปลอดภัยเพดานบิน
                local currentY = nextCFrame.Y
                if currentY < -50 then
                    nextCFrame = CFrame.new(nextCFrame.X, -50, nextCFrame.Z)
                elseif currentY > 1000 then
                    nextCFrame = CFrame.new(nextCFrame.X, 1000, nextCFrame.Z)
                end
                r.CFrame = nextCFrame
            end
        end)
    end
end

-- การทำงานของสวิตช์ S (Speed)
S_Button.MouseButton1Click:Connect(function()
    SuperSpeedEnabled = not SuperSpeedEnabled
    if SuperSpeedEnabled then 
        FlyEnabled = false 
        F_Button.TextColor3 = Color3.fromRGB(255, 0, 0)
        F_Stroke.Color = Color3.fromRGB(255, 0, 0)
    end
    
    -- เปลี่ยนสีแสดงสถานะการกด
    S_Button.TextColor3 = SuperSpeedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    S_Stroke.Color = SuperSpeedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    updateBypassLoops()
end)

-- การทำงานของสวิตช์ F (Fly)
F_Button.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then 
        SuperSpeedEnabled = false 
        S_Button.TextColor3 = Color3.fromRGB(255, 0, 0)
        S_Stroke.Color = Color3.fromRGB(255, 0, 0)
    end
    
    F_Button.TextColor3 = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    F_Stroke.Color = FlyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    if not FlyEnabled then
        pcall(function() LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end)
    end
    updateBypassLoops()
end)

-- ระบบล็อกการป้องกันห้องหลุด (Anti-AFK) แบบลดความเสี่ยง 100%
local VirtualUser = game:GetService("VirtualUser")
_G.AfkConn = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

print("--- STEAL EGG RAW SWITCHES LOADED COMPLETE ---")
