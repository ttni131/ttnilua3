-- HyperShot Framework v2.0
-- GitHub: ttni131/ttnilua3
-- Özellikler: Aimbot, ESP, Fly, Super Jump

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Ayarlar
local Settings = {
    Aimbot = false,
    ESP = false,
    Fly = false,
    JumpPower = 50,
    FlySpeed = 50
}

-- UI Tasarımı (Cyberpunk Tema)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0

-- Kenarlık (Neon Mor)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(170, 0, 255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HYPERSHOT LUA"
Title.TextColor3 = Color3.fromRGB(0, 255, 180) -- Neon Yeşil
Title.Font = Enum.Font.Code
Title.BackgroundTransparency = 1

-- Fonksiyonlar
local function GetClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mouseDist < dist then
                    closest = v
                    dist = mouseDist
                end
            end
        end
    end
    return closest
end

-- Ana Döngü (Aimbot & Fly)
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = GetClosestPlayer()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
    
    if Settings.Fly and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0.1, 0) -- Yerçekimini nötrle
        end
    end
end)

-- Buton Oluşturucu
local function AddButton(name, yPos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.SourceSans
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- Butonları Tanımla
AddButton("Aimbot: OFF", 50, function(b)
    Settings.Aimbot = not Settings.Aimbot
    b.Text = Settings.Aimbot and "Aimbot: ON" or "Aimbot: OFF"
    b.TextColor3 = Settings.Aimbot and Color3.fromRGB(0, 255, 0) or Color3.white
end)

AddButton("ESP: TOGGLE", 100, function()
    -- Basit Highlight ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

AddButton("Fly: OFF", 150, function(b)
    Settings.Fly = not Settings.Fly
    b.Text = Settings.Fly and "Fly: ON" or "Fly: OFF"
end)

AddButton("Super Jump", 200, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 120
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("HyperShot Inject Edildi! GitHub: ttni131")
