local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(script.Parent.Settings)
local __ClassList = require(script.__ClassList)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Worlds = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Worlds)

local debugMode = _G.E_DEBUG

--This is meant to be used by those who enjoy stronger OOP but running in ECS.

local classes = {}

type ClassId = number

type Class = { [string]: any }

type ClassScript<B = any> = {
    [number]: { ["Entity"]: Types.Component | Types.ComponentWithType<B> | Types.Tag, Name: string, ["Value"]: B | any?, FF: boolean? }
}

type ClassSuper = (Types.Entity, { ClassId }) -> ()

type ClassConstructor = <T, D, P>(classId: number, class: T, inheritance: D?) -> (Types.Entity)

local currentClass: ClassId = 0

local create = function(constructor: ClassConstructor, class): ClassId
    currentClass = #classes + 1
    table.insert(classes, { __constructor = constructor :: ClassConstructor, __inherits = {}, __name = nil})
    
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

local cachedProps = {}

local popProps = function(classId: ClassId)
    cachedProps[tostring(classId)] = nil
end

type props = ((ClassId) -> ({[string]: any})) | ((ClassId, {[string]: any}) -> ())
local props: props = function(classId: ClassId, propList: {[string]: any}?)
    if propList then
        cachedProps[tostring(classId)] = propList
        return
    end
    return cachedProps[tostring(classId)]
end

local inherits = function(entity, classScripts: { ClassScript })
    for _, v: ClassScript in classScripts do
        Entities:give(entity, parse(v))
    end
end

local identify = function(class: ClassId): string
    local classData = classes[class]
    assert(classData ~= nil, "Cannot identify a class that does not exist.")
    return classData.__name
end

local currentEntity;

local function super<A, D>(inherits: { ClassId })
    local inheritanceList: { [Types.Entity]: any } = {}

    for _, iClass in inherits, -1 do
        local classGiveCommands = __ClassList:GetClassGiveCommands(iClass)
        for entity, value in classGiveCommands do
            inheritanceList[currentEntity] = value
        end
    end

    Entities:give(currentEntity, inheritanceList)
end

--[[
    Calls the constructor for a given class and returns a newly constructed entity of that class.
]]
local new = function(class: ClassId): Types.Entity
    assert(classes[class] ~= nil, "Cannot create from a class that does not exist.")

    if debugMode then
        warn("Creating entity with class", identify(class))
    end

    local newEntity = classes[class].__constructor(class, __ClassList:GetClassGiveCommands(class), classes[class].__inherits)
    popProps(class)
    table.insert(__ClassList.ClassesList[class].Entities, newEntity)

    return newEntity
end

local with = function(newPropertyValues: { [string | Types.Entity]: any })
    local componentValueDictionary = {}
    for key, value in newPropertyValues do
        if typeof(key) == "string" then
            componentValueDictionary[Components.new(key)] = value
        else
            componentValueDictionary[key] = value
        end
    end

    Entities:give(currentEntity, componentValueDictionary)
end

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
    local inheritancesAndTheirInheritances = {}
    for _, classId in classList do
        local inheritClassIds = classes[classId].__inherits
        for _, inheritancesInheritedClassId in inheritClassIds do
            table.insert(inheritancesAndTheirInheritances, inheritancesInheritedClassId)
        end
        table.insert(inheritancesAndTheirInheritances, classId)
    end
    classes[currentClass].__inherits = classList
end

local isServer = Settings.Game.IsServer

local secure = function<a>(any: a): a?
    if isServer then
        return any
    else
        return nil
    end
end

local function getClassIdAndSetName(name: string): ClassId
    classes[currentClass].__name = name
    return currentClass
end

local function getClassIdFromName(name: string): ClassId
    for classId, class in classes do
        if class.__name == name then
           return classId 
        end
    end

    error("Cannot get a class that doesn't exist for class: " .. name)
end

return {
    Create = create,
    New = new,
    Set = set,
    Parse = parse,
    From = from,
    Inherits = inherits,
    As = getClassIdAndSetName,
    Class = getClassIdFromName,
    Entity = entity,
    Is = is,
    Identify = identify,
    Super = super,
    With = with,
    Props = props,
    Secure = secure,

    
    PropertyGet = Components.new,

    FieldGet = Entities.tag,

    FlagGet = Entities.tag,

}
