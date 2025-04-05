-- ========== CORE SERVICES ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- ========== ADVANCED ANTI-LAG SYSTEM ==========
local Performance = {
    OriginalSettings = {},
    OptimizedParts = {},
    
    UltraOptimize = function(self)
        -- Save original settings
        self.OriginalSettings = {
            QualityLevel = settings().Rendering.QualityLevel,
            GlobalShadows = settings().Rendering.GlobalShadows,
            MeshCacheSize = settings().Rendering.MeshCacheSize,
            EagerBulkExecution = settings().TaskScheduler.EagerBulkExecution,
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd
        }
        
        -- Apply extreme performance settings
        settings().Rendering.QualityLevel = 1
        settings().Rendering.GlobalShadows = false
        settings().Rendering.MeshCacheSize = 1
        settings().TaskScheduler.EagerBulkExecution = false
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.new(0, 0, 0)
        
        -- Optimize all parts in workspace
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if not part:FindFirstAncestorOfClass("Model") or 
                   not part:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
                    self.OptimizedParts[part] = {
                        Transparency = part.Transparency,
                        Material = part.Material,
                        Color = part.Color,
                        CastShadow = part.CastShadow
                    }
                    part.Transparency = math.min(1, part.Transparency + 0.8)
                    part.Material = Enum.Material.Plastic
                    part.Color = Color3.new(0.3, 0.3, 0.3)
                    part.CastShadow = false
                end
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                part.Enabled = false
                self.OptimizedParts[part] = true
            elseif part:IsA("Decal") then
                part.Transparency = 1
                self.OptimizedParts[part] = true
            end
        end
        
        -- Optimize player characters (except self)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.8
                        part.CastShadow = false
                    end
                end
            end
        end
    end,
    
    Restore = function(self)
        -- Restore original settings
        settings().Rendering.QualityLevel = self.OriginalSettings.QualityLevel or 10
        settings().Rendering.GlobalShadows = self.OriginalSettings.GlobalShadows or true
        settings().Rendering.MeshCacheSize = self.OriginalSettings.MeshCacheSize or 100
        settings().TaskScheduler.EagerBulkExecution = self.OriginalSettings.EagerBulkExecution or true
        Lighting.Brightness = self.OriginalSettings.Brightness or 1
        Lighting.GlobalShadows = self.OriginalSettings.GlobalShadows or true
        Lighting.FogEnd = self.OriginalSettings.FogEnd or 100000
        
        -- Restore parts
        for part, data in pairs(self.OptimizedParts) do
            if part:IsA("BasePart") and type(data) == "table" then
                part.Transparency = data.Transparency or 0
                part.Material = data.Material or Enum.Material.Plastic
                part.Color = data.Color or Color3.new(1, 1, 1)
                part.CastShadow = data.CastShadow or false
            elseif (part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Decal")) and data == true then
                part.Enabled = true
                if part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
        
        self.OptimizedParts = {}
        self.OriginalSettings = {}
    end
}

-- ========== ENHANCED ANTI-BAN SYSTEM ==========
local AntiBan = {
    LastActionTime = 0,
    ActionCooldown = math.random(45, 90),
    DetectionRisk = 0,
    
    Behaviors = {
        -- Movement patterns
        function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local randomAngle = math.random() * math.pi * 2
                local randomDist = math.random(5, 15)
                local offset = Vector3.new(math.cos(randomAngle) * randomDist, 0, math.sin(randomAngle) * randomDist)
                humanoid:MoveTo(humanoid.RootPart.Position + offset)
            end
        end,
        
        -- Camera adjustments
        function()
            local camera = workspace.CurrentCamera
            if camera then
                local currentCF = camera.CFrame
                local randomRot = CFrame.Angles(
                    math.rad(math.random(-5, 5)),
                    math.rad(math.random(-5, 5)),
                    0
                )
                camera.CFrame = currentCF * randomRot
            end
        end,
        
        -- Short pauses
        function()
            local waitTime = math.random(1, 3)
            task.wait(waitTime)
        end
    },
    
    EnvironmentChecks = {
        function() -- Admin detection
            for _, player in ipairs(Players:GetPlayers()) do
                if player:IsInGroup(1200769) then -- Bee Swarm admin group
                    return true
                end
            end
            return false
        end,
        
        function() -- Suspicious activity detection
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local velocity = humanoid.RootPart.Velocity.Magnitude
                if velocity > 150 then -- Unnaturally high speed
                    return true
                end
            end
            return false
        end
    },
    
    Execute = function(self)
        -- Check environment
        for _, check in ipairs(self.EnvironmentChecks) do
            if check() then
                self.DetectionRisk = self.DetectionRisk + 0.2
                warn("[ANTI-BAN] Suspicious activity detected! Risk level:", self.DetectionRisk)
                
                if self.DetectionRisk > 0.8 then
                    warn("[ANTI-BAN] High risk detected! Taking evasive action.")
                    self:EmergencyProtocol()
                    return true
                end
            end
        end
        
        -- Random behavior
        if os.time() - self.LastActionTime > self.ActionCooldown then
            self.Behaviors[math.random(1, #self.Behaviors)]()
            self.LastActionTime = os.time()
            self.ActionCooldown = math.random(45, 90)
            self.DetectionRisk = math.max(0, self.DetectionRisk - 0.1)
        end
        
        return false
    end,
    
    EmergencyProtocol = function(self)
        -- Stop all activities
        WindyBeeFarm:Stop()
        
        -- Disconnect temporarily
        task.wait(math.random(5, 15))
        
        -- Random movement
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _ = 1, math.random(3, 6) do
                local randomAngle = math.random() * math.pi * 2
                local randomDist = math.random(10, 30)
                local offset = Vector3.new(math.cos(randomAngle) * randomDist, 0, math.sin(randomAngle) * randomDist)
                humanoid:MoveTo(humanoid.RootPart.Position + offset)
                task.wait(math.random(1, 2))
            end
        end
        
        -- Reset detection risk
        self.DetectionRisk = 0
    end
}

-- ========== WINDY BEE KILLER ==========
local WindyBeeFarm = {
    Active = false,
    AttackCooldown = 0.1,
    LastAttack = 0,
    
    Start = function(self)
        if self.Active then return end
        self.Active = true
        
        task.spawn(function()
            while self.Active do
                -- Anti-ban check
                if AntiBan:Execute() then
                    self:Stop()
                    break
                end
                
                -- Find Windy Bee
                local windyBee = self:FindTarget()
                if windyBee then
                    -- Position player for attack
                    local character = LocalPlayer.Character
                    if character then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            -- Calculate attack position
                            local targetCFrame = windyBee:FindFirstChild("HumanoidRootPart") and 
                                               windyBee.HumanoidRootPart.CFrame * CFrame.new(0, 3, -5) or
                                               windyBee.PrimaryPart.CFrame * CFrame.new(0, 3, -5)
                            
                            -- Smooth teleport
                            rootPart.CFrame = targetCFrame
                            
                            -- Attack if cooldown is over
                            if os.clock() - self.LastAttack > self.AttackCooldown then
                                -- Simulate click without tool switching
                                local args = {
                                    RaycastHit = {
                                        Position = windyBee.PrimaryPart.Position,
                                        Normal = Vector3.new(0, 1, 0),
                                        Material = Enum.Material.Plastic
                                    },
                                    RaycastOrigin = rootPart.Position,
                                    RaycastDirection = (windyBee.PrimaryPart.Position - rootPart.Position).Unit * 50
                                }
                                
                                -- Fire click event directly (bypasses tool requirement)
                                game:GetService("ReplicatedStorage").Events.PlayerClickEvent:FireServer(args)
                                self.LastAttack = os.clock()
                            end
                        end
                    end
                else
                    task.wait(1) -- Wait if target not found
                end
                
                task.wait()
            end
        end)
    end,
    
    Stop = function(self)
        self.Active = false
    end,
    
    FindTarget = function(self)
        for _, monster in ipairs(workspace.Monsters:GetChildren()) do
            if string.find(monster.Name:lower(), "windy bee") then
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

-- ========== MINIMALIST UI ==========
local DarkCyberGUI = CreateElement("ScreenGui", {
    Name = "WindyBeeKillerUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 300, 0, 180),
    Position = UDim2.new(0.5, -150, 0.5, -90),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = DarkCyberGUI
})

-- Title Bar
local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(15, 15, 25),
    BorderSizePixel = 0,
    Parent = MainFrame
})

local TitleLabel = CreateElement("TextLabel", {
    Name = "TitleLabel",
    Size = UDim2.new(0.7, 0, 1, 0),
    Text = "WINDY BEE KILLER",
    TextColor3 = Color3.fromRGB(0, 200, 255),
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
    DarkCyberGUI:Destroy()
    Performance:Restore()
end)

-- Main Content
local ContentFrame = CreateElement("Frame", {
    Name = "ContentFrame",
    Size = UDim2.new(1, -20, 1, -50),
    Position = UDim2.new(0, 10, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Toggle Button
local ToggleButton = CreateElement("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 0),
    Text = "START KILLING",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(0, 150, 0),
    Parent = ContentFrame
})

-- NoClip Toggle
local NoClipButton = CreateElement("TextButton", {
    Name = "NoClipButton",
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 50),
    Text = "NO-CLIP: OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundColor3 = Color3.fromRGB(60, 60, 80),
    Parent = ContentFrame
})

-- Status Info
local StatusLabel = CreateElement("TextLabel", {
    Name = "StatusLabel",
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 90),
    Text = "Status: Ready\nDetection Risk: 0%",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ContentFrame
})

-- Button Connections
ToggleButton.MouseButton1Click:Connect(function()
    if WindyBeeFarm.Active then
        WindyBeeFarm:Stop()
        ToggleButton.Text = "START KILLING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        StatusLabel.Text = "Status: Inactive\nDetection Risk: "..math.floor(AntiBan.DetectionRisk * 100).."%"
    else
        WindyBeeFarm:Start()
        ToggleButton.Text = "STOP KILLING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        StatusLabel.Text = "Status: Hunting Windy Bee\nDetection Risk: "..math.floor(AntiBan.DetectionRisk * 100).."%"
    end
end)

NoClipButton.MouseButton1Click:Connect(function()
    NoClip:Toggle()
    if NoClip.Enabled then
        NoClipButton.Text = "NO-CLIP: ON"
        NoClipButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    else
        NoClipButton.Text = "NO-CLIP: OFF"
        NoClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Auto-update status
task.spawn(function()
    while DarkCyberGUI.Parent do
        StatusLabel.Text = "Status: "..(WindyBeeFarm.Active and "Hunting Windy Bee" or "Inactive").."\nDetection Risk: "..math.floor(AntiBan.DetectionRisk * 100).."%"
        task.wait(0.5)
    end
end)

-- Initialize
Performance:UltraOptimize()
