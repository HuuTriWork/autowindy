-- Bee Swarm Simulator Auto-Jelly Bean Farming GUI
-- Created by [Your Name]

local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Main GUI
local JellyBeanGUI = Instance.new("ScreenGui")
JellyBeanGUI.Name = "JellyBeanFarmerGUI"
JellyBeanGUI.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = JellyBeanGUI
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Jelly Bean Farmer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Field Selection
local FieldSelection = Instance.new("ScrollingFrame")
FieldSelection.Name = "FieldSelection"
FieldSelection.Parent = MainFrame
FieldSelection.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
FieldSelection.Position = UDim2.new(0, 10, 0, 40)
FieldSelection.Size = UDim2.new(0.5, -15, 0, 150)
FieldSelection.CanvasSize = UDim2.new(0, 0, 0, 300)
FieldSelection.ScrollBarThickness = 5

-- Available Fields
local fields = {
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
    "Cactus Field",
    "Pumpkin Patch",
    "Pine Tree Forest",
    "Rose Field",
    "Mountain Top Field",
    "Coconut Field",
    "Pepper Patch"
}

-- Create field buttons
for i, fieldName in ipairs(fields) do
    local FieldButton = Instance.new("TextButton")
    FieldButton.Name = fieldName
    FieldButton.Parent = FieldSelection
    FieldButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    FieldButton.BorderSizePixel = 0
    FieldButton.Position = UDim2.new(0, 5, 0, (i-1)*30)
    FieldButton.Size = UDim2.new(1, -10, 0, 25)
    FieldButton.Font = Enum.Font.Gotham
    FieldButton.Text = fieldName
    FieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FieldButton.TextSize = 12
end

-- Status Panel
local StatusPanel = Instance.new("Frame")
StatusPanel.Name = "StatusPanel"
StatusPanel.Parent = MainFrame
StatusPanel.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
StatusPanel.Position = UDim2.new(0.5, 5, 0, 40)
StatusPanel.Size = UDim2.new(0.5, -15, 0, 150)

-- Selected Field Display
local SelectedField = Instance.new("TextLabel")
SelectedField.Name = "SelectedField"
SelectedField.Parent = StatusPanel
SelectedField.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SelectedField.Position = UDim2.new(0, 5, 0, 5)
SelectedField.Size = UDim2.new(1, -10, 0, 30)
SelectedField.Font = Enum.Font.Gotham
SelectedField.Text = "No field selected"
SelectedField.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedField.TextSize = 12

-- Start/Stop Button
local StartButton = Instance.new("TextButton")
StartButton.Name = "StartButton"
StartButton.Parent = StatusPanel
StartButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
StartButton.Position = UDim2.new(0, 5, 0, 40)
StartButton.Size = UDim2.new(1, -10, 0, 30)
StartButton.Font = Enum.Font.GothamBold
StartButton.Text = "START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 14

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = StatusPanel
StatusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
StatusLabel.Position = UDim2.new(0, 5, 0, 75)
StatusLabel.Size = UDim2.new(1, -10, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 12

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Variables
local selectedField = nil
local isRunning = false
local noclip = false

-- Field Selection Logic
for _, button in ipairs(FieldSelection:GetChildren()) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            selectedField = button.Name
            SelectedField.Text = "Selected: "..selectedField
            StatusLabel.Text = "Status: Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        end)
    end
end

-- Start/Stop Functionality
StartButton.MouseButton1Click:Connect(function()
    if not selectedField then
        StatusLabel.Text = "Status: Select a field first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        return
    end
    
    isRunning = not isRunning
    
    if isRunning then
        StartButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        StartButton.Text = "STOP"
        StatusLabel.Text = "Status: Running"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        
        -- Enable noclip
        noclip = true
        
        -- Teleport to selected field
        local fieldCFrame = workspace.FlowerZones[selectedField].CFrame
        player.Character.HumanoidRootPart.CFrame = fieldCFrame + Vector3.new(0, 5, 0)
        
        -- Start auto-bean dropping
        spawn(function()
            while isRunning do
                -- Drop jelly bean
                local A = {
                    ["Name"] = "Jelly Beans"
                }
                local Event = game:GetService("ReplicatedStorage").Events.PlayerActivesCommand
                Event:FireServer(A)
                
                -- Wait before dropping next bean
                wait(0.5)
            end
        end)
    else
        StartButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        StartButton.Text = "START"
        StatusLabel.Text = "Status: Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Disable noclip
        noclip = false
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    JellyBeanGUI:Destroy()
end)

-- Noclip functionality
game:GetService('RunService').Stepped:connect(function()
    if noclip and player.Character then
        player.Character.Humanoid:ChangeState(11)
    end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
