-- ========== KHAI BÁO BIẾN VÀ HÀM TIỆN ÍCH ==========
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

-- ========== TẠO GIAO DIỆN MENU ==========
local KillerBeeGUI = CreateElement("ScreenGui", {
    Name = "KillerBeeGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 450, 0, 500),
    Position = UDim2.new(0.5, -225, 0.5, -250),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = KillerBeeGUI
})

-- Thanh tiêu đề với hiệu ứng gradient
local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Parent = MainFrame
})

local TitleGradient = CreateElement("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 50))
    }),
    Rotation = 90,
    Parent = TitleBar
})

local TitleLabel = CreateElement("TextLabel", {
    Name = "TitleLabel",
    Size = UDim2.new(0.8, 0, 1, 0),
    Position = UDim2.new(0.1, 0, 0, 0),
    Text = "KILLER BEE AUTO BOSS",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Parent = TitleBar
})

local CloseButton = CreateElement("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(1, -40, 0, 0),
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    BorderSizePixel = 0,
    Parent = TitleBar
})

CloseButton.MouseButton1Click:Connect(function()
    KillerBeeGUI:Destroy()
end)

-- Tạo hiệu ứng hover cho nút đóng
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

-- Nội dung chính
local ContentFrame = CreateElement("Frame", {
    Name = "ContentFrame",
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Danh sách boss
local BossListFrame = CreateElement("ScrollingFrame", {
    Name = "BossListFrame",
    Size = UDim2.new(0.4, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    Parent = ContentFrame
})

local UIListLayout = CreateElement("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = BossListFrame
})

-- Thông tin boss
local BossInfoFrame = CreateElement("Frame", {
    Name = "BossInfoFrame",
    Size = UDim2.new(0.55, 0, 0.4, 0),
    Position = UDim2.new(0.42, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    BorderSizePixel = 0,
    Parent = ContentFrame
})

local BossImage = CreateElement("ImageLabel", {
    Name = "BossImage",
    Size = UDim2.new(1, 0, 0.6, 0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://3766691866", -- Placeholder image
    ScaleType = Enum.ScaleType.Crop,
    Parent = BossInfoFrame
})

local BossNameLabel = CreateElement("TextLabel", {
    Name = "BossNameLabel",
    Size = UDim2.new(1, 0, 0.15, 0),
    Position = UDim2.new(0, 0, 0.6, 0),
    Text = "SELECT A BOSS",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundTransparency = 1,
    Parent = BossInfoFrame
})

local BossHealthLabel = CreateElement("TextLabel", {
    Name = "BossHealthLabel",
    Size = UDim2.new(1, 0, 0.1, 0),
    Position = UDim2.new(0, 0, 0.75, 0),
    Text = "Health: -",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = BossInfoFrame
})

local BossLocationLabel = CreateElement("TextLabel", {
    Name = "BossLocationLabel",
    Size = UDim2.new(1, 0, 0.1, 0),
    Position = UDim2.new(0, 0, 0.85, 0),
    Text = "Location: -",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = BossInfoFrame
})

-- Nút điều khiển
local ControlFrame = CreateElement("Frame", {
    Name = "ControlFrame",
    Size = UDim2.new(0.55, 0, 0.55, 0),
    Position = UDim2.new(0.42, 0, 0.42, 0),
    BackgroundTransparency = 1,
    Parent = ContentFrame
})

local StartButton = CreateElement("TextButton", {
    Name = "StartButton",
    Size = UDim2.new(1, 0, 0.2, 0),
    Text = "START AUTO KILL",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundColor3 = Color3.fromRGB(50, 150, 50),
    BorderSizePixel = 0,
    Parent = ControlFrame
})

local StopButton = CreateElement("TextButton", {
    Name = "StopButton",
    Size = UDim2.new(1, 0, 0.2, 0),
    Position = UDim2.new(0, 0, 0.25, 0),
    Text = "STOP",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundColor3 = Color3.fromRGB(150, 50, 50),
    BorderSizePixel = 0,
    Parent = ControlFrame
})

local NoClipToggle = CreateElement("TextButton", {
    Name = "NoClipToggle",
    Size = UDim2.new(0.48, 0, 0.15, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    Text = "NO CLIP: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
    BorderSizePixel = 0,
    Parent = ControlFrame
})

local TeleportButton = CreateElement("TextButton", {
    Name = "TeleportButton",
    Size = UDim2.new(0.48, 0, 0.15, 0),
    Position = UDim2.new(0.52, 0, 0.5, 0),
    Text = "TELEPORT TO BOSS",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
    BorderSizePixel = 0,
    Parent = ControlFrame
})

local StatusLabel = CreateElement("TextLabel", {
    Name = "StatusLabel",
    Size = UDim2.new(1, 0, 0.2, 0),
    Position = UDim2.new(0, 0, 0.8, 0),
    Text = "Status: Ready",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundTransparency = 1,
    Parent = ControlFrame
})

-- ========== HỆ THỐNG AUTO KILL ==========
local AutoKillSystem = {
    Active = false,
    CurrentBoss = nil,
    NoClipEnabled = false,
    
    Bosses = {
        {
            Name = "Tunnel Bear",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Bear Cave",
            CFrame = CFrame.new(507.3, 5.7, -45.7)
        },
        {
            Name = "Windy Bee",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Mountain Top Field",
            CFrame = CFrame.new(-486, 142, 410)
        },
        {
            Name = "Coconut Crab",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Coconut Field",
            CFrame = CFrame.new(-400, 50, 300)
        },
        {
            Name = "Mondo Chick",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Mondo Chick Spawn",
            CFrame = CFrame.new(100, 20, 200)
        },
        {
            Name = "Stump Snail",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Stump Field",
            CFrame = CFrame.new(-200, 10, 150)
        },
        {
            Name = "King Beetle",
            ImageId = "rbxassetid://3766691866", -- Placeholder
            Location = "Rose Field",
            CFrame = CFrame.new(-300, 15, 250)
        }
    },
    
    Init = function(self)
        -- Tạo nút boss
        for _, boss in ipairs(self.Bosses) do
            local bossButton = CreateElement("TextButton", {
                Name = boss.Name.."Button",
                Size = UDim2.new(0.9, 0, 0, 40),
                Position = UDim2.new(0.05, 0, 0, 0),
                Text = boss.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                BorderSizePixel = 0,
                Parent = BossListFrame
            })
            
            -- Hiệu ứng hover
            bossButton.MouseEnter:Connect(function()
                if self.CurrentBoss ~= boss.Name then
                    TweenService:Create(bossButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
                end
            end)
            
            bossButton.MouseLeave:Connect(function()
                if self.CurrentBoss ~= boss.Name then
                    TweenService:Create(bossButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                end
            end)
            
            bossButton.MouseButton1Click:Connect(function()
                self:SelectBoss(boss.Name)
            end)
        end
        
        BossListFrame.CanvasSize = UDim2.new(0, 0, 0, #self.Bosses * 45)
        
        -- Kết nối nút điều khiển
        StartButton.MouseButton1Click:Connect(function()
            if self.CurrentBoss then
                self:Start()
            else
                StatusLabel.Text = "Status: Please select a boss first"
            end
        end)
        
        StopButton.MouseButton1Click:Connect(function()
            self:Stop()
        end)
        
        NoClipToggle.MouseButton1Click:Connect(function()
            self:ToggleNoClip()
        end)
        
        TeleportButton.MouseButton1Click:Connect(function()
            if self.CurrentBoss then
                self:TeleportToBoss()
            else
                StatusLabel.Text = "Status: Please select a boss first"
            end
        end)
    end,
    
    SelectBoss = function(self, bossName)
        for _, boss in ipairs(self.Bosses) do
            if boss.Name == bossName then
                self.CurrentBoss = bossName
                
                -- Cập nhật giao diện
                BossNameLabel.Text = boss.Name
                BossLocationLabel.Text = "Location: "..boss.Location
                BossImage.Image = boss.ImageId
                
                -- Đặt lại màu tất cả nút
                for _, button in ipairs(BossListFrame:GetChildren()) do
                    if button:IsA("TextButton") then
                        button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    end
                end
                
                -- Đổi màu nút được chọn
                local selectedButton = BossListFrame:FindFirstChild(boss.Name.."Button")
                if selectedButton then
                    selectedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
                end
                
                StatusLabel.Text = "Status: "..boss.Name.." selected"
                break
            end
        end
    end,
    
    Start = function(self)
        if self.Active then return end
        self.Active = true
        StatusLabel.Text = "Status: Attacking "..self.CurrentBoss
        
        -- Hiệu ứng nút Start
        TweenService:Create(StartButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 120, 30)}):Play()
        
        -- Bắt đầu vòng lặp tấn công
        task.spawn(function()
            while self.Active do
                self:AttackBoss()
                task.wait(0.1)
            end
        end)
    end,
    
    Stop = function(self)
        if not self.Active then return end
        self.Active = false
        StatusLabel.Text = "Status: Stopped"
        
        -- Hiệu ứng nút Start
        TweenService:Create(StartButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 50)}):Play()
    end,
    
    AttackBoss = function(self)
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Tìm boss
        local boss = self:FindBoss(self.CurrentBoss)
        if not boss then
            -- Nếu không tìm thấy boss, di chuyển đến vị trí spawn
            for _, b in ipairs(self.Bosses) do
                if b.Name == self.CurrentBoss then
                    humanoidRootPart.CFrame = b.CFrame
                    task.wait(1)
                    return
                end
            end
            return
        end
        
        -- Xác định vị trí tấn công
        local attackCFrame
        if boss:FindFirstChild("HumanoidRootPart") then
            attackCFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        elseif boss.PrimaryPart then
            attackCFrame = boss.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
        else
            attackCFrame = boss:GetModelCFrame() * CFrame.new(0, 3, 0)
        end
        
        -- Di chuyển đến boss
        humanoidRootPart.CFrame = attackCFrame
        
        -- Sử dụng tool tấn công
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                tool.ClickEvent:FireServer()
            end
        end
        
        -- Cập nhật máu boss
        self:UpdateBossHealth(boss)
    end,
    
    FindBoss = function(self, bossName)
        for _, monster in ipairs(workspace.Monsters:GetChildren()) do
            if string.find(monster.Name, bossName) then
                return monster
            end
        end
        return nil
    end,
    
    UpdateBossHealth = function(self, boss)
        if not boss then return end
        
        local healthText = "Health: -"
        if boss:FindFirstChild("Health") then
            healthText = string.format("Health: %d/%d", boss.Health.Value, boss.MaxHealth.Value)
        end
        
        BossHealthLabel.Text = healthText
    end,
    
    TeleportToBoss = function(self)
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        for _, boss in ipairs(self.Bosses) do
            if boss.Name == self.CurrentBoss then
                humanoidRootPart.CFrame = boss.CFrame
                StatusLabel.Text = "Status: Teleported to "..boss.Name
                break
            end
        end
    end,
    
    ToggleNoClip = function(self)
        self.NoClipEnabled = not self.NoClipEnabled
        NoClipToggle.Text = "NO CLIP: "..(self.NoClipEnabled and "ON" or "OFF")
        
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not self.NoClipEnabled
            end
        end
        
        -- Hiệu ứng đổi màu nút
        TweenService:Create(NoClipToggle, TweenInfo.new(0.2), {
            BackgroundColor3 = self.NoClipEnabled and Color3.fromRGB(100, 100, 150) or Color3.fromRGB(80, 80, 80)
        }):Play()
    end
}

-- Khởi tạo hệ thống
AutoKillSystem:Init()

-- Hệ thống NoClip tự động
RunService.Stepped:Connect(function()
    if AutoKillSystem.NoClipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Hiệu ứng giao diện
local function AddHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

AddHoverEffect(StartButton, Color3.fromRGB(50, 150, 50), Color3.fromRGB(70, 170, 70))
AddHoverEffect(StopButton, Color3.fromRGB(150, 50, 50), Color3.fromRGB(170, 70, 70))
AddHoverEffect(NoClipToggle, Color3.fromRGB(80, 80, 80), Color3.fromRGB(100, 100, 100))
AddHoverEffect(TeleportButton, Color3.fromRGB(80, 80, 80), Color3.fromRGB(100, 100, 100))

-- Phím tắt
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        KillerBeeGUI.Enabled = not KillerBeeGUI.Enabled
    end
end)

warn("Killer Bee Auto Boss GUI loaded successfully!")
