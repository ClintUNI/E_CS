--!strict
type Settings = {
    Game: {
        IsServer: boolean
    },

    Plugins: {
        Wait: boolean?,
        Players: boolean?,
        Characters: boolean?,
        Sync: boolean?,
        Network: boolean?,
        Hooks: boolean?,
        Models: boolean?,
    }
}

local settings = {
    Game = {
        IsServer = game:GetService("RunService"):IsServer(),
    },

    Plugins = {
        Wait = true,
        Players = true,
        Characters = true,
        Sync = false,
        Network = false,
        Hooks = true,
        Models = true,

        Changes = true
    },

} :: Settings

--[[Use Bootloaders to build settings, !or! manually edit them above.]]
return settings