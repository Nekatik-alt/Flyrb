local function LoadLibrary(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return success and result or nil
end

local Rayfield = LoadLibrary('https://raw.githubusercontent.com/shlexware/Rayfield/release/source')
local Window = Rayfield:CreateWindow({
    Name = "EAS-∞ Flight System",
    LoadingTitle = "Завантаження...",
    LoadingSubtitle = "Система керування польотом",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EAS-Config",
        FileName = "FlightSystem"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local FlyTab = Window:CreateTab("Польот", 4483362458)
local FlySection = FlyTab:CreateSection("Управління польотом")

local Toggle = FlyTab:CreateToggle({
    Name = "Активувати політ",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        _G.FlyEnabled = Value
        if Value then
            EnableFly()
        else
            DisableFly()
        end
    end
})

local SpeedSlider = FlyTab:CreateSlider({
    Name = "Швидкість польоту",
    Range = {1, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 25,
    Flag = "FlySpeed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end
})

function EnableFly()
    local Player = game:GetService("Players").LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if not Humanoid then return end
    
    _G.FlyBodyVelocity = Instance.new("BodyVelocity")
    _G.FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    _G.FlyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    _G.FlyBodyVelocity.Parent = Character:FindFirstChild("HumanoidRootPart")
    
    _G.FlyAnim = Instance.new("Animation")
    _G.FlyAnim.AnimationId = "rbxassetid://3541044388"
    _G.FlyAnimationTrack = Humanoid:LoadAnimation(_G.FlyAnim)
    _G.FlyAnimationTrack:Play()
    
    spawn(function()
        while _G.FlyEnabled do
            wait()
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                _G.FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                local Camera = workspace.CurrentCamera
                local RootPart = Character.HumanoidRootPart
                
                local XVelocity = 0
                local YVelocity = 0
                local ZVelocity = 0
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    ZVelocity = _G.FlySpeed
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    ZVelocity = -_G.FlySpeed
                end
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    XVelocity = -_G.FlySpeed
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    XVelocity = _G.FlySpeed
                end
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    YVelocity = _G.FlySpeed
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    YVelocity = -_G.FlySpeed
                end
                
                local LookVector = Camera.CFrame.LookVector
                local RightVector = Camera.CFrame.RightVector
                
                _G.FlyBodyVelocity.Velocity = (LookVector * ZVelocity) + (RightVector * XVelocity) + Vector3.new(0, YVelocity, 0)
            end
        end
    end)
end

function DisableFly()
    if _G.FlyBodyVelocity then
        _G.FlyBodyVelocity:Destroy()
        _G.FlyBodyVelocity = nil
    end
    
    if _G.FlyAnimationTrack then
        _G.FlyAnimationTrack:Stop()
        _G.FlyAnimationTrack = nil
    end
    
    if _G.FlyAnim then
        _G.FlyAnim:Destroy()
        _G.FlyAnim = nil
    end
end

local BypassTab = Window:CreateTab("Обхід захисту", 4483362458)
local BypassSection = BypassTab:CreateSection("Методи обходу")

BypassTab:CreateButton({
    Name = "Активувати маскування",
    Callback = function()
        pcall(function()
            hookfunction = hookfunction or detour_function
            if hookfunction then
                local oldNamecall
                oldNamecall = hookfunction(metamethod.__namecall, function(...)
                    local method = getnamecallmethod()
                    if tostring(method) == "Kick" then
                        return nil
                    end
                    return oldNamecall(...)
                end)
            end
        end)
    end
})

BypassTab:CreateButton({
    Name = "Приховати процеси",
    Callback = function()
        pcall(function()
            for i,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
                v:Disable()
            end
        end)
    end
})

local AnimationTab = Window:CreateTab("Анімації", 4483362458)
local AnimationSection = AnimationTab:CreateSection("Додаткові анімації")

local Animations = {
    {Name = "Ефект крил", ID = 3541044388},
    {Name = "Енергетичне поле", ID = 4567654567},
    {Name = "Швидкісний режим", ID = 5678765678},
    {Name = "Телепортація", ID = 6789876789},
    {Name = "Захисний щит", ID = 7890987890},
    {Name = "Ефект прискорення", ID = 8901098901},
    {Name = "Стабілізація", ID = 9012109012},
    {Name = "Маскувальне поле", ID = 1234212345},
    {Name = "Імпульсний двигун", ID = 2345323456},
    {Name = "Антигравітація", ID = 3456434567}
}

for _, anim in pairs(Animations) do
    AnimationTab:CreateButton({
        Name = anim.Name,
        Callback = function()
            local Player = game:GetService("Players").LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            
            if Humanoid then
                local NewAnimation = Instance.new("Animation")
                NewAnimation.AnimationId = "rbxassetid://" .. anim.ID
                local AnimationTrack = Humanoid:LoadAnimation(NewAnimation)
                AnimationTrack:Play()
            end
        end
    })
end

Rayfield:LoadConfiguration()
