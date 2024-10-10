--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local system = Systems.new("Heartbeat", script.Name, math.huge)

local EntityChangesQueue = MessageBus.new("EntityChanges")

local componentsMap: { [string]: Types.Component } = {}

Systems:on_update(system, function(world: Types.World)
    for _: number, entityChanges in pairs(MessageBus.read(EntityChangesQueue) or {}) do
        local entity: Types.Entity = entityChanges["Entity"]
        local componentsByNameAndChangedValue = entityChanges["Components"]
        
        local components = {}
        for component: string, changedValues: any in componentsByNameAndChangedValue do
            if changedValues == "DELETE" then
                Entities:rid(entity, componentsMap[component])

                continue
            end
            
            if componentsMap[component] then
                components[componentsMap[component]] = changedValues
            else
                componentsMap[component] = Components.new(component) --locate assumingly already made component, or create it.
            end
        end

        Entities:give(entity, components)
    end

    MessageBus.consume(EntityChangesQueue) -- clear the queue.
end)


return system