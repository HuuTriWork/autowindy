-- ========== SERVICES ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ========== MAIN GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BossHunterGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200) -- Căn giữa màn hình
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Giúp menu không bị văng
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- ========== TITLE BAR ==========
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.15, 0, 0, 0)
TitleLabel.Text = "BOSS HUNTER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.8
CloseButton.Parent = TitleBar

-- ========== DRAGGABLE FUNCTION ==========
local dragging, dragInput, dragStart, startPos

local function Update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        Update(input)
    end
end)

-- ========== BOSS HUNTING SYSTEM ==========
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

-- ========== BOSS SELECTION UI ==========
local BossList = Instance.new("ScrollingFrame")
BossList.Name = "BossList"
BossList.Size = UDim2.new(1, -20, 0.7, -10)
BossList.Position = UDim2.new(0, 10, 0, 40)
BossList.BackgroundTransparency = 1
BossList.ScrollBarThickness = 5
BossList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = BossList

-- Tạo nút cho từng boss
for _, bossName in ipairs(AutoKill.Bosses) do
    local bossButton = Instance.new("TextButton")
    bossButton.Name = bossName.."Button"
    bossButton.Size = UDim2.new(1, 0, 0, 40)
    bossButton.Text = bossName
    bossButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    bossButton.Font = Enum.Font.Gotham
    bossButton.TextSize = 14
    bossButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    bossButton.Parent = BossList
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = bossButton
    
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

-- ========== NO-CLIP BUTTON ==========
local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipButton"
NoClipButton.Size = UDim2.new(1, -20, 0, 40)
NoClipButton.Position = UDim2.new(0, 10, 0.75, 0)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Font = Enum.Font.Gotham
NoClipButton.TextSize = 14
NoClipButton.BackgroundColor3 = Color3.fromRGB(80, 60, 80)
NoClipButton.Parent = MainFrame

local NoClipCorner = Instance.new("UICorner")
NoClipCorner.CornerRadius = UDim.new(0, 6)
NoClipCorner.Parent = NoClipButton

NoClipButton.MouseButton1Click:Connect(function()
    NoClip:Toggle()
    NoClipButton.Text = "NoClip: " .. (NoClip.Enabled and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = NoClip.Enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(80, 60, 80)
end)

-- ========== STATUS LABEL ==========
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0.85, 0)
StatusLabel.Text = "Status: Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Cập nhật trạng thái
RunService.Heartbeat:Connect(function()
    StatusLabel.Text = "Status: " .. (AutoKill.Active and "Hunting "..AutoKill.CurrentTarget or "Inactive")
end)

-- Nút đóng
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Hàm hỗ trợ table.find nếu chưa có
if not table.find then
    function table.find(t, value)
        for i, v in ipairs(t) do
            if v == value then
                return i
            end
        end
        return nil
    end
end
