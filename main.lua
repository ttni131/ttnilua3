-- HyperShot v5.0 | Menü & Tıklama Fix
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Aimbot = false,
    ESP = false,
    WallCheck = true,
    Smoothing = 0.12, -- Ghost mod için yumuşak geçiş
    Visible = true
}

-- --- UI TEMEL ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HyperShot_Official"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Ekranın en üstüne kadar çıkabilsin

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.Draggable = true -- Klasik sürükleme

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(170, 0, 255) -- Neon Mor
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HYPERSHOT V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.Code
Title.BackgroundTransparency = 1
Title.TextSize = 18

-- --- FONKSİYONLAR ---

local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = {char, targetPart.Parent}
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 500, ray)
    return result == nil
end

local function GetTarget()
    local target = nil
    local dist = 500
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and IsVisible(head) then
                local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mDist < dist then
                    target = head
                    dist = mDist
                end
            end
        end
    end
    return target
end

-- Döngü
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.Smoothing)
        end
    end
    
    if Settings.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("H_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "H_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 50)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.Enabled = true
            end
        end
    end
end)

-- Menü Aç/Kapat (Right Shift)
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        Settings.Visible = not Settings.Visible
        MainFrame.Visible = Settings.Visible
    end
end)

-- --- BUTON SİSTEMİ (TIKLAMA GARANTİLİ) ---
local function MakeButton(txt, y, func)
    local b = Instance.new("TextButton", MainFrame)
    b.Name = txt
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.BorderSizePixel = 0
    b.Text = txt
    b.TextColor3 = Color3.white
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.AutoButtonColor = true -- Tıklayınca renk değiştirir (çalıştığını anlarsın)
    
    -- UI Corner (Oval Köşeler)
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        func(b)
    end)
end

-- Butonları Ekle
MakeButton("AIMBOT: OFF", 50, function(b)
    Settings.Aimbot = not Settings.Aimbot
    b.Text = Settings.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    b.TextColor3 = Settings.Aimbot and Color3.fromRGB(0, 255, 0) or Color3.white
end)

MakeButton("ESP: OFF", 100, function(b)
    Settings.ESP = not Settings.ESP
    b.Text = Settings.ESP and "ESP: ON" or "ESP: OFF"
    b.TextColor3 = Settings.ESP and Color3.fromRGB(0, 255, 0) or Color3.white
end)

MakeButton("WALLCHECK: ON", 150, function(b)
    Settings.WallCheck = not Settings.WallCheck
    b.Text = Settings.WallCheck and "WALLCHECK: ON" or "WALLCHECK: OFF"
end)

MakeButton("GHOST JUMP", 200, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("HyperShot v5.0 Yüklendi! Kapatmak için [Right Shift]")
