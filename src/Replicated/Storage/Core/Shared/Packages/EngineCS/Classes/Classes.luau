local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

--This is meant to be used by those who enjoy stronger OOP but running in ECS.

local classes = {}

type ClassId = number

type Class = { [string]: any }

type ClassScript = {
    [number]: Types.Tag | { [string]: Types.Component }
}

local currentClass = 0

local create = function(constructor: <T>(class: T) -> (Types.Entity), class: ClassScript): ClassId
    table.insert(classes, { __constructor = constructor :: <T>(class: T) -> (Types.Entity), __classScript = class, __inherits = {}})
    currentClass = #classes
    return #classes
end

local parse = function(class: Class): ClassScript
    local classCommands = {}
    for key, value in class do
        if typeof(key) == "table" then
            classCommands[key.Component] = key.Value
        else
            classCommands[value] = Entities.NULL
        end
    end

    return classCommands
end

local inherits = function(entity, classScripts: { ClassScript })
    for _, v: ClassScript in classScripts do
        Entities:give(entity, parse(v))
    end
end

local new = function(class: ClassId): Types.Entity?
    if classes[class] then
        local newEntity = classes[class].__constructor(classes[class].__classScript)

        for _, iClass in classes[class].__inherits do
            local classScript = classes[iClass].__classScript
            Entities:give(newEntity, parse(classScript))
        end

        return newEntity
    else
        return nil
    end
end

local set = function<a, b, c>(entity:Types. Entity, fieldOrPropertyName: string, value: c?)
    if value then
        local property = Components.get(fieldOrPropertyName)
        Entities:give(entity, {[property] = value})
    else
        local field = Entities.tag(fieldOrPropertyName)
        Entities:give(entity, {[field] = Entities.NULL})
    end
end

local from = function(classList: { ClassId })
    classes[currentClass].__inherits = classList
end

local function getClass()
    return currentClass
end

return {
    Create = create,
    New = new,
    Set = set,
    Parse = parse,
    From = from,
    Inherits = inherits,
    Class = getClass
}
