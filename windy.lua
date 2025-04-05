-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ========== UTILITY FUNCTIONS ==========
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

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

-- ========== AUTO KILL BOSS ==========
local AutoKill = {
    Active = false,
    Bosses = {
        "Tunnel Bear",
        "Windy Bee",
        "Coconut Crab",
        "Mondo Chick",
        "Stump Snail"
    },
    CurrentTarget = nil,
    
    Start = function(self, bossName)
        if not table.find(self.Bosses, bossName) then return end
        if self.Active and self.CurrentTarget == bossName then return end
        
        self.Active = true
        self.CurrentTarget = bossName
        
        task.spawn(function()
            while self.Active and self.CurrentTarget == bossName do
                local boss = self:FindBoss(bossName)
                if boss then
                    local character = LocalPlayer.Character
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local attackCFrame = boss:FindFirstChild("HumanoidRootPart") and 
                                               boss.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0) or
                                               boss.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                            
                            humanoidRootPart.CFrame = attackCFrame
                            task.wait(0.1)
                        end
                    end
                else
                    task.wait(5)
                end
            end
        end)
    end,
    
    Stop = function(self)
        self.Active = false
        self.CurrentTarget = nil
    end,
    
    FindBoss = function(self, bossName)
        for _, monster in ipairs(workspace.Monsters:GetChildren()) do
            if string.find(monster.Name, bossName) then
                return monster
            end
        end
        return nil
    end
}

-- ========== CREATE MAIN GUI ==========
local ScreenGui = CreateInstance("ScreenGui", {
    Name = "BossHunterGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

-- Main Frame with minimized/maximized states
local MainFrame = CreateInstance("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 350, 0, 400),
    Position = UDim2.new(0.5, -175, 0.5, -200),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Parent = ScreenGui
})

local Corner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent = MainFrame
})

-- Title Bar with minimize button
local TitleBar = CreateInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0,
    Parent = MainFrame
})

local TitleCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent = TitleBar
})

local TitleLabel = CreateInstance("TextLabel", {
    Name = "TitleLabel",
    Size = UDim2.new(0.7, 0, 1, 0),
    Position = UDim2.new(0.15, 0, 0, 0),
    Text = "BOSS HUNTER",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundTransparency = 1,
    Parent = TitleBar
})

-- Minimize Button
local MinimizeButton = CreateInstance("TextButton", {
    Name = "MinimizeButton",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -70, 0.5, -15),
    Text = "_",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    BackgroundTransparency = 0.8,
    Parent = TitleBar
})

local MinimizeCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = MinimizeButton
})

-- Close Button
local CloseButton = CreateInstance("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    BackgroundTransparency = 0.8,
    Parent = TitleBar
})

local CloseCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = CloseButton
})

-- Minimized Frame (only shows title bar)
local MinimizedFrame = CreateInstance("Frame", {
    Name = "MinimizedFrame",
    Size = UDim2.new(0, 200, 0, 40),
    Position = UDim2.new(0.5, -100, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Visible = false,
    Parent = ScreenGui
})

local MinimizedCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent = MinimizedFrame
})

local MinimizedTitle = CreateInstance("TextLabel", {
    Name = "MinimizedTitle",
    Size = UDim2.new(0.7, 0, 1, 0),
    Position = UDim2.new(0.15, 0, 0, 0),
    Text = "BOSS HUNTER",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundTransparency = 1,
    Parent = MinimizedFrame
})

local MaximizeButton = CreateInstance("TextButton", {
    Name = "MaximizeButton",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    Text = "+",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(80, 120, 80),
    BackgroundTransparency = 0.8,
    Parent = MinimizedFrame
})

local MaximizeCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = MaximizeButton
})

-- Minimize/Maximize functionality
local isMinimized = false

local function ToggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        -- Save current position before minimizing
        MinimizedFrame.Position = MainFrame.Position
        MinimizedFrame.Position = UDim2.new(
            MainFrame.Position.X.Scale,
            MainFrame.Position.X.Offset,
            MainFrame.Position.Y.Scale,
            MainFrame.Position.Y.Offset
        )
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    else
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
    end
