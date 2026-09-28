-- ============================================================================
-- 👑 STEAL AN EGG: SPECIFIC EGG NAMES EDITION (v6.6 Clean & Fixed)
-- ============================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if playerGui and playerGui:FindFirstChild("StealAnEggBypass_UI") then
    playerGui.StealAnEggBypass_UI:Destroy()
end

local isAutoActive = false
local currentWorker = nil
local activeConns = {}

-- ============================================================================
-- ⚙️ CONFIGURATION & TARGET EGGS LIST
-- ============================================================================
local TARGET_EGGS = {
    -- Custom Specific Eggs
    ["Pegasus Egg"] = true, ["Skeleton Horse Egg"] = true, ["World Burner Egg"] = true, ["Burner Egg"] = true,
    ["Centaur Egg"] = true, ["Gargoyle Egg"] = true, ["Jellyfish Egg"] = true, ["Razorfang Egg"] = true,
    ["Gorilla King Egg"] = true, ["Shark Egg"] = true, ["Kitsune Egg"] = true, ["Oni Tiger Egg"] = true,
    ["Oni Egg"] = true, ["Stag Egg"] = true, ["Dragon Egg"] = true, ["Skeleton Warrior Egg"] = true,
    ["Lunar Horse Egg"] = true, ["Mosasaurus Egg"] = true, ["Tralaledon Egg"] = true,
    ["Phoenix Egg"] = true, ["Cerberus Egg"] = true, ["Kraken Egg"] = true,
    ["Chicken Egg"] = true, ["TRex Egg"] = true
}

local BLACKLIST_KEYS = { "sell", "shop", "combine", "craft", "fuse", "hatch", "upgrade", "place", "base", "plot" }

-- ============================================================================
-- 🧹 CLEANUP & WORKER MANAGEMENT
-- ============================================================================
local function StopWorker()
    if currentWorker then
        task.cancel(currentWorker)
        currentWorker = nil
    end
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        humanoid:MoveTo(hrp.Position)
    end
end

local function HardCleanup()
    isAutoActive = false
    StopWorker()
    for _, conn in ipairs(activeConns) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(activeConns)
end

table.insert(activeConns, player.CharacterAdded:Connect(StopWorker))
table.insert(activeConns, player.CharacterRemoving:Connect(StopWorker))

-- ============================================================================
-- 🎨 USER INTERFACE
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealAnEggBypass_UI"
screenGui.ResetOnSpawn = false
if playerGui then screenGui.Parent = playerGui end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 210)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 220, 130)
stroke.Thickness = 2

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 42)
titleLabel.BackgroundColor3 = Color3.fromRGB(24, 30, 38)
titleLabel.Text = "   🛡️ STEAL AN EGG: TARGET FIX v6.6"
titleLabel.TextColor3 = Color3.fromRGB(0, 220, 130)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 11
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 10)

local minimizeBtn = Instance.new("TextButton", titleLabel)
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -66, 0.5, -14)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 85)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 12
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local destroyBtn = Instance.new("TextButton", titleLabel)
destroyBtn.Size = UDim2.new(0, 28, 0, 28)
destroyBtn.Position = UDim2.new(1, -34, 0.5, -14)
destroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
destroyBtn.Text = "✕"
destroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 13
Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0, 6)

local monitor = Instance.new("TextLabel", mainFrame)
monitor.Size = UDim2.new(1, -30, 0, 40)
monitor.Position = UDim2.new(0, 15, 0, 55)
monitor.BackgroundColor3 = Color3.fromRGB(26, 34, 44)
monitor.Text = "STATUS: WAITING FOR UI RESET..."
monitor.TextColor3 = Color3.fromRGB(180, 190, 200)
monitor.Font = Enum.Font.GothamSemibold
monitor.TextSize = 11
Instance.new("UICorner", monitor).CornerRadius = UDim.new(0, 8)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(1, -30, 0, 85)
toggleBtn.Position = UDim2.new(0, 15, 0, 108)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
toggleBtn.Text = "AUTO DETECT: ON"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

