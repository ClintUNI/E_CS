--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

return function<b>(name: string, value: b?): { Entity: Types.ComponentWithType<b>, Value: b | number | any? }
    local property = Components.new(name)
    return { Entity = property, Name = name, Value = value or Entities.NULL}
end
