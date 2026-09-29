-- [[ 2026 UI God Switch V2 - Anti Ragdoll & Anti Thief Guard ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

_G.GodModeState = false -- เริ่มต้นปิดใช้งานก่อน

-- ระบบวนลูปตรวจสอบและล็อกฟิสิกส์ร่างกายไม่ให้ล้ม/กลิ้ง (ทำงานระนาบสูงพิเศษ)
local godLoop
godLoop = RunService.Heartbeat:Connect(function()
    if _G.GodModeState then
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp then
            -- 1. บังคับล็อกสถานะกระดูกให้ยืนตรง ห้ามเปลี่ยนเป็นท่านอนล้มเด็ดขาด
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            humanoid.PlatformStand = false
            
            -- 2. สลายแรงบิดที่ทำให้ตัวละครหมุนติ้วหรือพลิกคว่ำ
            hrp.RotVelocity = Vector3.new(0, 0, 0)
            
            -- 3. เจาะทำลายสคริปต์สะท้อนแรงผลักซ้ำเผื่อเกมสร้างใหม่ตอนโดนชน
            local antiCol = char:FindFirstChild("AntiCollisionHighSeedPushBack")
            if antiCol then antiCol:Destroy() end
        end
        
        -- 4. แฮกฝั่งสัตว์ยาม: สั่งปิดชิ้นส่วนที่มันใช้สัมผัสเพื่อขโมยไข่เราคืน (ถ้ามันเดินมาใกล้ตัวเรา)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "guard") or string.find(string.lower(obj.Name), "monster")) then
                obj.CanCollide = false
                -- ดักลบ TouchTransmitter ในตัวมันออกชั่วคราวเพื่อไม่ให้มันเคลมไข่คืนจากมือเรา
                local touch = obj:FindFirstChildOfClass("TouchTransmitter")
                if touch then touch:Destroy() end
            end
        end
    end
end)

-- === [ ส่วนการสร้างหน้าต่าง UI สวิตช์อัปเกรด ] ===
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local SwitchBtn = Instance.new("TextButton")
local BtnCorner = Instance.new("UICorner")

ScreenGui.Name = "GodSwitchUIV2"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Size = UDim2.new(0, 180, 0, 95)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "ระบบป้องกันยามชน V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

SwitchBtn.Size = UDim2.new(0, 150, 0, 45)
SwitchBtn.Position = UDim2.new(0.5, -75, 0.5, -5)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- เริ่มต้นสีแดง (ยังไม่เปิดโกง)
SwitchBtn.Text = "โหมดโกง: ปิดอยู่ (โดนชนล้ม)"
SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchBtn.TextSize = 13
SwitchBtn.Font = Enum.Font.SourceSansBold
SwitchBtn.Parent = MainFrame

BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SwitchBtn

SwitchBtn.MouseButton1Click:Connect(function()
    _G.GodModeState = not _G.GodModeState
    
    if _G.GodModeState then
        -- เปิดโหมดอมตะ แข็งแกร่งยามชนไม่ล้ม (เปลี่ยนเป็นสีเขียว)
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 50)}):Play()
        SwitchBtn.Text = "โหมดโกง: เปิด (ชนไม่ล้ม/ไม่เสียไข่)"
    else
        -- ปิดโหมดโกงกลับสู่สภาพปกติ (เปลี่ยนเป็นสีแดง)
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}):Play()
        SwitchBtn.Text = "โหมดโกง: ปิดอยู่ (โดนชนล้ม)"
    end
end)
