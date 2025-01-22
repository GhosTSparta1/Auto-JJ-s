local module = {}
local cachefunc = {}
module.__index = module

function module.new(plr)
    local self = setmetatable({}, module)
    self.Player = plr
    self.Character = (plr.Character or plr.CharacterAdded:Wait())
    cachefunc[plr] = plr.CharacterAdded:Connect(function(char)
        self.Character = char
    end)
    return self
end

function module:GetCharacter()
    return self.Character
end

function module:GetHumanoid()
    return self:GetCharacter():WaitForChild('Humanoid', 95)
end

function module:ChangeHumanoidProp(name, val)
    local Humanoid = self:GetHumanoid()
    if not Humanoid then
        warn('[CHARACTER_MODULE]: Invalid humanoid?')
        return false, 'Invalid humanoid'
    end
    local success, errorMsg = pcall(function()
        Humanoid[name] = val
    end)
    if not success then
        return false, errorMsg
    end
    return true, nil
end

function module:ChangeHumanoidState(enum: Enum)
    local Humanoid = self:GetHumanoid()
    if not Humanoid then
        warn('[CHARACTER_MODULE]: Invalid humanoid?')
        return false, 'Invalid humanoid'
    end
    local success, errorMsg = pcall(function()
        Humanoid:ChangeState(enum)
    end)
    if not success then
        return false, errorMsg
    end
    return true, nil
end

function module:ChangeWalkSpeed(val: number)
    local result, errorMsg = self:ChangeHumanoidProp('WalkSpeed', val)
    if not result then
        warn('[CHARACTER_MODULE]: Error setting "WalkSpeed":\n' .. errorMsg)
        return
    end
end

function module:Jump()
    local result, errorMsg = self:ChangeHumanoidState(Enum.HumanoidStateType.Jumping)
    if not result then
        warn('[CHARACTER_MODULE]: Error jumping character:\n' .. errorMsg)
        return
    end
end

function module:PressKey(key)
    local VirtualInputManager = game:GetService("VirtualInputManager")
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

function module:SetRotation(angle)
    local rootPart = self:GetCharacter():FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(angle), 0)
    else
        warn('[CHARACTER_MODULE]: Missing HumanoidRootPart for rotation')
    end
end

function module:Destroy()
    if cachefunc[self.Player] then
        cachefunc[self.Player]:Disconnect()
        cachefunc[self.Player] = nil
    end
    self.Player = nil
    self.Character = nil
end

return module