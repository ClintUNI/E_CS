--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)


return { 
    Emotions = {
        Bored = Components.new("Bored"),
    },
    Actions = {
        Idle = Components.new("Idle")
    },
    StatusEffects = {
        Normal = Components.new("Normal")
    }
}