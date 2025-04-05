-- ========== ONE-HIT KILL SYSTEM FIX ==========
local OneHitKill = {
    Enabled = false,
    DamageMultiplier = 100,
    OriginalFunctions = {},
    Connections = {},
    
    -- Danh sách các remote event liên quan đến damage
    DamageRemotes = {
        "DamageMonsterRemote",
        "BeesAttackRemote",
        "HiveDamageRemote"
    },
    
    Toggle = function(self)
        self.Enabled = not self.Enabled
        if self.Enabled then
            self:Activate()
        else
            self:Deactivate()
        end
        
        -- Cập nhật giao diện
        OneHitToggle.Text = "ONE-HIT KILL: " .. (self.Enabled and "ON" or "OFF")
        OneHitToggle.BackgroundColor3 = self.Enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    end,
    
    Activate = function(self)
        -- Hook vào tất cả remote event damage
        for _, remoteName in ipairs(self.DamageRemotes) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if remote then
                self.OriginalFunctions[remoteName] = remote.FireServer
                remote.FireServer = function(_, ...)
                    local args = {...}
                    if self.Enabled then
                        -- Tăng damage cho ong (thường ở arg thứ 2 hoặc 3)
                        if #args >= 2 and type(args[2]) == "number" then
                            args[2] = args[2] * self.DamageMultiplier
                        elseif #args >= 3 and type(args[3]) == "number" then
                            args[3] = args[3] * self.DamageMultiplier
                        end
                    end
                    return self.OriginalFunctions[remoteName](_, unpack(args))
                end
            end
        end
        
        -- Hook thêm vào hàm TakeDamage nếu có
        if not self.OriginalFunctions.TakeDamage then
            local oldTakeDamage; oldTakeDamage = hookfunction(Instance.new("Model").TakeDamage, function(obj, amount, ...)
                if self.Enabled and obj:IsDescendantOf(workspace.Monsters) then
                    amount = amount * self.DamageMultiplier
                end
                return oldTakeDamage(obj, amount, ...)
            end
            self.OriginalFunctions.TakeDamage = oldTakeDamage
        end
        
        warn("[ONE-HIT] Đã kích hoạt chế độ one-hit kill cho ong!")
    end,
    
    Deactivate = function(self)
        -- Khôi phục tất cả remote event
        for remoteName, originalFunc in pairs(self.OriginalFunctions) do
            if remoteName ~= "TakeDamage" then
                local remote = ReplicatedStorage:FindFirstChild(remoteName)
                if remote then
                    remote.FireServer = originalFunc
                end
            end
        end
        
        -- Khôi phục hàm TakeDamage
        if self.OriginalFunctions.TakeDamage then
            Instance.new("Model").TakeDamage = self.OriginalFunctions.TakeDamage
        end
        
        self.OriginalFunctions = {}
        warn("[ONE-HIT] Đã tắt chế độ one-hit kill")
    end,
    
    -- Hàm mới: Kiểm tra và cập nhật damage multiplier
    UpdateDamage = function(self, value)
        self.DamageMultiplier = math.clamp(value, 10, 1000)
    end
}

-- ========== CẬP NHẬT GIAO DIỆN ==========
-- Thêm slider điều chỉnh damage multiplier
local MultiplierSlider = CreateElement("Frame", {
    Name = "MultiplierSlider",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0.7, 0),
    BackgroundTransparency = 1,
    Parent = SettingsContent
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

local SliderBar = CreateElement("Frame", {
    Name = "SliderBar",
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 0, 25),
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Parent = MultiplierSlider
})

local SliderButton = CreateElement("TextButton", {
    Name = "SliderButton",
    Size = UDim2.new(0, 15, 0, 15),
    Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20),
    Text = "",
    BackgroundColor3 = Color3.fromRGB(100, 150, 255),
    Parent = MultiplierSlider
})

-- Xử lý slider
local sliding = false
SliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

SliderBar.MouseButton1Down:Connect(function(x)
    local percent = math.clamp(x / SliderBar.AbsoluteSize.X, 0, 1)
    OneHitKill:UpdateDamage(math.floor(10 + percent * 990))
    MultiplierLabel.Text = "Damage Multiplier: "..OneHitKill.DamageMultiplier.."x"
    SliderButton.Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20)
end)

RunService.Heartbeat:Connect(function()
    if sliding then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = SliderBar.AbsolutePosition.X
        local sliderSize = SliderBar.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        
        OneHitKill:UpdateDamage(math.floor(10 + percent * 990))
        MultiplierLabel.Text = "Damage Multiplier: "..OneHitKill.DamageMultiplier.."x"
        SliderButton.Position = UDim2.new((OneHitKill.DamageMultiplier-10)/990, 0, 0, 20)
    end
end)

-- Kết nối nút bật/tắt
OneHitToggle.MouseButton1Click:Connect(function()
    OneHitKill:Toggle()
end)
