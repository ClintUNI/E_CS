--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)


return function(name: string): { Entity: Types.Tag, Value: nil }
    local field = Entities.tag(name)
    if not Entities:has(field, ECS.Name) then
        Entities:give(field, {[ECS.Name] = name})
    end
    return { Entity = field, Name = name }
end