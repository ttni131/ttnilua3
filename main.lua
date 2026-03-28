-- HyperShot Projesi - Eğitsel Amaçlıdır
local Library = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Menü Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HyperShot_Menu"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Siyah
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(120, 0, 255) -- Mor Neon
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "HYPERSHOT v1.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 150) -- Neon Yeşil
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.Parent = MainFrame

-- Fonksiyon Değişkenleri
local Toggles = {Aimbot = false, ESP = false, Fly = false}

-- --- ÖZELLİKLER ---

-- 1. Fly & Jump Mantığı
local function HandleMovement()
    if Toggles.Fly then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        -- Basit bir BodyVelocity veya CFrame manipülasyonu eklenebilir
    end
end

-- 2. ESP (İsim Etiketleri)
local function CreateESP(player)
    local bgui = Instance.new("BillboardGui", player.Character:WaitForChild("Head"))
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.Adornee = player.Character.Head
    bgui.AlwaysOnTop = true
    
    local nameTag = Instance.new("TextLabel", bgui)
    nameTag.Size = UDim2.new(1, 0, 1, 0)
    nameTag.BackgroundTransparency = 1
    nameTag.TextColor3 = Color3.fromRGB(255, 0, 0)
    nameTag.Text = player.Name
end

-- --- BUTONLAR ---
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(callback)
end

CreateButton("Aimbot: OFF", 60, function() Toggles.Aimbot = not Toggles.Aimbot print("Aimbot durumu: "..tostring(Toggles.Aimbot)) end)
CreateButton("ESP: OFF", 110, function() Toggles.ESP = not Toggles.ESP end)
CreateButton("Fly: OFF", 160, function() Toggles.Fly = not Toggles.Fly end)
CreateButton("Super Jump", 210, function() LocalPlayer.Character.Humanoid.JumpPower = 100 end)

print("HyperShot başarıyla yüklendi!")
