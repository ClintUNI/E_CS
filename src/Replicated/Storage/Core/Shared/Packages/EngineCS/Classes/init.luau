local ReplicatedStorage = game:GetService("ReplicatedStorage")

local __ClassList = require(script.__ClassList)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Worlds = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Worlds)

--This is meant to be used by those who enjoy stronger OOP but running in ECS.

local classes = {}

type ClassId = number

type Class = { [string]: any }

type ClassScript<B = any> = {
    [number]: { ["Entity"]: Types.Component | Types.ComponentWithType<B> | Types.Tag, Name: string, ["Value"]: B | number | any?, FF: boolean? }
}

local currentClass: ClassId = 0

local create = function(constructor: <T, D>(classId: number, class: T, inheritance: D) -> (Types.Entity), class: ClassScript): ClassId
    currentClass = #classes + 1
    table.insert(classes, { __constructor = constructor :: <T, D>(classId: number, class: T, Inheritance: D) -> (Types.Entity), __inherits = {}, __name = nil})
    
    __ClassList:SaveClass(currentClass, class)

    for _, value in class do
        if value.Value then
            __ClassList:SaveProperty(currentClass, value.Entity, value.Name, value.Value)
        elseif value.FF then
            __ClassList:SaveFlag(currentClass, value.Entity, value.Name)
        else
            __ClassList:SaveField(currentClass, value.Entity, value.Name)
        end
    end

    return currentClass
end

local parse = function(class: Class): ClassScript
    local classCommands = {}
    for key, value in class do
        if typeof(key) == "table" then
            classCommands[key.Entity] = key.Value or Entities.NULL
        end
    end

    return classCommands
end

local inherits = function(entity, classScripts: { ClassScript })
    for _, v: ClassScript in classScripts do
        Entities:give(entity, parse(v))
    end
end

--[[
    Inherits classes *BEFORE* or *AFTER* the creation of the entity and its lowest most hierarchy class. \
    This functionality can be controlled through to class' constructor.
]]
local new = function(class: ClassId): Types.Entity
    assert(classes[class] ~= nil, "Cannot create from a class that does not exist.")

    local inheritanceList = {}

    for _, iClass in classes[class].__inherits, -1 do
        local classScript = __ClassList:GetClassGiveCommands(iClass)
        inheritanceList = { table.unpack(inheritanceList), table.unpack(classScript) }
    end

    local newEntity = classes[class].__constructor(class, __ClassList:GetClassGiveCommands(class), inheritanceList)
    Entities:give(newEntity, {[Entities.tag(classes[class].__name)] = Entities.NULL})

    table.insert(__ClassList.ClassesList[class].Entities, newEntity)

    return newEntity
end

local identify = function(class: ClassId): string
    local classData = classes[class]
    assert(classData ~= nil, "Cannot identify a class that does not exist.")
    return classData.__name
end

local currentEntity;

local is = function(class: ClassId): boolean
    return Worlds.World:has(currentEntity, Entities.tag(classes[class].__name)) and true or false
end

local entity = function(classEntity: Types.Entity?): Types.Entity?
    if classEntity then
        currentEntity = classEntity
        return
    else
        return currentEntity
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

local function getClass(name: string): ClassId
    classes[currentClass].__name = name
    return currentClass
end

return {
    Create = create,
    New = new,
    Set = set,
    Parse = parse,
    From = from,
    Inherits = inherits,
    Class = getClass,
    Entity = entity,
    Is = is,
    Identify = identify
}
