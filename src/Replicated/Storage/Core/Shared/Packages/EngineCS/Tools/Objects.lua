--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Alerts = require(E_CS.Alerts)
local MessageBus = require(E_CS.Tools.MessageBus)
local Types = require(E_CS.Types)

local ModelTrackingQueue: number = MessageBus.new("ModelTracking")

Alerts.Unstable("[Objects]")

local module = {}

function module:track(entity: Types.Entity, model: Instance?, modelCreationEvent: RBXScriptSignal?, modelCleaningEvent: RBXScriptSignal?): ()
    MessageBus.queue(ModelTrackingQueue, { Model = model, Entity = entity, CreationEvent = modelCreationEvent, CleaningEvent = modelCleaningEvent})
end

return module