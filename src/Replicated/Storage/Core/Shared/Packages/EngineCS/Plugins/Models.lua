--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local Entities =  require(E_CS.Entities)
local Components = require(E_CS.Components)
local Systems =  require(E_CS.Systems)
local Outlets = require(E_CS.Outlets)
local Types = require(E_CS.Types)

local system = Systems.new("Heartbeat", script.Name, 4)

local ModelComponent: Types.ComponentWithType<Instance> = Components.new("Model")

local ModelTrackingQueue: number = MessageBus.new("ModelTracking")
local ModelDestroyingQueue: number = MessageBus.new("ModelDestroying")

local function createModelForEntity(entity, model)
    model.Destroying:Once(
        function(): ()
            MessageBus.queue(ModelDestroyingQueue, {Entity = entity, Model = model});
        end
    )
end

Systems:on_update(system, function(world: Types.World): ()
    for _, modelData: { Model: Instance, Entity: Types.Entity } in MessageBus.read(ModelDestroyingQueue) do
        Entities:rid(modelData.Entity, ModelComponent);
    end
    -- MessageBus.consume(ModelDestroyingQueue)
    for _, modelData: { Model: Instance, Entity: Types.Entity } in MessageBus.read(ModelTrackingQueue) do
        if modelData.Model then
            createModelForEntity(modelData.Entity, modelData.Model)
        end
    end
    MessageBus.consume(ModelTrackingQueue)
end)


return system