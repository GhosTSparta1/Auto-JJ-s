local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variáveis de estado
local aimbotEnabled = false
local fireMode = "none" -- "auto", "hold", "none"
local teamCheckEnabled = true

-- Criando GUI
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "OFF"
toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)

local autoFireButton = Instance.new("TextButton", mainFrame)
autoFireButton.Size = UDim2.new(0, 180, 0, 30)
autoFireButton.Position = UDim2.new(0, 10, 0, 60)
autoFireButton.Text = "Auto Fire: OFF"

local holdFireButton = Instance.new("TextButton", mainFrame)
holdFireButton.Size = UDim2.new(0, 180, 0, 30)
holdFireButton.Position = UDim2.new(0, 10, 0, 95)
holdFireButton.Text = "Hold Fire: OFF"

local teamCheckButton = Instance.new("TextButton", mainFrame)
teamCheckButton.Size = UDim2.new(0, 180, 0, 30)
teamCheckButton.Position = UDim2.new(0, 10, 0, 130)
teamCheckButton.Text = "Team Check: ON"

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"

local miniButton = Instance.new("TextButton", screenGui)
miniButton.Size = UDim2.new(0, 50, 0, 50)
miniButton.Position = UDim2.new(0, 50, 0, 50)
miniButton.Text = "☰"
miniButton.Visible = false

-- Função para alternar o aimbot
toggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    toggleButton.Text = aimbotEnabled and "ON" or "OFF"
    toggleButton.BackgroundColor3 = aimbotEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
end)

-- Alternar modo de disparo automático
autoFireButton.MouseButton1Click:Connect(function()
    fireMode = fireMode == "auto" and "none" or "auto"
    autoFireButton.Text = "Auto Fire: " .. (fireMode == "auto" and "ON" or "OFF")
    holdFireButton.Text = "Hold Fire: OFF"
end)

-- Alternar modo de disparo contínuo
holdFireButton.MouseButton1Click:Connect(function()
    fireMode = fireMode == "hold" and "none" or "hold"
    holdFireButton.Text = "Hold Fire: " .. (fireMode == "hold" and "ON" or "OFF")
    autoFireButton.Text = "Auto Fire: OFF"
end)

-- Alternar verificação de times
teamCheckButton.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    teamCheckButton.Text = "Team Check: " .. (teamCheckEnabled and "ON" or "OFF")
end)

-- Fechar o menu
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniButton.Visible = true
end)

-- Reabrir o menu
miniButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniButton.Visible = false
end)

-- Função para encontrar o jogador mais próximo e sem obstáculos
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Checa se o jogador é do mesmo time
            if teamCheckEnabled and player.Team == LocalPlayer.Team then
                continue
            end

            local targetPosition = player.Character.HumanoidRootPart.Position
            local distance = (Camera.CFrame.Position - targetPosition).Magnitude
            
            -- Checar se há obstáculos entre o jogador e o alvo
            local ray = Ray.new(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).unit * distance)
            local hit, _ = workspace:FindPartOnRay(ray, LocalPlayer.Character)

            if not hit or hit:IsDescendantOf(player.Character) then
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

-- Função para desenhar o ESP do jogador
local function drawESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local esp = player.Character:FindFirstChild("ESP")
    if not esp then
        esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.Parent = player.Character
        esp.Adornee = player.Character.HumanoidRootPart
        esp.Size = UDim2.new(0, 200, 0, 50)
        esp.StudsOffset = Vector3.new(0, 2, 0)

        local label = Instance.new("TextLabel", esp)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = player.TeamColor.Color
        label.Text = player.Name
        label.TextScaled = true
    end
end

-- Loop para mover a mira automaticamente
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getNearestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            local root = target.Character:FindFirstChild("HumanoidRootPart")

            if head and root then
                local targetPosition = (target.Character.Humanoid.MoveDirection.Magnitude > 0) and root.Position or head.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
                
                -- Disparo automático
                if fireMode == "auto" then
                    mouse1click()
                elseif fireMode == "hold" then
                    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        mouse1press()
                    end
                else
                    mouse1release()
                end
            end
        end
    end
end)

-- Desenhar ESP para todos os jogadores
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            drawESP(player)
        end
    end
end)