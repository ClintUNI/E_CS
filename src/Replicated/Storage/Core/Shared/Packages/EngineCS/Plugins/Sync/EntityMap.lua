--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

--client side

local module = {}

local entityByServerEntityId: { [Types.Entity]: number } = {}

function module:Add(entity: Types.Entity, mapTo: number): ()
    entityByServerEntityId[entity] = mapTo
end

function module:Remove(entity: Types.Entity): ()
    entityByServerEntityId[entity] = nil
end

return module