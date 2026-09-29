-- [[ 2026 Ultimate Module Data Extractor ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local EggList = {}
local foundCount = 0

-- ฟังก์ชันค้นหาข้อมูลจากระบบข้อมูลดิบของเกม (ModuleScript)
local function searchModules(root)
    for _, obj in pairs(root:GetDescendants()) do
        if obj:IsA("ModuleScript") then
            -- ค้นหาโมดูลที่น่าจะเก็บข้อมูลไข่ (เช่น Eggs, EggData, Config, Database)
            if string.find(string.lower(obj.Name), "egg") or string.find(string.lower(obj.Name), "shop") or string.find(string.lower(obj.Name), "config") then
                local success, result = pcall(require, obj)
                if success and type(result) == "table" then
                    -- แกะตารางข้อมูลเพื่อค้นหาชื่อไข่
                    for key, val in pairs(result) do
                        local nameToCheck = nil
                        if type(val) == "table" and (val.Name or val.name) then
                            nameToCheck = val.Name or val.name
                        elseif type(key) == "string" and not tonumber(key) then
                            nameToCheck = key
                        end
                        
                        if nameToCheck and type(nameToCheck) == "string" and nameToCheck ~= "Item Name" and not table.find(EggList, nameToCheck) then
                            foundCount = foundCount + 1
                            table.insert(EggList, nameToCheck)
                        end
                    end
                end
            end
        end
    end
end

-- สแกนในคลังข้อมูลร่วม (ReplicatedStorage) จุดที่เกมมักเก็บค่าตู้สุ่มไว้
searchModules(ReplicatedStorage)

-- ถ้ายังไม่เจอ ให้ค้นหาในตำแหน่งอื่นที่ส่งผ่านเซิร์ฟเวอร์
if foundCount == 0 then
    searchModules(game:GetService("HttpService"))
    searchModules(LocalPlayer:WaitForChild("PlayerGui"))
end

-- สร้างหน้าต่างแสดงผลลัพธ์ข้อมูลดิบกลางหน้าจอ
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

    ScreenGui.Name = "ModuleEggExtractorUI"
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame.Size = UDim2.new(0, 320, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 2
    MainFrame.Parent = ScreenGui

    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "เจาะฐานข้อมูลสำเร็จ! พบไข่จริง " .. foundCount .. " ใบ"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    Title.Parent = MainFrame

    TextBox.Size = UDim2.new(0, 300, 0, 160)
    TextBox.Position = UDim2.new(0, 10, 0, 40)
    TextBox.Text = finalCode
    TextBox.ClearTextOnFocus = false
    TextBox.MultiLine = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.TextColor3 = Color3.fromRGB(255, 200, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TextBox.Parent = MainFrame

    CloseBtn.Size = UDim2.new(1, 0, 0, 30)
    CloseBtn.Position = UDim2.new(0, 0, 1, -30)
    CloseBtn.Text = "ปิดหน้าต่าง"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
else
    local Hint = Instance.new("Hint")
    Hint.Text = "❌ ระบบยังไม่สามารถดึงค่าดิบได้ ตัวรันนินจาอาจจะโดนเกมบล็อกการสแกนโมดูลชั่วคราวครับ"
    Hint.Parent = game:GetService("Workspace")
    task.wait(4)
    Hint:Destroy()
end
