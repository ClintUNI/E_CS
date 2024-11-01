--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Alert = require(E_CS.Alert)
local MessageBus = require(E_CS.Tools.MessageBus)
local Types = require(E_CS.Types)

local ModelTrackingQueue: number = MessageBus.new("ModelTracking")

Alert.Unstable("[Objects]")

local module = {}

function module:track(entity: Types.Entity, model: Instance?, modelCreationEvent: RBXScriptSignal?, modelCleaningEvent: RBXScriptSignal?): ()
    MessageBus.queue(ModelTrackingQueue, { Model = model, Entity = entity, CreationEvent = modelCreationEvent, CleaningEvent = modelCleaningEvent})
end

return module