-- ============================================================================
-- 👑 STEAL AN EGG: UNDETECTABLE ENGINE (v5.7 STEALTH)
-- ============================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10)

if playerGui and playerGui:FindFirstChild("StealAnEggBypass_UI") then
    playerGui.StealAnEggBypass_UI:Destroy()
end

-- ใช้ Local Variable ทั้งหมด ป้องกันการสแกน _G
local isRunning = false
local currentWorker = nil
local activeConns = {}

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
    isRunning = false
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
titleLabel.Text = "   🛡️ STEAL AN EGG: STEALTH v5.7"
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
monitor.Text = "STATUS: IDLE"
monitor.TextColor3 = Color3.fromRGB(180, 190, 200)
monitor.Font = Enum.Font.GothamSemibold
monitor.TextSize = 12
Instance.new("UICorner", monitor).CornerRadius = UDim.new(0, 8)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(1, -30, 0, 85)
toggleBtn.Position = UDim2.new(0, 15, 0, 108)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 62)
toggleBtn.Text = "START AUTO FARM"
toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local openWidget = Instance.new("TextButton")
openWidget.Name = "OpenWidget"
openWidget.Size = UDim2.new(0, 50, 0, 50)
openWidget.Position = UDim2.new(0.05, 0, 0.2, 0)
openWidget.BackgroundColor3 = Color3.fromRGB(20, 26, 35)
openWidget.Text = "🚀"
openWidget.TextSize = 26
openWidget.Visible = false
openWidget.Active = true
openWidget.Parent = screenGui

Instance.new("UICorner", openWidget).CornerRadius = UDim.new(1, 0)
local widgetStroke = Instance.new("UIStroke", openWidget)
widgetStroke.Color = Color3.fromRGB(0, 220, 130)
widgetStroke.Thickness = 2.5

local dragging = false
local dragThresholdPassed = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    if delta.Magnitude > 6 then
        dragThresholdPassed = true
        dragging = true
    end
    
    if dragging then
        openWidget.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end

table.insert(activeConns, openWidget.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = openWidget.Position
        dragThresholdPassed = false
        dragging = false

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end))

table.insert(activeConns, openWidget.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))

table.insert(activeConns, UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateInput(input)
    end
end))

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openWidget.Visible = true
end)

destroyBtn.MouseButton1Click:Connect(function()
    HardCleanup()
    screenGui:Destroy()
end)

openWidget.MouseButton1Click:Connect(function()
    if not dragThresholdPassed then
        mainFrame.Visible = true
        openWidget.Visible = false
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        toggleBtn.Text = "AUTO FARM: ACTIVE"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        StopWorker()
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 62)
        toggleBtn.Text = "START AUTO FARM"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        monitor.Text = "STATUS: IDLE"
        monitor.TextColor3 = Color3.fromRGB(180, 190, 200)
    end
end)

-- ============================================================================
-- ⚙️ TARGET FILTER
-- ============================================================================
local TARGET_KEYS = {
    "secret", "eternal", "divine", "cosmic", "mutant", "pure",
    "pegasus", "skeleton horse", "world burner", "burner", "centaur", 
    "gargoyle", "jellyfish", "razorfang", "gorilla king", "shark", 
    "kitsune", "oni tiger", "oni", "stag", "dragon", "skeleton warrior", 
    "lunar horse", "mosasaurus", "trex", "t-rex", "tralaledon", 
    "phoenix", "cerberus", "kraken"
}

local BLACKLIST_KEYS = {
    "sell", "shop", "combine", "craft", "fuse", "hatch", "upgrade", "place", "base", "plot"
}

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
    local container = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("Spawns") or Workspace
    for _, prompt in ipairs(container:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.Parent then
            local parent = prompt.Parent
            local part = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart")
            if part then
                local txt = string.lower((prompt.ActionText or "") .. " " .. (prompt.ObjectText or "") .. " " .. parent.Name)
                local skip = false
                for _, bKey in ipairs(BLACKLIST_KEYS) do
                    if string.find(txt, bKey) then skip = true break end
                end
                if not skip then
                    for _, tKey in ipairs(TARGET_KEYS) do
                        if string.find(txt, tKey) then
                            return part, prompt
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

-- ============================================================================
-- 🚶 NATIVE MOVEMENT & INTERACTION
-- ============================================================================
local function MoveToTarget(targetPos)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end

    humanoid:MoveTo(targetPos)
    local t = tick()
    while isRunning and (hrp.Position - targetPos).Magnitude > 6 do
        task.wait(0.2)
        if tick() - t > 5 then break end
    end
    return (hrp.Position - targetPos).Magnitude <= 7
end

local function SafeTrigger(prompt)
    if not prompt or not prompt.Parent then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local part = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
    if not part or (hrp.Position - part.Position).Magnitude > (prompt.MaxActivationDistance or 8) then return end

    task.wait(0.3)
    pcall(function()
        prompt:InputHoldBegin()
        task.wait((prompt.HoldDuration or 0) + 0.1)
        prompt:InputHoldEnd()
    end)
end

-- ============================================================================
-- 🔁 MAIN LOOP
-- ============================================================================
task.spawn(function()
    while screenGui and screenGui.Parent do
        task.wait(0.5)
        
        if isRunning and not currentWorker then
            currentWorker = task.spawn(function()
                if HasEgg() then
                    monitor.Text = "STATUS: 🚚 RETURNING TO BASE"
                    monitor.TextColor3 = Color3.fromRGB(100, 200, 255)
                    MoveToTarget(FindBasePos())
                else
                    monitor.Text = "STATUS: 🔍 SEARCHING EGG"
                    monitor.TextColor3 = Color3.fromRGB(0, 220, 130)
                    
                    local part, prompt = SearchTarget()
                    if part and prompt then
                        monitor.Text = "STATUS: 🏃 APPROACHING EGG"
                        monitor.TextColor3 = Color3.fromRGB(255, 200, 80)
                        
                        if MoveToTarget(part.Position) and isRunning then
                            monitor.Text = "STATUS: 🥚 STEALING..."
                            monitor.TextColor3 = Color3.fromRGB(255, 140, 0)
                            SafeTrigger(prompt)
                            task.wait(0.5)
                        end
                    else
                        monitor.Text = "STATUS: ⏳ NO EGG FOUND"
                        monitor.TextColor3 = Color3.fromRGB(220, 100, 100)
                    end
                end
                currentWorker = nil
            end)
        end
    end
end)
