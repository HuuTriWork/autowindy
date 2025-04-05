-- ========== CORE SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ========== CREATE MAIN GUI ==========
local DarkCyberGUI = Instance.new("ScreenGui")
DarkCyberGUI.Name = "WindyBeeKillerUI"
DarkCyberGUI.ResetOnSpawn = false
DarkCyberGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DarkCyberGUI.Parent = CoreGui

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = DarkCyberGUI

-- Add drop shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Add gradient effect
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 120))
})
Gradient.Rotation = 90
Gradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Text = "WINDY BEE KILLER PRO"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.AutoButtonColor = false
CloseButton.Parent = TitleBar

-- Add button hover effect
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

-- Main Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 5
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ContentFrame.Parent = MainFrame

-- ========== CREATE UI SECTIONS ==========
-- Status Panel
local StatusPanel = Instance.new("Frame")
StatusPanel.Name = "StatusPanel"
StatusPanel.Size = UDim2.new(1, 0, 0, 120)
StatusPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatusPanel.BorderSizePixel = 0
StatusPanel.Parent = ContentFrame

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Name = "StatusTitle"
StatusTitle.Size = UDim2.new(1, -10, 0, 20)
StatusTitle.Position = UDim2.new(0, 10, 0, 5)
StatusTitle.Text = "SYSTEM STATUS"
StatusTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextSize = 14
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.BackgroundTransparency = 1
StatusTitle.Parent = StatusPanel

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 90)
StatusLabel.Position = UDim2.new(0, 10, 0, 25)
StatusLabel.Text = "Status: Ready\nDetection Risk: 0%\nWindy Bee Found: No\nPosition: Stable"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = StatusPanel

-- Control Panel
local ControlPanel = Instance.new("Frame")
ControlPanel.Name = "ControlPanel"
ControlPanel.Size = UDim2.new(1, 0, 0, 180)
ControlPanel.Position = UDim2.new(0, 0, 0, 130)
ControlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ControlPanel.BorderSizePixel = 0
ControlPanel.Parent = ContentFrame

local ControlTitle = Instance.new("TextLabel")
ControlTitle.Name = "ControlTitle"
ControlTitle.Size = UDim2.new(1, -10, 0, 20)
ControlTitle.Position = UDim2.new(0, 10, 0, 5)
ControlTitle.Text = "CONTROLS"
ControlTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
ControlTitle.Font = Enum.Font.GothamBold
ControlTitle.TextSize = 14
ControlTitle.TextXAlignment = Enum.TextXAlignment.Left
ControlTitle.BackgroundTransparency = 1
ControlTitle.Parent = ControlPanel

-- Main Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -20, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 30)
ToggleButton.Text = "START KILLING"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ControlPanel

-- Add button animation
ToggleButton.MouseButton1Down:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 45)}):Play()
end)

ToggleButton.MouseButton1Up:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 50)}):Play()
end)

-- NoClip Toggle
local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipButton"
NoClipButton.Size = UDim2.new(1, -20, 0, 40)
NoClipButton.Position = UDim2.new(0, 10, 0, 90)
NoClipButton.Text = "NO-CLIP: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Font = Enum.Font.Gotham
NoClipButton.TextSize = 12
NoClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
NoClipButton.AutoButtonColor = false
NoClipButton.Parent = ControlPanel

-- Stats Panel
local StatsPanel = Instance.new("Frame")
StatsPanel.Name = "StatsPanel"
StatsPanel.Size = UDim2.new(1, 0, 0, 150)
StatsPanel.Position = UDim2.new(0, 0, 0, 320)
StatsPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatsPanel.BorderSizePixel = 0
StatsPanel.Parent = ContentFrame

local StatsTitle = Instance.new("TextLabel")
StatsTitle.Name = "StatsTitle"
StatsTitle.Size = UDim2.new(1, -10, 0, 20)
StatsTitle.Position = UDim2.new(0, 10, 0, 5)
StatsTitle.Text = "STATISTICS"
StatsTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.TextSize = 14
StatsTitle.TextXAlignment = Enum.TextXAlignment.Left
StatsTitle.BackgroundTransparency = 1
StatsTitle.Parent = StatsPanel

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Size = UDim2.new(1, -20, 0, 120)
StatsLabel.Position = UDim2.new(0, 10, 0, 25)
StatsLabel.Text = "Kills: 0\nTime Running: 00:00:00\nLast Kill: None\nEfficiency: 0%\nTotal Damage: 0"
StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 12
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.BackgroundTransparency = 1
StatsLabel.Parent = StatsPanel

