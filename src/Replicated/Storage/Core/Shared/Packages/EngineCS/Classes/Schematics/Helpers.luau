local ReplicatedStorage = game:GetService("ReplicatedStorage")

local __Types = require(script.Parent.__Types)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Worlds = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Worlds)
local helpers = {}

function helpers.parseClassSchematic(classSchematic: __Types.ClassSchematics): { [Types.Entity | Types.Component | Types.Tag]: any }
    local tagsAndComponents = {}

    for _, value in classSchematic do
        if value.Entity then
            tagsAndComponents[value.Entity] = value.Value
        end
    end

    return tagsAndComponents
end

function helpers.parseAndGiveProps(entity: Types.Entity, props: { [string | number]: any })
    local world: Types.World = Worlds.World

    for key, value in props do 
        if value == Entities.NULL then
            world:add(entity, if typeof(key) == "string" then Entities.tag(key) else key)
        else
            world:set(entity, if typeof(key) == "string" then Components.new(key) else key, value)
        end
    end
end

return helpers