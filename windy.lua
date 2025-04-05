-- ========== SERVICES AND UTILITIES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- ========== MAIN GUI ==========
local MainGUI = CreateElement("ScreenGui", {
    Name = "BSSAutoFarmGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 400, 0, 300),
    Position = UDim2.new(0.5, -200, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = MainGUI
})

-- Title Bar
local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel = 0,
    Parent = MainFrame
})

local TitleLabel = CreateElement("TextLabel", {
    Name = "TitleLabel",
    Size = UDim2.new(0.7, 0, 1, 0),
    Text = "BSS Auto-Kill v1.0",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = TitleBar
})

local CloseButton = CreateElement("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -30, 0, 0),
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    Parent = TitleBar
})

CloseButton.MouseButton1Click:Connect(function()
    MainGUI:Destroy()
end)

-- Tabs
local Tabs = {"Auto-Kill", "Settings"}
local TabButtons = {}
local TabContents = {}

for i, tabName in ipairs(Tabs) do
    local tabButton = CreateElement("TextButton", {
        Name = tabName.."Tab",
        Size = UDim2.new(0.5, 0, 0, 30),
        Position = UDim2.new(0.5 * (i-1), 0, 0, 30),
        Text = tabName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = i == 1 and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(40, 40, 60),
        Parent = MainFrame
    })
    
    local tabContent = CreateElement("Frame", {
        Name = tabName.."Content",
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Visible = i == 1,
        Parent = MainFrame
    })
    
    TabButtons[tabName] = tabButton
    TabContents[tabName] = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        for name, button in pairs(TabButtons) do
            button.BackgroundColor3 = name == tabName and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(40, 40, 60)
        end
        
        for name, content in pairs(TabContents) do
            content.Visible = name == tabName
        end
    end)
end

-- ========== AUTO-KILL SYSTEM ==========
local AutoKill = {
    Active = false,
    Bosses = {
        "Tunnel Bear",
        "Windy Bee",
        "Coconut Crab",
        "Mondo Chick",
        "Stump Snail",
        "King Beetle",
        "Commando Chick"
    },
    CurrentTarget = nil,
    AttackDistance = 10,
    AttackHeight = 3
}

-- Auto-Kill Tab Content
local AutoKillContent = TabContents["Auto-Kill"]

-- Boss Selection Dropdown
local BossDropdown = CreateElement("Frame", {
    Name = "BossDropdown",
    Size = UDim2.new(0.9, 0, 0, 30),
    Position = UDim2.new(0.05, 0, 0.05, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 60),
    Parent = AutoKillContent
})

local BossDropdownLabel = CreateElement("TextLabel", {
    Name = "BossDropdownLabel",
    Size = UDim2.new(0.7, 0, 1, 0),
    Text = "Select Boss:",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    Parent = BossDropdown
})

local BossDropdownButton = CreateElement("TextButton", {
    Name = "BossDropdownButton",
    Size = UDim2.new(0.3, 0, 1, 0),
    Position = UDim2.new(0.7, 0, 0, 0),
    Text = "None",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundColor3 = Color3.fromRGB(60, 60, 80),
    Parent = BossDropdown
})

-- Boss List Frame (hidden by default)
local BossListFrame = CreateElement("ScrollingFrame", {
    Name = "BossListFrame",
    Size = UDim2.new(0.3, 0, 0, 150),
    Position = UDim2.new(0.7, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(50, 50, 70),
    ScrollBarThickness = 5,
    Visible = false,
    Parent = BossDropdown
})

-- Populate boss list
for i, bossName in ipairs(AutoKill.Bosses) do
    local bossButton = CreateElement("TextButton", {
        Name = bossName.."Button",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, (i-1)*30),
        Text = bossName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        Parent = BossListFrame
    })
    
    bossButton.MouseButton1Click:Connect(function()
        AutoKill.CurrentTarget = bossName
        BossDropdownButton.Text = bossName
        BossListFrame.Visible = false
    end)
end

BossListFrame.CanvasSize = UDim2.new(0, 0, 0, #AutoKill.Bosses * 30)

-- Toggle dropdown visibility
BossDropdownButton.MouseButton1Click:Connect(function()
    BossListFrame.Visible = not BossListFrame.Visible
end)

-- Start/Stop Button
local ToggleButton = CreateElement("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.4, 0),
    Text = "START",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(50, 150, 50),
    Parent = AutoKillContent
})

-- Status Label
local StatusLabel = CreateElement("TextLabel", {
    Name = "StatusLabel",
    Size = UDim2.new(0.9, 0, 0, 20),
    Position = UDim2.new(0.05, 0, 0.6, 0),
    Text = "Status: Inactive",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    Parent = AutoKillContent
})

