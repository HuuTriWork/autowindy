-- ========== ONE-HIT KILL SYSTEM ==========
local OneHitKill = {
    Enabled = false,
    DamageMultiplier = 100,  -- Hệ số nhân damage
    OriginalFunctions = {},
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        if self.Enabled then
            self:Activate()
        else
            self:Deactivate()
        end
    end,
    
    Activate = function(self)
        -- Hook trực tiếp vào hàm xử lý damage
        local old; old = hookfunction(Instance.new("Model").TakeDamage, function(obj, amount, ...)
            if self.Enabled and obj:IsDescendantOf(workspace.Monsters) then
                amount = amount * self.DamageMultiplier
            end
            return old(obj, amount, ...)
        end
        
        -- Hoặc hook vào RemoteEvent nếu game sử dụng
        if ReplicatedStorage:FindFirstChild("DamageMonsterRemote") then
            self.OriginalFunctions.DamageMonster = ReplicatedStorage.DamageMonsterRemote.FireServer
            ReplicatedStorage.DamageMonsterRemote.FireServer = function(_, ...)
                if self.Enabled then
                    local args = {...}
                    args[2] = args[2] * self.DamageMultiplier  -- Nhân damage
                    return self.OriginalFunctions.DamageMonster(_, unpack(args))
                end
                return self.OriginalFunctions.DamageMonster(_, ...)
            end
        end
        
        warn("[ONE-HIT] Kích hoạt chế độ one-hit kill!")
    end,
    
    Deactivate = function(self)
        -- Khôi phục hàm gốc
        if self.OriginalFunctions.TakeDamage then
            Instance.new("Model").TakeDamage = self.OriginalFunctions.TakeDamage
        end
        
        if self.OriginalFunctions.DamageMonster then
            ReplicatedStorage.DamageMonsterRemote.FireServer = self.OriginalFunctions.DamageMonster
        end
        
        warn("[ONE-HIT] Tắt chế độ one-hit kill")
    end,
    
    SetMultiplier = function(self, value)
        self.DamageMultiplier = math.clamp(value, 10, 1000)
    end
}

-- ========== THÊM VÀO GUI ==========
local OneHitTab = TabContents["Auto-Kill"]

-- Toggle Button
local OneHitToggle = CreateElement("TextButton", {
    Name = "OneHitToggle",
    Size = UDim2.new(0.9, 0, 0, 40),
    Position = UDim2.new(0.05, 0, 0.8, 0),
    Text = "ONE-HIT: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(150, 50, 50),
    Parent = OneHitTab
})

-- Damage Multiplier Slider
local MultiplierSlider = CreateElement("Frame", {
    Name = "MultiplierSlider",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0.85, 0),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = OneHitTab
})

local MultiplierLabel = CreateElement("TextLabel", {
    Name = "MultiplierLabel",
    Size = UDim2.new(1, 0, 0, 20),
    Text = "Damage Multiplier: "..OneHitKill.DamageMultiplier.."x",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    Parent = MultiplierSlider
})

local MultiplierSliderBar = CreateElement("TextButton", {
    Name = "MultiplierSliderBar",
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 0, 25),
    Text = "",
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = MultiplierSlider
})

local MultiplierSliderButton = CreateElement("TextButton", {
    Name = "MultiplierSliderButton",
    Size = UDim2.new(0, 15, 0, 15),
    Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20),
    Text = "",
    BackgroundColor3 = Color3.fromRGB(255, 100, 100),
    Parent = MultiplierSlider
})

-- Slider functionality
local multiplierSliding = false
MultiplierSliderButton.MouseButton1Down:Connect(function()
    multiplierSliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        multiplierSliding = false
    end
end)

MultiplierSliderBar.MouseButton1Down:Connect(function(x)
    local percent = math.clamp(x / MultiplierSliderBar.AbsoluteSize.X, 0, 1)
    OneHitKill:SetMultiplier(math.floor(10 + percent * 990))
    MultiplierLabel.Text = "Damage Multiplier: "..OneHitKill.DamageMultiplier.."x"
    MultiplierSliderButton.Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20)
end)

RunService.Heartbeat:Connect(function()
    if multiplierSliding then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = MultiplierSliderBar.AbsolutePosition.X
        local sliderSize = MultiplierSliderBar.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        
        OneHitKill:SetMultiplier(math.floor(10 + percent * 990))
        MultiplierLabel.Text = "Damage Multiplier: "..OneHitKill.DamageMultiplier.."x"
        MultiplierSliderButton.Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20)
    end
end)

-- Toggle functionality
OneHitToggle.MouseButton1Click:Connect(function()
    OneHitKill:Toggle()
    OneHitToggle.Text = "ONE-HIT: " .. (OneHitKill.Enabled and "ON" or "OFF")
    OneHitToggle.BackgroundColor3 = OneHitKill.Enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    MultiplierSlider.Visible = OneHitKill.Enabled
end)

warn("One-Hit Kill system (no buffs) loaded! Use with extreme caution!")
