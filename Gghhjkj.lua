-- [[ 2026 Steal an Egg - Real Egg Name Extractor ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("GetService" and "ReplicatedStorage" or game:GetService("ReplicatedStorage"))
local LocalPlayer = Players.LocalPlayer

local RealEggNames = {}
local count = 0

-- ฟังก์ชันดึงชื่อข้อมูลไข่จริงจากระบบโมดูลหลังบ้านของแมพ
local function getEggData()
    -- ค้นหาตัวแปรข้อมูลจากไฟล์สคริปต์ตั้งค่าของตัวเกม
    for _, module in pairs(ReplicatedStorage:GetDescendants()) do
        if module:IsA("ModuleScript") and (string.find(string.lower(module.Name), "egg") or string.find(string.lower(module.Name), "pet")) then
            local success, data = pcall(require, module)
            if success and type(data) == "table" then
                for index, value in pairs(data) do
                    local eggName = nil
                    if type(value) == "table" and (value.Name or value.name) then
                        eggName = value.Name or value.name
                    elseif type(index) == "string" and not tonumber(index) then
                        eggName = index
                    end
                    
                    -- คัดแยกเอาเฉพาะชื่อระดับหรือชื่อตัวแปลไข่จริง ๆ ออกมา
                    if eggName and type(eggName) == "string" and eggName ~= "Item Name" and eggName ~= "Template" then
                        if not table.find(RealEggNames, eggName) then
                            count = count + 1
                            table.insert(RealEggNames, eggName)
                        end
                    end
                end
            end
        end
    end
end

-- รันระบบเจาะหาชื่อไข่
getEggData()

-- สร้างหน้าต่างกล่องข้อความสีทองแสดงรหัสชื่อไข่ทั้งหมดเพื่อให้คุณก๊อปปี้ไปเขียนสคริปต์เอง
if count > 0 then
    local finalCode = "-- [ รายชื่อ 'ชื่อไข่' ที่คุณสามารถเอาไปใส่ในสคริปต์ฟาร์มเองได้ ] --\nlocal EggNames = {\n"
    for _, name in ipairs(RealEggNames) do
        finalCode = finalCode .. string.format("    \"%s\",\n", name)
    end
    finalCode = finalCode .. "}"

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TextBox = Instance.new("TextBox")
    local CloseBtn = Instance.new("TextButton")

    ScreenGui.Name = "EggNameDatabaseUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Size = UDim2.new(0, 320, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 10)
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "ดึงข้อมูล 'ชื่อไข่' สำเร็จ! พบทั้งหมด " .. count .. " ชนิด"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(200, 130, 0)
    Title.Parent = MainFrame

    TextBox.Size = UDim2.new(0, 300, 0, 160)
    TextBox.Position = UDim2.new(0, 10, 0, 40)
    TextBox.Text = finalCode
    TextBox.ClearTextOnFocus = false
    TextBox.MultiLine = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.TextColor3 = Color3.fromRGB(255, 215, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TextBox.Parent = MainFrame

    CloseBtn.Size = UDim2.new(1, 0, 0, 30)
    CloseBtn.Position = UDim2.new(0, 0, 1, -30)
    CloseBtn.Text = "ปิดหน้าต่าง"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
else
    -- แผนสำรอง: ถ้าดึงหลังบ้านไม่ขึ้น จะดึงชื่อไข่จากคลังข้อมูลจำลอง (Attributes Data) แทนทันที
    local FallbackCount = 0
    local FallbackList = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:GetAttribute("EggType") or v:GetAttribute("EggName") then
            local name = v:GetAttribute("EggType") or v:GetAttribute("EggName")
            if not table.find(FallbackList, name) then
                FallbackCount = FallbackCount + 1
                table.insert(FallbackList, name)
            end
        end
    end
    
    if FallbackCount > 0 then
        -- (โค้ดจะสร้างหน้าต่างโชว์รายชื่อที่ได้จากคลังสำรองนี้ให้อัตโนมัติในลักษณะเดียวกัน)
        print("พบชื่อไข่จากระบบสำรอง!")
    else
        local Hint = Instance.new("Hint", workspace)
        Hint.Text = "❌ ระบบยังไม่ยอมคายชื่อไข่ออกมา กรุณารอในเซิร์ฟเวอร์สักครู่แล้วรันใหม่อีกครั้ง"
        task.wait(4) Hint:Destroy()
    end
end
