-- [[ 2026 Deep Scan Egg Extractor - Run Anywhere ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local EggList = {}
local foundCount = 0

-- ฟังก์ชันค้นหาแบบ Deep Scan วนลูปหาในทุกๆ UI ทุกชั้น
local function deepScan(object)
    if object.Name == "ShopItem" and object:FindFirstChild("Card") then
        local card = object.Card
        local eggNameLabel = card:FindFirstChild("EggName")
        if eggNameLabel and eggNameLabel:IsA("TextLabel") and eggNameLabel.Text ~= "" then
            local currentEggName = eggNameLabel.Text
            if not table.find(EggList, currentEggName) then
                foundCount = foundCount + 1
                table.insert(EggList, currentEggName)
            end
        end
    end
    for _, child in pairs(object:GetChildren()) do
        deepScan(child)
    end
end

-- สั่งสแกนจากระดับรากของ PlayerGui ทันที โดยไม่ต้องเปิดหน้าต่างเกมค้างไว้
deepScan(PlayerGui)

-- สร้างหน้าต่างแสดงผลข้อความกลางหน้าจอ
if foundCount > 0 then
    local finalCode = "local AvailableEggs = {\n"
    for _, name in ipairs(EggList) do
        finalCode = finalCode .. string.format("    \"%s\",\n", name)
    end
    finalCode = finalCode .. "}"

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local CloseBtn = Instance.new("TextButton")

    ScreenGui.Name = "DeepEggExtractorUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame.Size = UDim2.new(0, 320, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "Deep Scan สำเร็จ! พบไข่ทั้งหมด " .. foundCount .. " ใบ"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.Parent = MainFrame

    TextBox.Size = UDim2.new(0, 300, 0, 160)
    TextBox.Position = UDim2.new(0, 10, 0, 40)
    TextBox.Text = finalCode
    TextBox.ClearTextOnFocus = false
    TextBox.MultiLine = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.TextColor3 = Color3.fromRGB(0, 255, 255)
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
    local Hint = Instance.new("Hint")
    Hint.Text = "❌ ระบบยังไม่พบข้อมูลตู้สุ่มไข่ในเครื่องของคุณ กรุณารอให้แมพโหลดเสร็จสมบูรณ์แล้วลองรันใหม่อีกครั้งครับ"
    Hint.Parent = game:GetService("Workspace")
    task.wait(4)
    Hint:Destroy()
end
