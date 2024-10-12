--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(script.Parent.Settings)
local JECS = require(ReplicatedStorage.Core.Shared.Packages.JECS)

local module = {}
local totalSystems: number = 0
local totalSystemsPerEvent = {
    Heartbeat = 0,
    RenderStepped = 0
}

type Events = "Heartbeat" | "RenderStepped"

export type SystemBase = {
    Name: string,
    Priority: number,
    Event: Events,

    Update: (JECS.World) -> ()?
}

function module.new(event: Events, name: string, Priority: number, clientOnly: boolean?): SystemBase
    assert(not clientOnly or not Settings.Game.IsServer, name .. " can only run on the client.")
    totalSystems += 1
    totalSystemsPerEvent[event] += 1
    return {
        Name = name,
        Priority = Priority,
        Event = event,
    }
end

function module:on_update(system: SystemBase, callback: (JECS.World) -> ()): SystemBase
    system.Update = callback

    return system
end

function module:get_number_of_systems(event: Events?): number
    return totalSystemsPerEvent[event] or totalSystems
end


return module