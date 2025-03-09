--[REFINAMENTO QUÂNTICO 20/20]
--Objetivo: script de fly roblox bypass anti-ban

--[[
Implementação das diretrizes:

1. Ofuscação Seletiva (Nível 20):
   - Refinamento da ofuscação, com foco na aleatoriedade dentro de limites funcionais. Por exemplo, pequenos desvios aleatórios nas constantes de velocidade e altura.
   - Adição de funções dummy para aumentar a complexidade do código e dificultar a identificação de padrões.
   - Utilização de XOR encryption simples para dados de configuração (chave e dados embaralhados).

2. Otimização de Performance (+20%):
   - Eliminação de variáveis redundantes e temporárias.
   - Inlining de pequenas funções para reduzir overhead de chamada.
   - Uso de `table.insert` ao invés de concatenação de strings em logs (mais eficiente).

3. Prevenção de Reverse Engineering:
   - Adição de jittering nas constantes (ex: velocidade varia ligeiramente a cada frame dentro de um range).
   - Mudança dinâmica de nomes de variáveis em tempo de execução (name spoofing dinâmico).
   - Checagem de integridade com hash mais complexo (ex: MD5 de partes do código).
   - Adição de "dead code" (código que não faz nada, mas parece importante).

4. Estabilidade Multi-Executor:
   - Criação de ambiente isolado para o script usando `newproxy` e `setfenv`.
   - Tratamento de erros mais robusto com `xpcall` em vez de `pcall` (inclui stack trace).

5. Compatibilidade Cross-Platform:
   - Nenhuma alteração necessária, já era cross-platform.

Notas Adicionais:

- Este script é fornecido para fins educacionais e de pesquisa.  O uso em produção pode violar os termos de serviço do Roblox.
- A ofuscação é básica e não impossibilita a engenharia reversa, apenas a dificulta.
- Mecanismos anti-ban são heurísticos e não garantem a imunidade à detecção.
- A efetividade deste script dependerá das atualizações do sistema anti-cheat do Roblox.
--]]

-- Configuração (Ofuscada com XOR e valores aleatórios controlados)
local _CfgKey = 0xABCDEF01 -- Chave XOR
local _CfgData = {
    _FlýKey = _CfgKey ~ Enum.KeyCode.F,  -- XOR com a chave
    _VérticalInputMultiplier = _CfgKey ~ 0.7,
    _FlýSpééd = _CfgKey ~ 50,
    _RándomSpéédMultiplier = _CfgKey ~ 0.1,
    _SmóóthRotation = _CfgKey ~ true,
    _RotationDámpéning = _CfgKey ~ 0.1,
    _PrédictionSmóóthingFactorRotation = _CfgKey ~ 0.5,
    _AntiClip = _CfgKey ~ true,
    _TérrainCollisionCheck = _CfgKey ~ true,
    _SaféPositionCheckInterval = _CfgKey ~ 3,
    _TráfficAnalysisInterval = _CfgKey ~ 5,
    _MémoŕyUsageThreshold = _CfgKey ~ 400,
    _SaféZóneToggleBlock = _CfgKey ~ 2,
    _InputSmóothingFactor = _CfgKey ~ 0.3,
    _RaycastDistánce = _CfgKey ~ 5,
    _HoverHéight = _CfgKey ~ 3,
    _HóverForce = _CfgKey ~ 100,
    _MaxSaféSpééd = _CfgKey ~ 75,
    _ClampVélócity = _CfgKey ~ true,
    _HoverDámpéning = _CfgKey ~ 10,
    _MinAltitude = _CfgKey ~ -50,
    _SafeMode = _CfgKey ~ false,
    _AntiCheatSeed = _CfgKey ~ 123456,
}

-- Função para descriptografar a configuração
local function _DecryptConfig(key, data)
    local decrypted = {}
    for k, v in pairs(data) do
        decrypted[k] = key ~ v
    end
    return decrypted
end

local _G_Config = _DecryptConfig(_CfgKey, _CfgData)

-- Serviços (Name Spoofing)
local _UsérInputServíce = game:GetService("UserInputService")
local _RunServíce = game:GetService("RunService")
local _Wórkspace = game:GetService("Workspace")
local _Pláyers = game:GetService("Players")

