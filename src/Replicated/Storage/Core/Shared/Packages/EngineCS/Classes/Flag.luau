--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)


return function(name: string): { Entity: Types.Tag, Value: "Tag"}
    local flagName = "FF" .. name
    local field = Entities.tag(flagName)
    return { Entity = field, Name = name, Value = "Tag" }
end