-- ========== FIXED DRAGGABLE MENU ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixedPositionGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Luôn căn giữa khi khởi động
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Quan trọng: giúp menu không bị văng
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Thanh tiêu đề
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
TitleLabel.Text = "MENU CONTROL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

-- Nút đóng
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

-- Nội dung chính
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ========== CƠ CHẾ KÉO THẢ CẢI TIẾN ==========
local dragging
local dragStart
local startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
    
    -- Giới hạn phạm vi di chuyển (tùy chọn)
    local viewportSize = workspace.CurrentCamera.ViewportSize
    newPos = UDim2.new(
        math.clamp(newPos.X.Scale, 0, 1),
        math.clamp(newPos.X.Offset, -MainFrame.AbsoluteSize.X/2, viewportSize.X - MainFrame.AbsoluteSize.X/2),
        math.clamp(newPos.Y.Scale, 0, 1),
        math.clamp(newPos.Y.Offset, -MainFrame.AbsoluteSize.Y/2, viewportSize.Y - MainFrame.AbsoluteSize.Y/2)
    )
    
    MainFrame.Position = newPos
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
        UpdateInput(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        UpdateInput(input)
    end
end)

-- Nút đóng
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========== NO-CLIP SYSTEM ==========
local NoClip = {
    Enabled = false,
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not self.Enabled
                end
            end
        end
    end
}

local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipButton"
NoClipButton.Size = UDim2.new(0.8, 0, 0, 30)
NoClipButton.Position = UDim2.new(0.1, 0, 0.1, 0)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Font = Enum.Font.Gotham
NoClipButton.TextSize = 14
NoClipButton.BackgroundColor3 = Color3.fromRGB(80, 60, 80)
NoClipButton.Parent = ContentFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = NoClipButton

NoClipButton.MouseButton1Click:Connect(function()
    NoClip:Toggle()
    NoClipButton.Text = "NoClip: " .. (NoClip.Enabled and "ON" or "OFF")
    NoClipButton.BackgroundColor3 = NoClip.Enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(80, 60, 80)
end)

-- ========== AUTO POSITION FIX ==========
-- Đảm bảo menu luôn nằm trong màn hình khi load
task.spawn(function()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    
    MainFrame.Position = UDim2.new(
        math.clamp(MainFrame.Position.X.Scale, 0, 1),
        math.clamp(MainFrame.Position.X.Offset, -frameSize.X/2, viewportSize.X - frameSize.X/2),
        math.clamp(MainFrame.Position.Y.Scale, 0, 1),
        math.clamp(MainFrame.Position.Y.Offset, -frameSize.Y/2, viewportSize.Y - frameSize.Y/2)
    )
end)