end

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)
MaximizeButton.MouseButton1Click:Connect(ToggleMinimize)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tabs
local Tabs = {"Auto Kill", "Settings"}
local TabButtons = {}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    local tabButton = CreateInstance("TextButton", {
        Name = tabName.."Tab",
        Size = UDim2.new(0.5, 0, 0, 35),
        Position = UDim2.new(0.5 * (i-1), 0, 0, 40),
        Text = tabName,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BackgroundColor3 = i == 1 and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local tabFrame = CreateInstance("Frame", {
        Name = tabName.."Frame",
        Size = UDim2.new(1, -20, 1, -90),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        Visible = i == 1,
        Parent = MainFrame
    })
    
    TabButtons[tabName] = tabButton
    TabFrames[tabName] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for name, button in pairs(TabButtons) do
            button.BackgroundColor3 = name == tabName and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(40, 40, 50)
        end
        
        for name, frame in pairs(TabFrames) do
            frame.Visible = name == tabName
        end
    end)
end

-- Auto Kill Tab Content
local AutoKillFrame = TabFrames["Auto Kill"]

local BossList = CreateInstance("ScrollingFrame", {
    Name = "BossList",
    Size = UDim2.new(1, 0, 0.6, 0),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 5,
    Parent = AutoKillFrame
})

local BossListLayout = CreateInstance("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = BossList
})

BossListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    BossList.CanvasSize = UDim2.new(0, 0, 0, BossListLayout.AbsoluteContentSize.Y)
end)

for i, bossName in ipairs(AutoKill.Bosses) do
    local bossButton = CreateInstance("TextButton", {
        Name = bossName.."Button",
        Size = UDim2.new(1, 0, 0, 40),
        Text = bossName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        Parent = BossList
    })
    
    local buttonCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = bossButton
    })
    
    bossButton.MouseButton1Click:Connect(function()
        if AutoKill.Active and AutoKill.CurrentTarget == bossName then
            AutoKill:Stop()
            bossButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            AutoKill:Start(bossName)
            for _, btn in ipairs(BossList:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name == bossName.."Button" and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 80)
                end
            end
        end
    end)
end

local StatusLabel = CreateInstance("TextLabel", {
    Name = "StatusLabel",
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0.65, 0),
    Text = "Status: Inactive",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = AutoKillFrame
})

-- NoClip Toggle
local NoClipToggle = CreateInstance("TextButton", {
    Name = "NoClipToggle",
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0.8, 0),
    Text = "NoClip: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 60, 80),
    Parent = AutoKillFrame
})

local toggleCorner = CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = NoClipToggle
})

NoClipToggle.MouseButton1Click:Connect(function()
    NoClip:Toggle()
    NoClipToggle.Text = "NoClip: " .. (NoClip.Enabled and "ON" or "OFF")
    NoClipToggle.BackgroundColor3 = NoClip.Enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(80, 60, 80)
end)

-- Settings Tab Content
local SettingsFrame = TabFrames["Settings"]

local InfoLabel = CreateInstance("TextLabel", {
    Name = "InfoLabel",
    Size = UDim2.new(1, -20, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    Text = "BOSS HUNTER v1.0\n\nCreated by YourName\n\nFeatures:\n- Auto Kill Boss\n- NoClip System",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    BackgroundTransparency = 1,
    Parent = SettingsFrame
})

-- Draggable GUI for both frames
local function MakeDraggable(frame, handle)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

MakeDraggable(MainFrame, TitleBar)
MakeDraggable(MinimizedFrame, MinimizedFrame)

-- Update status
game:GetService("RunService").Heartbeat:Connect(function()
    StatusLabel.Text = "Status: " .. (AutoKill.Active and "Hunting "..AutoKill.CurrentTarget or "Inactive")
end)
