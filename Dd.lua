-- [[ 1. สั่งกวาดล้างและทำลาย UI ทุกเวอร์ชันที่เคยค้างอยู่ในเครื่องให้หมดสิ้น ]] --
local CoreGui = game:GetService("CoreGui")
local function ForceClearUI(name)
    local target = CoreGui:FindFirstChild(name)
    if target then 
        target:Destroy() 
        print("Wiped Old UI: " .. name)
    end
end

-- สั่งทำลายชื่อหน้าต่างเก่าทั้งหมดที่เคยเขียนมา
ForceClearUI("StealEggClassicHub")
ForceClearUI("StealEggMiniHub")
ForceClearUI("StealEggAndroidHub")
ForceClearUI("StealEggCustomHub")
ForceClearUI("StealEggUltimateHub")
ForceClearUI("StealEggProHub")

-- [[ 2. เคลียร์ค่าลูปและคำสั่งเก่าเพื่อความปลอดภัย ]] --
if _G.ChatBypassConnection then _G.ChatBypassConnection:Disconnect() end
if _G.SpeedConn then _G.SpeedConn:Disconnect() end
if _G.FlyConn then _G.FlyConn:Disconnect() end

-- [[ 3. เริ่มระบบสั่งการผ่านช่องแชท (No UI ของจริง) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SuperSpeedEnabled = false
local SpeedMultiplier = 2.5 
local FlyEnabled = false
local FlySpeed = 150

local function updateBypassMovement()
    if _G.SpeedConn then _G.SpeedConn:Disconnect(); _G.SpeedConn = nil end
    if _G.FlyConn then _G.FlyConn:Disconnect(); _G.FlyConn = nil end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
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
                
                if nextCFrame.Y < -50 then
                    nextCFrame = CFrame.new(nextCFrame.X, -50, nextCFrame.Z)
                elseif nextCFrame.Y > 1000 then
                    nextCFrame = CFrame.new(nextCFrame.X, 1000, nextCFrame.Z)
                end
                r.CFrame = nextCFrame
            end
        end)
    end
end

_G.ChatBypassConnection = LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = string.lower(args[1])
    
    if command == ":speed" or command == "/speed" then
        SuperSpeedEnabled = not SuperSpeedEnabled
        if SuperSpeedEnabled then FlyEnabled = false end
        if args[2] and tonumber(args[2]) then SpeedMultiplier = tonumber(args[2]) end
        updateBypassMovement()
        
    elseif command == ":fly" or command == "/fly" then
        FlyEnabled = not FlyEnabled
        if FlyEnabled then SuperSpeedEnabled = false end
        if args[2] and tonumber(args[2]) then FlySpeed = tonumber(args[2]) end
        if not FlyEnabled then
            pcall(function() LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end)
        end
        updateBypassMovement()
    end
end)

-- ระบบกันหลุดถาวร (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
if _G.AfkConn then _G.AfkConn:Disconnect() end
_G.AfkConn = LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("--- FORCE WIPE & CHAT SYSTEM ACTIVE ---")
