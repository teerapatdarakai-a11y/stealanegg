-- [[ 2026 UI Switch CanTouch Controller for Mobile ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ตัวแปรสถานะเริ่มต้น (true = สภาพปกติ, false = โหมดผีสัตว์ยามจับไม่ได้)
_G.CanTouchState = true 

-- ฟังก์ชันสำหรับอัปเดตค่า CanTouch ในร่างกาย
local function updateBodyTouch()
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = _G.CanTouchState
            end
        end
    end
end

-- ดักจับระบบตอนตัวละครเกิดใหม่ให้ค่าทำงานต่อเนื่อง
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    updateBodyTouch()
end)

-- === [ ส่วนการสร้างหน้าต่าง UI สวิตช์บนจอ ] ===
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local SwitchBtn = Instance.new("TextButton")
local BtnCorner = Instance.new("UICorner")

ScreenGui.Name = "TouchSwitchUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ตัวหน้าต่างหลัก (ปรับขนาดให้เหมาะกับจอมือถือ)
MainFrame.Size = UDim2.new(0, 160, 0, 90)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0) -- โผล่ฝั่งซ้ายของจอ
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- เปิดระบบให้ใช้นิ้วลากเลื่อนปุ่มไปมาบนจอได้
MainFrame.Parent = ScreenGui

FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

-- หัวข้อบอกสถานะ
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "ระบบตัดการสัมผัส"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- ปุ่มสวิตช์เปิด/ปิด (Switch)
SwitchBtn.Size = UDim2.new(0, 130, 0, 40)
SwitchBtn.Position = UDim2.new(0.5, -65, 0.5, -10)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100) -- เริ่มต้นสีเขียว (สถานะปกติ)
SwitchBtn.Text = "สถานะ: ปกติ (ชนได้)"
SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchBtn.TextSize = 14
SwitchBtn.Font = Enum.Font.SourceSansBold
SwitchBtn.BorderSizePixel = 0
SwitchBtn.Parent = MainFrame

BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SwitchBtn

-- ตรรกะเมื่อกดปุ่มสวิตช์
SwitchBtn.MouseButton1Click:Connect(function()
    _G.CanTouchState = not _G.CanTouchState -- สลับสถานะ true / false
    updateBodyTouch() -- สั่งอัปเดตร่างกายทันที
    
    -- เปลี่ยนสีและข้อความบนปุ่มตามสถานะปัจจุบัน
    if _G.CanTouchState then
        -- โหมดปกติ (สีเขียว)
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 100)}):Play()
        SwitchBtn.Text = "สถานะ: ปกติ (อุ้มไข่ได้)"
    else
        -- โหมดโกง/เปิดร่างผี (สีแดง)
        TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        SwitchBtn.Text = "สถานะ: ผี (ยามไม่ชน)"
    end
end)

print("✅ สคริปต์สวิตช์ CanTouch โหลดเสร็จสิ้น! สามารถกดสลับโหมดบนจอได้เลย")
