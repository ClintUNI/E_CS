--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local system = Systems.new("Heartbeat", script.Name, 1)

local WaitComponent: Types.ComponentWithType<number> = Components.new(script.Name)

local os: typeof(os) = os

local deltaTime = os.clock()
local deltaTimeDifference = 0

Systems:on_update(system, function(world: Types.World)
    local currentTime = os.clock()
    deltaTimeDifference = currentTime - deltaTime
    deltaTime = currentTime

    for entity: Types.Entity, amountToWait: number in world:query(WaitComponent):iter() do
        local newTimeToWait: number = amountToWait - deltaTimeDifference
        Entities:give(entity, {
            [WaitComponent] = if newTimeToWait > 0 then newTimeToWait else 0
        })

        if newTimeToWait <= 0 then
            Entities:rid(entity, WaitComponent)
        end
    end
end)


return system