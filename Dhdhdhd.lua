-- [[ 2026 Current Egg Name Extractor via PlayerGui ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local EggList = {}
local foundCount = 0

-- สแกนค้นหาลึกลงไปใน UI ตามโครงสร้าง RScrambleEventUIMain
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
                        -- ตรวจสอบเพื่อไม่ให้ชื่อไข่ซ้ำกันในรายการ
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

-- พิมพ์ผลลัพธ์การสแกนออกมาในรูปแบบ Array เพื่อนำไปพัฒนาต่อ
if foundCount > 0 then
    print("\n--- [ สแกนพบรายชื่อไข่ทั้งหมดในปัจจุบัน ] ---")
    local formattedString = "local AvailableEggs = {\n"
    
    for i, name in ipairs(EggList) do
        print(string.format("[%d] Found Egg Name: \"%s\"", i, name))
        formattedString = formattedString .. string.format("    \"%s\",\n", name)
    end
    
    formattedString = formattedString .. "}"
    
    -- ทำการบันทึกรายชื่อลงคลิปบอร์ดในเครื่องผู้เล่นทันที (ถ้าตัวรันรองรับคำสั่ง setclipboard)
    if setclipboard then
        setclipboard(formattedString)
        print("✅ ดึงชื่อไข่สำเร็จ! และได้เซฟโค้ดรูปแบบ Array ลง Clipboard ของคุณแล้ว สามารถกดวาง (Paste) ในเท็กซ์สคริปต์ของคุณได้เลย")
    else
        print("❌ ตัวรันไม่รองรับ setclipboard แนะนำให้ดูรายชื่อด้านบนแล้วนำพิมพ์ใส่โค้ดเองครับ")
    end
else
    warn("❌ ไม่พบข้อมูลรายชื่อไข่ กรุณาตรวจสอบว่าเปิดหน้า UI ตู้สุ่มไข่ที่หน้าจอเกมอยู่หรือไม่ก่อนกดรันสคริปต์นี้")
end
