local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Alert = require(E_CS.Alert)
local MessageBus = require(E_CS.Tools.MessageBus)
local Entities =  require(E_CS.Entities)
local Components = require(E_CS.Components)
local Systems =  require(E_CS.Systems)
local Outlets = require(E_CS.Outlets)
local Types = require(E_CS.Types)

Alert.Unstable("[Objects System]")

local system = Systems.new("Heartbeat", script.Name, 4)

local ModelComponent: Types.ComponentWithType<Instance> = Components.new("Model")

local ModelTrackingQueue: MessageBus.Queue<ModelQueue> = MessageBus.new("ModelTracking")
local ModelDestroyingQueue: MessageBus.Queue<ModelQueue> = MessageBus.new("ModelDestroying")
type ModelQueue = MessageBus.Queue<{ Model: Instance, Entity: Types.Entity }>

local function createModelForEntity(entity, model)
    model.Destroying:Once(
        function(): ()
            MessageBus.queue(ModelDestroyingQueue, {Entity = entity, Model = model});
        end
    )
end

Systems:on_update(system, function(world: Types.World): ()
    for _, modelData: ModelQueue in MessageBus.read(ModelDestroyingQueue) do
        local entity = modelData.Entity
        Entities:rid(entity, ModelComponent);
    end
    MessageBus.consume(ModelDestroyingQueue)

    for _, modelData: { Model: Instance, Entity: Types.Entity } in MessageBus.read(ModelTrackingQueue) do
        if modelData.Model then
            createModelForEntity(modelData.Entity, modelData.Model)
        end
    end
    MessageBus.consume(ModelTrackingQueue)
end)


return system