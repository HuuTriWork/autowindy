-- ========== FIXED MENU GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImprovedBeeSwarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175) -- Luôn căn giữa màn hình khi khởi động
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Thêm anchor point để căn giữa chính xác
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar với khả năng kéo
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.15, 0, 0, 0)
TitleLabel.Text = "BEE SWARM STATS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

-- Nút đóng và thu nhỏ
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.8
CloseButton.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
MinimizeButton.BackgroundTransparency = 0.8
MinimizeButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Thêm các thành phần thống kê từ hình ảnh của bạn
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "Status: Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ContentFrame

local NoClipLabel = Instance.new("TextLabel")
NoClipLabel.Name = "NoClipLabel"
NoClipLabel.Size = UDim2.new(1, 0, 0, 20)
NoClipLabel.Position = UDim2.new(0, 0, 0, 25)
NoClipLabel.Text = "NoClip: OFF"
NoClipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipLabel.Font = Enum.Font.Gotham
NoClipLabel.TextSize = 14
NoClipLabel.BackgroundTransparency = 1
NoClipLabel.TextXAlignment = Enum.TextXAlignment.Left
NoClipLabel.Parent = ContentFrame

-- Thêm các thống kê khác
local stats = {
    {"Gathers:", "33 in 2 Seconds", 50},
    {"Converts:", "26,756 in 2 Seconds", 75},
    {"Speed:", "28.8", 100},
    {"Attack:", "17.25", 125}
}

for _, stat in ipairs(stats) do
    local label = Instance.new("TextLabel")
    label.Name = stat[1].."Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, stat[3])
    label.Text = stat[1].." "..stat[2]
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = ContentFrame
end

-- Hệ thống kéo thả cải tiến
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
        update(input)
    end
end)

-- Nút đóng
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Chức năng NoClip
local NoClip = {
    Enabled = false,
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        NoClipLabel.Text = "NoClip: " .. (self.Enabled and "ON" or "OFF")
        
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not self.Enabled
                end
            end
        end
    end
}

NoClipLabel.MouseButton1Click:Connect(function()
    NoClip:Toggle()
end)

-- Chức năng thu nhỏ
local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 200, 0, 30)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = minimizedSize
        ContentFrame.Visible = false
    else
        MainFrame.Size = originalSize
        ContentFrame.Visible = true
    end
end)