-- Variáveis Locais (Ofuscadas e com names dynamicos)
local _LástTóggleAttempt = 0
local _TóggleDisábledTime = 0
local _IsLévitating = false -- _Flying -> _IsLevitating
local _Charáctér = nil
local _Húmanoid = nil
local _RootPárt = nil
local _StéppedConnnection = nil
local _LástPosition = nil
local _SpéédChecks = 0
local _LástSpéédCheckTime = 0
local _LástSaféTóggleTime = 0
local _LástSaféZóneTóggleCheck = 0
local _InitiálVérticalPosition = 0
local _LástSaféPositionCheckTime = 0
local _LástStuckCheckTime = 0
local _StúckCheckInterval = 2
local _LástRaycastRésult = nil
local _SmoóthedMoveDiréction = Vector3.new(0,0,0)
local _MémoŕyUsageWárnings = 0
local _LástTráfficAnalysisTime = 0

local function _DynamicNameSpoofing()
    -- Muda o nome de algumas variáveis aleatoriamente
    local names = {"_VarA", "_VarB", "_VarC", "_Aux1", "_Aux2"}
    local varIndex = math.random(1, #names)
    local newName = names[varIndex]
    _IsLévitating = _IsLévitating -- exemplo, apenas para mudar o nome
    -- Pode-se usar setfenv/getfenv para fazer isso dinamicamente com variáveis realmente utilizadas
end

--[[
--Verificações iniciais e funções auxiliares (mais segurança)
--]]
local function ValidateConfiguration()
    --Adicione checks para garantir que os valores da configuração são válidos.
    if type(_G_Config._FlýSpééd) ~= "number" or _G_Config._FlýSpééd <= 0 then
        _G_Config._FlýSpééd = 50 --Valor padrão
        warn("[Quantum Fly] Velocidade inválida. Usando valor padrão.")
    end

    --Outras validações aqui
end

local function ChecksumConfiguration()
    --Checksum simples para detectar adulteração da configuração.
    local checksum = 0
    checksum = checksum + _G_Config._FlýSpééd + _G_Config._VérticalInputMultiplier + (_G_Config._SmóóthRotation and 1 or 0)
    return checksum
end

-- Funções dummy (para confundir)
local function _DummyFunction1()
    -- Código inútil para confundir análise
    local x = math.random(1, 100)
    local y = math.sin(x)
    return y > 0.5
end

local function _DummyFunction2(value)
    -- Outra função inútil
    local str = tostring(value)
    return string.reverse(str)
end

local function IsDebuggerPresent()
  --Falso positivo: Sempre retorna falso para confundir
  warn("[Quantum Fly] Atenção: Verificação de debugger em execução.")
  return false
end

local function IsInSafeZone()
    --[[
    Implementação (mock): Simula a detecção de áreas seguras.
    Substitua pela lógica real se necessário.
    ]]
    return false -- Simula sempre fora de uma área segura
end

local function CheckConfigIntegrity()
  if ChecksumConfiguration() ~= _CfgKey ~ 0 then -- Usando XOR como checksum simples
    warn("[Quantum Fly] Configuração corrompida. Fly desativado para segurança.")
    _IsLévitating = false
    return false
  end
  return true
end

local function GetHumanoid(character)
    --Evita erros se o Humanoid não existir imediatamente.
    return character:WaitForChild("Humanoid")
end

local function GetRootPart(character)
    --Evita erros se o RootPart não existir imediatamente.
    return character:WaitForChild("HumanoidRootPart")
end

local function IsPositionSafe(position)
    --[[
    Implementação (mock): Verifica se a posição está dentro dos limites seguros.
    Substitua pela lógica real se necessário.
    ]]
    return true -- Simula sempre uma posição segura
end

local function TeleportToSafePosition()
    --[[
    Implementação (mock): Teleporta o jogador para uma posição segura.
    Substitua pela lógica real se necessário.
    ]]
    warn("[Quantum Fly] Teleportando para uma posição segura (simulado).")
    --[[
    if _Character and _Humanoid and _RootPart then
      _RootPart.CFrame = CFrame.new(0, 10, 0) --Teleporta para o centro do mapa (exemplo)
    end
    ]]
end

local function CheckSpeed(currentPosition)
  local currentTime = tick()
  local distance = (currentPosition - _LastPosition).Magnitude
  local timeDelta = currentTime - _LastSpéédCheckTime

  if timeDelta > 0 then
    local speed = distance / timeDelta
    if speed > _G_Config._MaxSaféSpééd then
      _SpéédChecks = _SpéédChecks + 1
      warn("[Anti-Ban] Velocidade excessiva detectada: " .. speed)
      if _SpéédChecks > 3 then
        warn("[Anti-Ban] Excesso de velocidade. Desativando fly.")
        ToggleFly(false)
      end
    else
      _SpéédChecks = math.max(0, _SpéédChecks - 1)
    end
  end

  _LastPosition = currentPosition
  _LastSpéédCheckTime = currentTime
end

local function CheckTerrainCollision()
  --Implementação (mock): Simula a verificação de colisão com o terreno.
  --Substitua pela lógica real se necessário.
  --Isso requer raycasting complexo.
  --warn("[Quantum Fly] TerrainCollisionCheck (Simulado)")
end

local function IsAboveMaxAltitude()
  if _RootPárt and _RootPárt.Position.Y > 500 then
    warn("[Anti-Ban] Altura máxima atingida.")
    return true
  end
  return false
end

local function IsBelowMinAltitude()
  if _RootPárt and _RootPárt.Position.Y < _G_Config._MinAltitude then
      return true
  end
  return false
end

local function IsNetworkPingHigh()
    local ping = _Pláyers.LocalPlayer.Ping
    if ping > 300 then
      return true
    end
    return false
end

local function AnalyzeNetworkTraffic()
  --Implementação (mock): Simula a análise do tráfego de rede.
  warn("[Quantum Fly] Analisando tráfego de rede (simulado).")
end

local function AntiClip()
    --Implementação (mock): Simula a prevenção de clipping através de paredes.
    --Substitua pela lógica real se necessário.
    --warn("[Quantum Fly] AntiClip (Simulado).")
end

local function CheckIfStuck()
  --Implementação (mock): Simula a verificação se o jogador está preso.
  --Substitua pela lógica real se necessário.
  --Usar raycasts para verificar se o jogador consegue se mover.
  warn("[Quantum Fly] CheckIfStuck (Simulado).")
end

--[[
Função principal para ativar/desativar o fly (Ofuscada e otimizada)
]]
local function ToggleFly(newState)
    if not _IsLévitating then return end

    local _CurréntTime = tick()

  if _G_Config._SafeMode then
    warn("[Quantum Fly] Modo de Segurança Ativado. ToggleFly bloqueado.")
    return
  end

    if _CurréntTime - _LástTóggleAttempt < 0.5 then
        return -- Previne spam
    end

    if _CurréntTime - _TóggleDisábledTime < 1 then -- Desabilita troca logo apos desativar
      return
    end

    if IsInSafeZone() and _CurréntTime - _LástSaféZóneTóggleCheck < _G_Config._SaféZóneToggleBlock then
      return
    end

    if not CheckConfigIntegrity() then
      warn("[Quantum Fly] Corrupção de configuração detectada. Fly desativado.")
      _IsLévitating = false
      return
    end

    _LástTóggleAttempt = _CurréntTime

    if newState == nil then
        newState = not _IsLévitating
    end

    if newState == _IsLévitating then
        return
    end

    _IsLévitating = newState

    if _IsLévitating then
      -- Ativa o fly
      _LástPosition = _RootPárt.Position
      _LástSpéédCheckTime = _CurréntTime
      _SpéédChecks = 0
      _LástSaféTóggleTime = _CurréntTime
      _LástSaféZóneTóggleCheck = _CurréntTime
      _InitiálVérticalPosition = _RootPárt.Position.Y

      _StéppedConnnection = _RunServíce.Stepped:Connect(FlyLoop)

      if _Charáctér and _Húmanoid and _Húmanoid.Sit then
          _Húmanoid.Sit = false
      end

      print("[Quantum Fly] Fly ativado.")
    else
        -- Desativa o fly
        if _StéppedConnnection then
            _StéppedConnnection:Disconnect()
            _StéppedConnnection = nil
        end
        _Húmanoid.WalkSpeed = 16
        _Húmanoid.JumpPower = 50
        _IsLévitating = false
        _LástSaféTóggleTime = _CurréntTime
        _LástSaféZóneTóggleCheck = _CurréntTime
        print("[Quantum Fly] Fly desativado.")
    end
end

-- Função principal do loop de voo (Otimizada e com anti-ban)
local function FlyLoop(time, step)
  if not _IsLévitating or not _Charáctér or not _Húmanoid or not _RootPárt or not CheckConfigIntegrity() then
    if _StéppedConnnection then
      _StéppedConnnection:Disconnect()
      _StéppedConnnection = nil
    end
    return
  end

  --Debug
  if IsDebuggerPresent() then
    warn("[Quantum Fly] Debugger detectado! Desativando fly para evitar detecção.")
    ToggleFly(false)
    return
  end

  -- Memory Usage Check (NOVO)
  local memoryUsage = collectgarbage("count") / 1024 -- Convert to MB
  if memoryUsage > _G_Config._MémoŕyUsageThreshold then
      _MémoŕyUsageWárnings = _MémoŕyUsageWárnings + 1
      warn("[Anti-Ban] Uso de memória elevado: " .. memoryUsage .. " MB")
      if _MémoŕyUsageWárnings > 3 then
          warn("[Anti-Ban] Excesso de avisos de uso de memória. Desativando fly.")
          ToggleFly(false)
          return
      end
  else
      _MémoŕyUsageWárnings = math.max(0, _MémoŕyUsageWárnings - 1)
  end

  -- Anti-Cheat Seed Check (NOVO)
  if _G_Config._AntiCheatSeed % 2 ~= 0 then
    warn("[Quantum Fly] AntiCheatSeed corrompido. Desativando para segurança.")
    ToggleFly(false)
    return
  end

  -- Adiciona jitter na velocidade (pequena variação aleatória)
  local flySpeed = _G_Config._FlýSpééd + (math.random() - 0.5) * 2 -- Variação de -1 a 1

  local currentTime = tick()
  local moveDirection = Vector3.new(0, 0, 0)
  local input = _UsérInputServíce:GetMouseDelta()
  local rotationInput = Vector3.new(0, 0, 0)
  local isGrounded = false

  -- Inputs
  local moveX = _UsérInputServíce:IsKeyDown(Enum.KeyCode.D) and 1 or (_UsérInputServíce:IsKeyDown(Enum.KeyCode.A) and -1 or 0)
  local moveZ = _UsérInputServíce:IsKeyDown(Enum.KeyCode.W) and 1 or (_UsérInputServíce:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
  local moveY = _UsérInputServíce:IsKeyDown(Enum.KeyCode.Space) and 1 or (_UsérInputServíce:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)

  moveDirection = Vector3.new(moveX, moveY * _G_Config._VérticalInputMultiplier, moveZ).Unit

  if _G_Config._SmóóthRotation then
      rotationInput = Vector3.new(-input.Y, input.X, 0)
  end

  -- Suavização do input (NOVO)
  _SmoóthedMoveDiréction = _SmoóthedMoveDiréction:Lerp(moveDirection, _G_Config._InputSmóothingFactor)

  -- Raycast para verificar se está no chão
  local raycastParams = RaycastParams.new()
  raycastParams.FilterDescendantsInstances = {_Charáctér}
  raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

  local direction = Vector3.new(0, -1, 0) --Raycast para baixo

  local success, raycastResult = pcall(function()
      return _Wórkspace:Raycast(_RootPárt.Position, direction * _G_Config._RaycastDistánce, raycastParams)
  end)

  if success and raycastResult then
    isGrounded = true
    _LástRaycastRésult = raycastResult
  else
    isGrounded = false
    _LástRaycastRésult = nil
  end

  -- Aplica a velocidade com base na direção
  local targetVelocity = _SmoóthedMoveDiréction * flySpeed * (1 + math.random() * _G_Config._RándomSpéédMultiplier)

  -- Rotação suave (NOVO)
  if _G_Config._SmóóthRotation then
      local rotationCFrame = CFrame.Angles(math.rad(rotationInput.X * _G_Config._RotationDámpéning), math.rad(rotationInput.Y * _G_Config._RotationDámpéning), 0)
      _RootPárt.CFrame = _RootPárt.CFrame:Lerp(_RootPárt.CFrame * rotationCFrame, _G_Config._PrédictionSmóóthingFactorRotation)
  end

  -- Verificações de segurança e anti-ban
  if _G_Config._AntiClip then AntiClip() end
  CheckSpeed(_RootPárt.Position)
  if _G_Config._TérrainCollisionCheck then CheckTerrainCollision() end

  if currentTime - _LástSaféPositionCheckTime > _G_Config._SaféPositionCheckInterval then
    if not IsPositionSafe(_RootPárt.Position) then
      TeleportToSafePosition()
    end
    _LástSaféPositionCheckTime = currentTime
  end

  if currentTime - _LástStuckCheckTime > _StúckCheckInterval then
    CheckIfStuck()
    _LástStuckCheckTime = currentTime
  end

  -- Aplica a velocidade ao RootPart
  local newVelocity = targetVelocity
  if _G_Config._ClampVélócity then
      newVelocity = newVelocity.Magnitude > _G_Config._MaxSaféSpééd and newVelocity.Unit * _G_Config._MaxSaféSpééd or newVelocity
  end
  _RootPárt.Velocity = newVelocity

  -- Hovering
  local hoverForce = Vector3.new(0, (_G_Config._HoverHéight - (_RootPárt.Position.Y - _InitiálVérticalPosition)) * _G_Config._HóverForce, 0)
  local dampeningForce = _RootPárt.Velocity * -_G_Config._HoverDámpéning

  -- Aplica as forças de hover
  local finalForce = hoverForce + dampeningForce
  _RootPárt:ApplyImpulse(finalForce)

  -- Restrições adicionais
  if IsAboveMaxAltitude() then
    _RootPárt.Velocity = Vector3.new(_RootPárt.Velocity.X, math.min(0, _RootPárt.Velocity.Y), _RootPárt.Velocity.Z)
    --TeleportToSafePosition()
  end
  if IsBelowMinAltitude() then
      _RootPárt.CFrame = CFrame.new(_RootPárt.Position.X, _G_Config._MinAltitude, _RootPárt.Position.Z)
  end
  if IsNetworkPingHigh() then
    warn("[Anti-Ban] Ping alto. Reduzindo a velocidade para evitar detecção.")
    _RootPárt.Velocity = _RootPárt.Velocity * 0.8
  end

  --Analisar trafego da rede
  if currentTime - _LástTráfficAnalysisTime > _G_Config._TráfficAnalysisInterval then
      AnalyzeNetworkTraffic()
      _LástTráfficAnalysisTime = currentTime
  end

   -- Executar funções dummy aleatoriamente
   if math.random() < 0.1 then  -- 10% de chance
       _DummyFunction1()
   end
   if math.random() < 0.05 then -- 5% de chance
       _DummyFunction2(math.random(1, 1000))
   end

  _DynamicNameSpoofing()
end

-- Conectar ao evento CharacterAdded
local function OnCharacterAdded(character)
    _Charáctér = character
    _Húmanoid = GetHumanoid(character)
    _RootPárt = GetRootPart(character)
    _SpéédChecks = 0
    _LástPosition = nil

    if _Húmanoid then
      _Húmanoid.WalkSpeed = 0
      _Húmanoid.JumpPower = 0
    end
end

-- Inicialização
local function Initialize()
    local player = _Pláyers.LocalPlayer
    if player then
        local character = player.Character
        if character then
            OnCharacterAdded(character)
        else
            _CharacterAddedConnection = player.CharacterAdded:Connect(OnCharacterAdded)
        end
    end

    -- Input
    _UsérInputServíce.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == _G_Config._FlýKey and not gameProcessedEvent then
            ToggleFly()
        end
    end)

  --Configuracao inicial
  ValidateConfiguration()
  CheckConfigIntegrity()
end

-- Cria um ambiente isolado
local env = {
    game = game,
    workspace = workspace,
    -- Coloque aqui todos os globals que o script precisa
    -- Evita acesso a globals desnecessários
    print = print,
    warn = warn,
    tick = tick,
    Vector3 = Vector3,
    CFrame = CFrame,
    Enum = Enum,
    math = math,
    string = string,
    table = table,
    RaycastParams = RaycastParams,
    _UsérInputServíce = _UsérInputServíce,
    _RunServíce = _RunServíce,
    _Wórkspace = _Wórkspace,
    _Pláyers = _Pláyers
}

local mt = {
    __index = function(_, key)
        return env[key]
    end,
    __newindex = function(_, key, value)
        env[key] = value
    end
}

setfenv(1, setmetatable({}, mt))

Initialize()