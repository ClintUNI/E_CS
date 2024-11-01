local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local isServer = Settings.Game.IsServer

local function secure(any: any)
    if isServer then
        return any
    else
        return {}
    end
end


return secure