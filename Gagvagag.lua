-- [[ 2026 UI-Based Egg Name Extractor for Mobile Executor ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local EggList = {}
local foundCount = 0

-- 1. ทำการดึงข้อมูลจากตำแหน่ง UI ในเครื่อง
for _, gui in pairs(PlayerGui:GetChildren()) do
    local mainUI = gui:FindFirstChild("RScrambleEventUIMain")
    if mainUI then
        local contentFrame = mainUI:FindFirstChild("ContentFrame")
        local scrollingFrame = contentFrame and contentFrame:FindFirstChild("ScrollingFrame")
        
        if scrollingFrame then
            for _, item in pairs(scrollingFrame:GetChildren()) do
                if item.Name == "ShopItem" and item:FindFirstChild("Card") then
                    local card = item.Card
                    local eggNameLabel = card:FindFirstChild("EggName")
                    
                    if eggNameLabel and eggNameLabel:IsA("TextLabel") then
                        local currentEggName = eggNameLabel.Text
                        if not table.find(EggList, currentEggName) then
                            foundCount = foundCount + 1
                            table.insert(EggList, currentEggName)
                        end
                    end
                end
            end
        end
    end
end

-- 2. สร้างหน้าต่าง GUI กลางหน้าจอเพื่อแสดงผลลัพธ์และให้กดก๊อปปี้ได้
if foundCount > 0 then
    -- ประกอบร่าง String โค้ด
    local finalCode = "local AvailableEggs = {\n"
    for _, name in ipairs(EggList) do
        finalCode = finalCode .. string.format("    \"%s\",\n", name)
    end
    finalCode = finalCode .. "}"

    -- สร้างหน้าต่างแจ้งเตือนบนจอเกม
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local CloseBtn = Instance.new("TextButton")

    ScreenGui.Name = "EggExtractorUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame.Size = UDim2.new(0, 320, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "ดึงข้อมูลสำเร็จ! พบไข่ " .. foundCount .. " ใบ"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.Parent = MainFrame

    -- ช่อง TextBox สำหรับให้ผู้เล่นใช้นิ้วกดค้างเพื่อก๊อปปี้ข้อความไปเขียนโค้ดต่อ
    TextBox.Size = UDim2.new(0, 300, 0, 160)
    TextBox.Position = UDim2.new(0, 10, 0, 40)
    TextBox.Text = finalCode
    TextBox.ClearTextOnFocus = false
    TextBox.MultiLine = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TextBox.Parent = MainFrame

    CloseBtn.Size = UDim2.new(1, 0, 0, 30)
    CloseBtn.Position = UDim2.new(0, 0, 1, -30)
    CloseBtn.Text = "ปิดหน้าต่างนี้"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
else
    -- กรณีไม่พบข้อความ ให้สร้างแจ้งเตือนสั้น ๆ
    local Hint = Instance.new("Hint")
    Hint.Text = "❌ ไม่เจอโครงสร้างเมนูไข่ กรุณาเปิดหน้าเมนูไข่ค้างไว้บนหน้าจอก่อนรันสคริปต์นี้!"
    Hint.Parent = Workspace
    task.wait(4)
    Hint:Destroy()
end