isAutoActive = true

minimizeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
destroyBtn.MouseButton1Click:Connect(function() HardCleanup() screenGui:Destroy() end)

toggleBtn.MouseButton1Click:Connect(function()
    isAutoActive = not isAutoActive
    if isAutoActive then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        toggleBtn.Text = "AUTO DETECT: ON"
        monitor.Text = "STATUS: WAITING FOR UI RESET..."
    else
        StopWorker()
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 62)
        toggleBtn.Text = "AUTO DETECT: OFF"
        monitor.Text = "STATUS: PAUSED"
    end
end)

-- ============================================================================
-- 🔍 HELPER FUNCTIONS & TARGET SEARCH ENGINE
-- ============================================================================
local function HasEgg()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Model") or item:IsA("Tool") then
            local name = string.lower(item.Name)
            if string.find(name, "egg") or string.find(name, "carrying") or string.find(name, "stolen") then
                return true
            end
        end
    end
    return false
end

local function FindBasePos()
    for _, fName in ipairs({"Bases", "Plots", "Islands", "Tycoons"}) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, base in ipairs(folder:GetChildren()) do
                local owner = base:GetAttribute("Owner") or ""
                if string.find(string.lower(base.Name), string.lower(player.Name)) or tostring(owner) == tostring(player.UserId) then
                    if base:FindFirstChild("Core") then return base.Core.Position end
                    if base.PrimaryPart then return base.PrimaryPart.Position end
                    return base:GetPivot().Position
                end
            end
        end
    end
    local spawnLoc = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    return spawnLoc and spawnLoc.Position or Vector3.new(0, 5, 0)
end

local function SearchTarget()
    local fallbackPart, fallbackPrompt = nil, nil

    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local parent = prompt.Parent
            if parent then
                local part = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart") or parent.PrimaryPart
                if not part and parent.Parent then
                    part = parent.Parent:FindFirstChildWhichIsA("BasePart") or parent.Parent.PrimaryPart
                end

                if part then
                    local pName = string.lower(tostring(parent.Name))
                    local ppName = parent.Parent and string.lower(tostring(parent.Parent.Name)) or ""
                    local pppName = (parent.Parent and parent.Parent.Parent) and string.lower(tostring(parent.Parent.Parent.Name)) or ""
                    local actTxt = string.lower(tostring(prompt.ActionText or ""))
                    local objTxt = string.lower(tostring(prompt.ObjectText or ""))
                    
                    local fullStr = pName .. " " .. ppName .. " " .. pppName .. " " .. actTxt .. " " .. objTxt

                    local skip = false
                    for _, bKey in ipairs(BLACKLIST_KEYS) do
                        if string.find(fullStr, bKey) then skip = true break end
                    end

                    if not skip then
                        for keyName, _ in pairs(TARGET_EGGS) do
                            if string.find(fullStr, string.lower(keyName)) then
                                return part, prompt, keyName
                            end
                        end
                        
                        if string.find(fullStr, "egg") or string.find(fullStr, "steal") or string.find(fullStr, "take") then
                            fallbackPart = part
                            fallbackPrompt = prompt
                        end
                    end
                end
     Rarity end
        end
    end

    if fallbackPart and fallbackPrompt then
        return fallbackPart, fallbackPrompt, "EGG"
    end
    return nil, nil, nil
end

