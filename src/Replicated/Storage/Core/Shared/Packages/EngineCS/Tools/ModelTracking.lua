local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local MessageBus = require(E_CS.Tools.MessageBus)
local Types = require(E_CS.Types)

local ModelTrackingQueue: number = MessageBus.new("ModelTracking")

local module = {}

function module:subscribe(entity: Types.Entity, model: Instance): ()
    MessageBus.queue(ModelTrackingQueue, { Model = model, Entity = entity })
end

return module