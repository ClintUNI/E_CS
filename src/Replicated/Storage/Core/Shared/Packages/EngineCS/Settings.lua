--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

type Settings = {
    Game: {
        IsServer: boolean
    },

    Config: {
        SpawnCFrame: CFrame,
        VoidCFrame: CFrame
    },

    Plugins: {
        Wait: boolean?,
        Players: boolean?,
        Characters: boolean?,
        Sync: boolean?,
        Network: boolean?,
        Hooks: boolean?,
        Models: boolean?,
        Changes: boolean?
    }
}

local settings = {
    Game = {
        IsServer = game:GetService("RunService"):IsServer(),
    },

    Config = {
        SpawnCFrame = CFrame.new(0, 30, 0),
        VoidCFrame = CFrame.new(math.huge, 0, 0)
    },

    Plugins = {
        DeltaTime = true,
        Players = true,
        Characters = true,
        Sync = false,
        Network = false,
        Hooks = true,
        Objects = true,

        Changes = false
    },

} :: Settings

--[[Use Bootloaders to build settings, !or! manually edit them above.]]
return settings