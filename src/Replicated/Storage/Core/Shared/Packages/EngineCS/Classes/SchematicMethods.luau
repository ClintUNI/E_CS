local ReplicatedStorage = game:GetService("ReplicatedStorage")

local __ClassList = require(script.Parent.__ClassList)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
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

type ClassConstructor = (classId: number, class: {[any]: any}, inheritance: { number }) -> (Types.Entity)

local currentClass: ClassId = 0
local currentEntity;

local module = {}

type createChainMethods = { as: (name: string) -> createChainMethods, from: (inheritances: { ClassId }) -> (), save: () -> (ClassId) }
function module.create(constructor: ClassConstructor, class): createChainMethods
    currentClass = #classes + 1
    table.insert(classes, { __constructor = constructor :: ClassConstructor, __inherits = {}})

    local className = "Class" .. currentClass

    local commands; commands = {
        as = function(name: string)
            className = name
            print(name)

            return commands
        end,

        from = function(inheritances: { ClassId })
            module.from(inheritances)

            return commands
        end,

        save = function()
            __ClassList:SaveClass(className, class)

            return currentClass
        end
    }

    return commands
end

function module.parseShematic(classId): ClassScript
    local classSchematic =  __ClassList:GetClassSchematic(classId)
    assert(classSchematic, "Parsing nothing | ERROR.")
    local empty = true
    local classCommands = {}
    for key, value in classSchematic do
        if typeof(value) == "table" and value.Entity then
            classCommands[value.Entity] = value.Value or Entities.NULL
        elseif typeof(key) == "string" then
            local e = if value == "Tag" then Entities.tag(key) else Components.new(key)
            classCommands[e] = value or Entities.NULL
        else
            continue
        end

        empty = false
    end

    if empty then warn("Parsing an empty class table for " .. __ClassList:GetClassName(classId) .. " | WARNING") end

    return classCommands
end

function module.with(newPropertyValues: { [string | Types.Entity]: any })
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

local cachedProps = {}

function module.popProps(classId: ClassId)
    cachedProps[tostring(classId)] = nil
end

export type Props = ((ClassId) -> ({[Types.Entity | Types.Component]: any})) | ((ClassId, {[string]: any}) -> ())
function module.props(classId: ClassId, propList: {[string]: any}?)
    if propList then
        cachedProps[tostring(classId)] = propList
        return
    end
    return cachedProps[tostring(classId)]
end

function module.identify(class: ClassId): string
    local classData = classes[class]
    assert(classData ~= nil, "Cannot identify a class that does not exist.")
    return classData.__name
end

function module.super<A, D>(inherits: { ClassId })
    local inheritanceList: { [Types.Entity]: any } = {}

    for _, iClass in inherits, -1 do
        local classGiveCommands = __ClassList:GetClassGiveCommands(iClass)
        for entity, value in classGiveCommands do
            inheritanceList[entity] = value
        end
    end

    Entities:give(currentEntity, inheritanceList)
end

--[[
    Calls the constructor for a given class and returns a newly constructed entity of that class.
]]
function module.new(class: ClassId): Types.Entity
    assert(classes[class] ~= nil, "Cannot create from a class that does not exist.")

    if debugMode then
        warn("Creating entity with class", __ClassList:GetClassName(class))
    end

    local newEntity:Types.Entity = classes[class]
        .__constructor(
            class, 
            module.parseShematic(class), 
            classes[class].__inherits
        )
    module.popProps(class)
    currentEntity = newEntity

    return newEntity
end

function module.is(class: ClassId): boolean
    return Worlds.World:has(currentEntity, Entities.tag(classes[class].__name)) and true or false
end

function module.entity(classEntity: Types.Entity?): Types.Entity?
    if classEntity then
        currentEntity = classEntity
        return
    else
        return currentEntity
    end
end

function module.set<a, b, c>(entity:Types. Entity, fieldOrPropertyName: string, value: c?)
    if value then
        local property = Components.get(fieldOrPropertyName)
        Entities:give(entity, {[property] = value})
    else
        local field = Entities.tag(fieldOrPropertyName)
        Entities:give(entity, {[field] = Entities.NULL})
    end
end

function module.from(classList: { ClassId })
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

function module.getClassIdAndSetName(name: string): ClassId
    classes[currentClass].__name = name
    return currentClass
end

function module.getClassIdFromName(name: string): ClassId
    for classId, class in classes do
        if class.__name == name then
           return classId 
        end
    end

    error("Cannot get a class that doesn't exist for class: " .. name)
end

function module.classType(name: string)
    return Entities.tag(name:upper())
end

return module