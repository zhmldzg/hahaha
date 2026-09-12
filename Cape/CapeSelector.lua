-- CapeSelector.lua
-- 支持多种图案切换的披风

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local torso = character:WaitForChild("UpperTorso") or character:WaitForChild("Torso")

-- ⚠️ 把你上传的图片 Asset ID 填在这里（去掉 rbxassetid:// 前缀）
local IMAGE_IDS = {
    {name = "火焰纹", id = "123456789"},
    {name = "星空纹", id = "987654321"},
    {name = "龙鳞纹", id = "555555555"},
}

-- 创建披风
local cape = Instance.new("Part")
cape.Name = "SelectableCape"
cape.Size = Vector3.new(2, 3, 0.2)
cape.Anchored = false
cape.CanCollide = false
cape.Massless = true
cape.Color = Color3.fromRGB(255, 255, 255)
cape.Material = Enum.Material.SmoothPlastic
cape.TopSurface = Enum.SurfaceType.Smooth
cape.BottomSurface = Enum.SurfaceType.Smooth

-- 关键：给披风加一个 Texture
local texture = Instance.new("Texture")
texture.Face = Enum.NormalId.Back -- 只显示背面
texture.StudsPerTileU = 1
texture.StudsPerTileV = 1
texture.Parent = cape

-- 焊接披风到躯干
local weld = Instance.new("Weld")
weld.Part0 = torso
weld.Part1 = cape
weld.C0 = CFrame.new(0, 0, 0.6)
weld.C1 = CFrame.new(0, 1.5, 0)
weld.Parent = cape
cape.Parent = character

-- 切换图案的函数
local currentIndex = 1
local function applyCapeImage(index)
    if IMAGE_IDS[index] then
        texture.Texture = "rbxassetid://" .. IMAGE_IDS[index].id
        currentIndex = index
    end
end

applyCapeImage(1) -- 默认显示第一张

-- 创建简易选择按钮（放在屏幕左侧）
local gui = Instance.new("ScreenGui")
gui.Name = "CapePickerGui"
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 200)
frame.Position = UDim2.new(0, 20, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = frame

for i, imgData in ipairs(IMAGE_IDS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.Position = UDim2.new(0, 6, 0, 6 + (i - 1) * 46)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = imgData.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        applyCapeImage(i)
    end)
end