-- ========== CORE FUNCTIONALITY ==========
local WindyBeeFarm = {
    Active = false,
    KillCount = 0,
    StartTime = 0,
    LastKillTime = 0,
    TotalDamage = 0
}

local NoClip = {
    Enabled = false
}

local AntiBan = {
    DetectionRisk = 0,
    LastRandomAction = 0
}

-- Function to update status
local function UpdateStatus()
    local statusText = "Status: " .. (WindyBeeFarm.Active and "ACTIVE" or "READY")
    statusText = statusText .. "\nDetection Risk: " .. math.floor(AntiBan.DetectionRisk * 100) .. "%"
    
    -- Update time running
    local runningTime = "00:00:00"
    if WindyBeeFarm.Active and WindyBeeFarm.StartTime > 0 then
        local elapsed = os.time() - WindyBeeFarm.StartTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        runningTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end
    
    -- Update stats
    local lastKill = WindyBeeFarm.LastKillTime > 0 and os.date("%H:%M:%S", WindyBeeFarm.LastKillTime) or "None"
    local efficiency = WindyBeeFarm.KillCount > 0 and math.floor((WindyBeeFarm.KillCount / (os.time() - WindyBeeFarm.StartTime + 1)) * 100 or 0
    
    StatusLabel.Text = statusText
    StatsLabel.Text = string.format("Kills: %d\nTime Running: %s\nLast Kill: %s\nEfficiency: %d%%\nTotal Damage: %d", 
        WindyBeeFarm.KillCount, runningTime, lastKill, efficiency, WindyBeeFarm.TotalDamage)
end

-- Simulate killing Windy Bee
local function FarmWindyBee()
    while WindyBeeFarm.Active do
        -- Anti-ban checks
        AntiBan.DetectionRisk = math.min(1, AntiBan.DetectionRisk + 0.001)
        
        -- Random actions to avoid detection
        if os.time() - AntiBan.LastRandomAction > 60 then
            AntiBan.DetectionRisk = math.max(0, AntiBan.DetectionRisk - 0.1)
            AntiBan.LastRandomAction = os.time()
        end
        
        -- Simulate killing Windy Bee
        WindyBeeFarm.KillCount = WindyBeeFarm.KillCount + 1
        WindyBeeFarm.TotalDamage = WindyBeeFarm.TotalDamage + math.random(500, 1500)
        WindyBeeFarm.LastKillTime = os.time()
        
        UpdateStatus()
        wait(3) -- Simulate kill cooldown
    end
end

-- ========== BUTTON CONNECTIONS ==========
ToggleButton.MouseButton1Click:Connect(function()
    WindyBeeFarm.Active = not WindyBeeFarm.Active
    if WindyBeeFarm.Active then
        ToggleButton.Text = "STOP KILLING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        WindyBeeFarm.StartTime = os.time()
        spawn(FarmWindyBee)
    else
        ToggleButton.Text = "START KILLING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
    UpdateStatus()
end)

NoClipButton.MouseButton1Click:Connect(function()
    NoClip.Enabled = not NoClip.Enabled
    if NoClip.Enabled then
        NoClipButton.Text = "NO-CLIP: ON"
        NoClipButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    else
        NoClipButton.Text = "NO-CLIP: OFF"
        NoClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    DarkCyberGUI:Destroy()
end)

-- Initialize
UpdateStatus()
warn("Windy Bee Killer Pro đã tải thành công! Menu đã hiển thị!")

-- Ensure GUI stays after respawn
LocalPlayer.CharacterAdded:Connect(function()
    if not DarkCyberGUI:IsDescendantOf(game) then
        DarkCyberGUI:Clone().Parent = CoreGui
    end
end)
