--[[
  Bee Swarm Simulator Auto-Kill & Farming GUI
  Phiên bản hoàn chỉnh với đầy đủ tính năng:
  - Auto-Kill boss
  - Auto-Farm các loại field
  - One-Hit Kill (không dùng buff)
  - No-Clip
  - Tối ưu hiệu suất
  - Giao diện dễ sử dụng
]]

-- ========== CÀI ĐẶT BAN ĐẦU ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Kiểm tra game
if game.PlaceId ~= 1537690962 then
    warn("Script chỉ hoạt động trong Bee Swarm Simulator!")
    return
end

-- Hàm tạo element an toàn
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        pcall(function() element[prop] = value end)
    end
    return element
end

-- Bảo vệ GUI
local function ProtectGUI(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end

-- ========== TẠO GIAO DIỆN ==========
local MainGUI = CreateElement("ScreenGui", {
    Name = "BSSAutoFarmGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
ProtectGUI(MainGUI)

local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 450, 0, 350),
    Position = UDim2.new(0.5, -225, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = MainGUI
})

-- Thanh tiêu đề
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
    Text = "BSS AUTO FARM v2.0",
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

-- Tabs chính
local Tabs = {"Auto-Kill", "Auto-Farm", "Settings"}
local TabButtons = {}
local TabContents = {}

for i, tabName in ipairs(Tabs) do
    local tabButton = CreateElement("TextButton", {
        Name = tabName.."Tab",
        Size = UDim2.new(1/#Tabs, 0, 0, 30),
        Position = UDim2.new((i-1)/#Tabs, 0, 0, 30),
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

-- ========== HỆ THỐNG AUTO-KILL ==========
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

-- Giao diện Auto-Kill
local AutoKillContent = TabContents["Auto-Kill"]

-- Dropdown chọn boss
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

local BossListFrame = CreateElement("ScrollingFrame", {
    Name = "BossListFrame",
    Size = UDim2.new(0.3, 0, 0, 150),
    Position = UDim2.new(0.7, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(50, 50, 70),
    ScrollBarThickness = 5,
    Visible = false,
    Parent = BossDropdown
})

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

-- Nút bật/tắt
local ToggleKillButton = CreateElement("TextButton", {
    Name = "ToggleKillButton",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.4, 0),
    Text = "START AUTO-KILL",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(50, 150, 50),
    Parent = AutoKillContent
})

-- Label trạng thái
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

-- ========== HỆ THỐNG AUTO-FARM ==========
local AutoFarm = {
    Active = false,
    Fields = {
        "Sunflower Field",
        "Mushroom Field",
        "Dandelion Field",
        "Blue Flower Field",
        "Clover Field",
        "Spider Field",
        "Bamboo Field",
        "Strawberry Field",
        "Pineapple Patch",
        "Stump Field",
        "Rose Field",
        "Cactus Field",
        "Pumpkin Patch",
        "Pine Tree Forest",
        "Mountain Top Field",
        "Coconut Field",
        "Pepper Patch"
    },
    CurrentField = "Sunflower Field"
}

-- Giao diện Auto-Farm
local AutoFarmContent = TabContents["Auto-Farm"]

local FieldList = CreateElement("ScrollingFrame", {
    Name = "FieldList",
    Size = UDim2.new(0.9, 0, 0.7, 0),
    Position = UDim2.new(0.05, 0, 0.1, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 60),
    ScrollBarThickness = 5,
    Parent = AutoFarmContent
})

for i, fieldName in ipairs(AutoFarm.Fields) do
    local fieldButton = CreateElement("TextButton", {
        Name = fieldName.."Button",
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, 0, (i-1)*30),
        Text = fieldName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = fieldName == AutoFarm.CurrentField and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(60, 60, 80),
        Parent = FieldList
    })
    
    fieldButton.MouseButton1Click:Connect(function()
        AutoFarm.CurrentField = fieldName
        for _, btn in ipairs(FieldList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = btn.Text == fieldName and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(60, 60, 80)
            end
        end
    end)
end

FieldList.CanvasSize = UDim2.new(0, 0, 0, #AutoFarm.Fields * 30)

local ToggleFarmButton = CreateElement("TextButton", {
    Name = "ToggleFarmButton",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.85, 0),
    Text = "START AUTO-FARM",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(50, 150, 50),
    Parent = AutoFarmContent
})

-- ========== CÀI ĐẶT ==========
local SettingsContent = TabContents["Settings"]

-- No-Clip
local NoClipToggle = CreateElement("TextButton", {
    Name = "NoClipToggle",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.1, 0),
    Text = "NO-CLIP: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = SettingsContent
})

-- One-Hit Kill
local OneHitToggle = CreateElement("TextButton", {
    Name = "OneHitToggle",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.3, 0),
    Text = "ONE-HIT KILL: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(150, 50, 50),
    Parent = SettingsContent
})

-- Performance Optimizer
local OptimizeToggle = CreateElement("TextButton", {
    Name = "OptimizeToggle",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.5, 0),
    Text = "OPTIMIZE PERFORMANCE: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = SettingsContent
})

-- ========== CHỨC NĂNG HỆ THỐNG ==========
-- No-Clip System
local NoClip = {
    Enabled = false,
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        NoClipToggle.Text = "NO-CLIP: " .. (self.Enabled and "ON" or "OFF")
        NoClipToggle.BackgroundColor3 = self.Enabled and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(80, 80, 100)
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

-- One-Hit Kill System
local OneHitKill = {
    Enabled = false,
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        OneHitToggle.Text = "ONE-HIT KILL: " .. (self.Enabled and "ON" or "OFF")
        OneHitToggle.BackgroundColor3 = self.Enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    end
}

-- Performance Optimizer
local Performance = {
    Optimized = false,
    OriginalSettings = {},
    
    Toggle = function(self)
        self.Optimized = not self.Optimized
        OptimizeToggle.Text = "OPTIMIZE PERFORMANCE: " .. (self.Optimized and "ON" or "OFF")
        OptimizeToggle.BackgroundColor3 = self.Optimized and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(80, 80, 100)
        
        if self.Optimized then
            self:Optimize()
        else
            self:Restore()
        end
    end,
    
    Optimize = function(self)
        -- Lưu cài đặt gốc
        self.OriginalSettings = {
            QualityLevel = settings().Rendering.QualityLevel,
            GlobalShadows = settings().Rendering.GlobalShadows,
            Brightness = Lighting.Brightness
        }
        
        -- Áp dụng tối ưu
        settings().Rendering.QualityLevel = 1
        settings().Rendering.GlobalShadows = false
        Lighting.Brightness = 2
        
        -- Giảm chất lượng các phần tử không cần thiết
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:FindFirstAncestorWhichIsA("Model"):FindFirstChildOfClass("Humanoid") then
                part.Transparency = math.min(1, part.Transparency + 0.5)
                part.Material = Enum.Material.Plastic
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                part.Enabled = false
            end
        end
    end,
    
    Restore = function(self)
        -- Khôi phục cài đặt gốc
        settings().Rendering.QualityLevel = self.OriginalSettings.QualityLevel or 10
        settings().Rendering.GlobalShadows = self.OriginalSettings.GlobalShadows or true
        Lighting.Brightness = self.OriginalSettings.Brightness or 1
        
        -- Khôi phục các phần tử
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.Material = Enum.Material.Plastic
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                part.Enabled = true
            end
        end
    end
}

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
    ToggleKillButton.Text = "STOP AUTO-KILL"
    ToggleKillButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
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
                            -- Tính vị trí tấn công
                            local offset = bossRoot.CFrame.LookVector * -self.AttackDistance
                            offset = offset + Vector3.new(0, self.AttackHeight, 0)
                            local attackCFrame = CFrame.new(bossRoot.Position + offset, bossRoot.Position)
                            
                            -- Di chuyển đến vị trí tấn công
                            humanoidRootPart.CFrame = attackCFrame
                            
                            -- Sử dụng tất cả tool để tấn công
                            for _, tool in ipairs(character:GetChildren()) do
                                if tool:IsA("Tool") then
                                    if OneHitKill.Enabled then
                                        -- One-Hit Kill mode
                                        for i = 1, 10 do
                                            tool.ClickEvent:FireServer()
                                        end
                                    else
                                        -- Normal attack
                                        tool.ClickEvent:FireServer()
                                    end
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
    ToggleKillButton.Text = "START AUTO-KILL"
    ToggleKillButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    StatusLabel.Text = "Status: Inactive"
end

-- Auto-Farm Logic
function AutoFarm:Start()
    if self.Active then return end
    
    self.Active = true
    ToggleFarmButton.Text = "STOP AUTO-FARM"
    ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    
    spawn(function()
        while self.Active do
            local character = LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- Di chuyển đến field
                    local field = workspace.FlowerZones:FindFirstChild(self.CurrentField)
                    if field then
                        humanoidRootPart.CFrame = field.CFrame
                        
                        -- Sử dụng tool để farm
                        for _, tool in ipairs(character:GetChildren()) do
                            if tool:IsA("Tool") then
                                tool.ClickEvent:FireServer()
                            end
                        end
                    end
                end
            end
            
            task.wait(0.1)
        end
    end)
end

function AutoFarm:Stop()
    self.Active = false
    ToggleFarmButton.Text = "START AUTO-FARM"
    ToggleFarmButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
end

-- ========== KẾT NỐI NÚT BẤM ==========
-- Auto-Kill
ToggleKillButton.MouseButton1Click:Connect(function()
    if AutoKill.Active then
        AutoKill:Stop()
    else
        AutoKill:Start()
    end
end)

BossDropdownButton.MouseButton1Click:Connect(function()
    BossListFrame.Visible = not BossListFrame.Visible
end)

-- Auto-Farm
ToggleFarmButton.MouseButton1Click:Connect(function()
    if AutoFarm.Active then
        AutoFarm:Stop()
    else
        AutoFarm:Start()
    end
end)

-- Settings
NoClipToggle.MouseButton1Click:Connect(function()
    NoClip:Toggle()
end)

OneHitToggle.MouseButton1Click:Connect(function()
    OneHitKill:Toggle()
end)

OptimizeToggle.MouseButton1Click:Connect(function()
    Performance:Toggle()
end)

CloseButton.MouseButton1Click:Connect(function()
    MainGUI:Destroy()
    Performance:Restore()
end)

-- ========== KHỞI CHẠY ==========
warn("Bee Swarm Simulator Auto-Farm GUI đã sẵn sàng!")