local function MoveToTarget(targetPos)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end

    if (hrp.Position - targetPos).Magnitude < 18 then
        humanoid:MoveTo(targetPos)
        local t = tick()
        while isAutoActive and (hrp.Position - targetPos).Magnitude > 5 do
            task.wait(0.1)
            if tick() - t > 2.5 then break end
        end
        return (hrp.Position - targetPos).Magnitude <= 7
    end

    local path = PathfindingService:CreatePath({ AgentRadius = 2.0, AgentHeight = 5.0, AgentCanJump = true })
    pcall(function() path:ComputeAsync(hrp.Position, targetPos) end)

    if path.Status == Enum.PathStatus.Success then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            if not isAutoActive then break end
            if waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
            
            humanoid:MoveTo(waypoint.Position)
            local lastPos = hrp.Position
            local t = tick()
            
            while isAutoActive and (hrp.Position - waypoint.Position).Magnitude > 4 do
                task.wait(0.05)
                if tick() - t > 0.6 and (hrp.Position - lastPos).Magnitude < 0.5 then
                    humanoid.Jump = true
                    break
                end
                if tick() - t > 1.2 then break end
            end
        end
    else
        humanoid:MoveTo(targetPos)
        task.wait(0.8)
    end
    return (hrp.Position - targetPos).Magnitude <= 8
end

local function SafeTrigger(prompt)
    if not prompt or not prompt.Parent then return end
    task.wait(0.1)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, prompt.HoldDuration or 0)
        elseif prompt.InputHoldBegin then
            prompt:InputHoldBegin()
            task.wait((prompt.HoldDuration or 0) + 0.1)
            prompt:InputHoldEnd()
        end
    end)
end

-- ============================================================================
-- 🎯 UI RESET EVENT DETECTOR & DISPATCHER
-- ============================================================================
local function TriggerEggFarmSequence()
    if not isAutoActive or currentWorker then return end

    currentWorker = task.spawn(function()
        monitor.Text = "STATUS: 🚨 ALL EGG RESET DETECTED!"
        monitor.TextColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(0.2)

        local part, prompt, foundKey = nil, nil, nil
        local scanTime = tick()

        while isAutoActive and (tick() - scanTime < 6.0) do
            part, prompt, foundKey = SearchTarget()
            if part and prompt then break end
            monitor.Text = "STATUS: 🔍 SEARCHING TARGET EGG..."
            monitor.TextColor3 = Color3.fromRGB(255, 180, 50)
            task.wait(0.3)
        end

        if part and prompt then
            monitor.Text = "STATUS: 🏃 GOING TO [" .. string.upper(foundKey or "EGG") .. "]"
            monitor.TextColor3 = Color3.fromRGB(255, 200, 80)

            local reached = MoveToTarget(part.Position)
            if reached and isAutoActive then
                monitor.Text = "STATUS: 🥚 STEALING EGG..."
                monitor.TextColor3 = Color3.fromRGB(255, 140, 0)
                
                local waitPromptTime = tick()
                while isAutoActive and not prompt.Enabled and (tick() - waitPromptTime < 2) do
                    task.wait(0.1)
                end

                SafeTrigger(prompt)
                task.wait(0.5)

                if HasEgg() then
                    monitor.Text = "STATUS: 🚚 RETURNING TO BASE"
                    monitor.TextColor3 = Color3.fromRGB(100, 200, 255)
                    MoveToTarget(FindBasePos())
                end
            end
        else
            monitor.Text = "STATUS: ⚠️ TARGET EGG NOT FOUND"
        end

        task.wait(1)
        monitor.Text = "STATUS: WAITING FOR UI RESET..."
        monitor.TextColor3 = Color3.fromRGB(180, 190, 200)
        currentWorker = nil
    end)
end

local function CheckTextAndTrigger(obj)
    if not isAutoActive or currentWorker then return end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        local text = string.upper(tostring(obj.Text or ""))
        if string.find(text, "ALL EGG RESET") or string.find(text, "EGGS RESET") then
            TriggerEggFarmSequence()
        end
    end
end

table.insert(activeConns, playerGui.DescendantAdded:Connect(function(descendant)
    CheckTextAndTrigger(descendant)
    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
        local propConn
        propConn = descendant:GetPropertyChangedSignal("Text"):Connect(function()
            if not descendant:IsDescendantOf(game) then
                propConn:Disconnect()
                return
            end
            CheckTextAndTrigger(descendant)
        end)
        table.insert(activeConns, propConn)
    end
end))

for _, desc in ipairs(playerGui:GetDescendants()) do
    CheckTextAndTrigger(desc)
end
