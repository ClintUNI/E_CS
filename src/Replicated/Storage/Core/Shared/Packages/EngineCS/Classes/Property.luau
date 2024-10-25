--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)


return function<a, b>(name: string, value: b?): { Component: Types.ComponentWithType<b>, Value: b | number }
    local property = Components.new(name)
    if not Entities:has(property, ECS.Name) then
        Entities:give(property, {[ECS.Name] = name})
    end
    return { Component = property, Value = value or Entities.NULL}
end