-- Distance Slider
local DistanceSlider = CreateElement("Frame", {
    Name = "DistanceSlider",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0.7, 0),
    BackgroundTransparency = 1,
    Parent = AutoKillContent
})

local DistanceLabel = CreateElement("TextLabel", {
    Name = "DistanceLabel",
    Size = UDim2.new(1, 0, 0, 20),
    Text = "Attack Distance: "..AutoKill.AttackDistance,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    Parent = DistanceSlider
})

local DistanceSliderBar = CreateElement("TextButton", {
    Name = "DistanceSliderBar",
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 0, 25),
    Text = "",
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = DistanceSlider
})

local DistanceSliderButton = CreateElement("TextButton", {
    Name = "DistanceSliderButton",
    Size = UDim2.new(0, 15, 0, 15),
    Position = UDim2.new((AutoKill.AttackDistance-5)/15, 0, 0, 20),
    Text = "",
    BackgroundColor3 = Color3.fromRGB(100, 150, 255),
    Parent = DistanceSlider
})

-- Slider functionality
local sliding = false
DistanceSliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

DistanceSliderBar.MouseButton1Down:Connect(function(x)
    local percent = math.clamp(x / DistanceSliderBar.AbsoluteSize.X, 0, 1)
    AutoKill.AttackDistance = math.floor(5 + percent * 15)
    DistanceLabel.Text = "Attack Distance: "..AutoKill.AttackDistance
    DistanceSliderButton.Position = UDim2.new((AutoKill.AttackDistance-5)/15, 0, 0, 20)
end)

RunService.Heartbeat:Connect(function()
    if sliding then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = DistanceSliderBar.AbsolutePosition.X
        local sliderSize = DistanceSliderBar.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        
        AutoKill.AttackDistance = math.floor(5 + percent * 15)
        DistanceLabel.Text = "Attack Distance: "..AutoKill.AttackDistance
        DistanceSliderButton.Position = UDim2.new((AutoKill.AttackDistance-5)/15, 0, 0, 20)
    end
end)

-- Auto-Kill Logic
function AutoKill:FindBoss(bossName)
    for _, monster in ipairs(workspace.Monsters:GetChildren()) do
        if string.find(monster.Name, bossName) then
            return monster
        end
    end
    return nil
end

function AutoKill:Start()
    if not self.CurrentTarget then return end
    if self.Active then return end
    
    self.Active = true
    ToggleButton.Text = "STOP"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    StatusLabel.Text = "Status: Attacking "..self.CurrentTarget
    
    spawn(function()
        while self.Active and self.CurrentTarget do
            local boss = self:FindBoss(self.CurrentTarget)
            if boss then
                local character = LocalPlayer.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if bossRoot then
                            -- Calculate attack position
                            local offset = bossRoot.CFrame.LookVector * -self.AttackDistance
                            offset = offset + Vector3.new(0, self.AttackHeight, 0)
                            local attackCFrame = CFrame.new(bossRoot.Position + offset, bossRoot.Position)
                            
                            -- Teleport to attack position
                            humanoidRootPart.CFrame = attackCFrame
                            
                            -- Use all tools to attack
                            for _, tool in ipairs(character:GetChildren()) do
                                if tool:IsA("Tool") then
                                    tool.ClickEvent:FireServer()
                                end
                            end
                        end
                    end
                end
            else
                StatusLabel.Text = "Status: Waiting for "..self.CurrentTarget.." to spawn"
            end
            
            task.wait(0.1)
        end
    end)
end

function AutoKill:Stop()
    self.Active = false
    ToggleButton.Text = "START"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    StatusLabel.Text = "Status: Inactive"
end

-- Toggle button functionality
ToggleButton.MouseButton1Click:Connect(function()
    if AutoKill.Active then
        AutoKill:Stop()
    else
        AutoKill:Start()
    end
end)

-- ========== NO-CLIP SYSTEM ==========
local NoClip = {
    Enabled = false,
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not self.Enabled
            end
        end
    end,
    
    Run = function(self)
        RunService.Stepped:Connect(function()
            if self.Enabled and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
}

NoClip:Run()

-- Add No-Clip toggle to Settings tab
local SettingsContent = TabContents["Settings"]

local NoClipToggle = CreateElement("TextButton", {
    Name = "NoClipToggle",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.1, 0),
    Text = "No-Clip: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = SettingsContent
})

NoClipToggle.MouseButton1Click:Connect(function()
    NoClip:Toggle()
    NoClipToggle.Text = "No-Clip: " .. (NoClip.Enabled and "ON" or "OFF")
    NoClipToggle.BackgroundColor3 = NoClip.Enabled and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(80, 80, 100)
end)

warn("BSS Auto-Kill GUI loaded successfully!")
