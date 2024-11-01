--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local E_debug = _G.E_DEBUG


return function<b>(name: string, value: b?): { Entity: Types.ComponentWithType<b>, Value: b | number | any? }
    local property = Components.new(name)
    return { Entity = property, Name = name, Value = value or Entities.NULL}
end
