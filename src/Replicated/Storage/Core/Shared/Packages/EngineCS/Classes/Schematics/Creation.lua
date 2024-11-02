local ReplicatedStorage = game:GetService("ReplicatedStorage")


local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Helpers = require(script.Parent.Helpers)
local DebugMode = require(E_CS.DebugMode)
local Entities = require(E_CS.Entities)
local Types = require(E_CS.Types)
local Storage = require(E_CS.Classes.Schematics.Storage)
local __Types = require(E_CS.Classes.Schematics.__Types)

return function(classId: number, props: { [string | number]: any }?): Types.Entity
    assert(Storage:has(classId), "Classes | Cannot create from a class that does not exist.")
    local classData: __Types.Class = Storage:get(Storage.Class, classId)

    DebugMode.warn("Classes | Creating entity with class " .. classData.Name)
    local newEntity: Types.Entity = Entities.new(classData.Name)

    DebugMode.warnIf(classData.InheritClassSchematicsFromIds[1] == nil, "Classes | Inheriting nothing for " .. classData.Name)
    for _, inheritanceClassId in classData.InheritClassSchematicsFromIds do
        local inheritanceClassData: __Types.Class = Storage:get(Storage.Class, inheritanceClassId)
        inheritanceClassData.Constructor(newEntity)
    end

    DebugMode.warn("Classes | Calling " .. classData.Name .. "'s class constructor")
    local newlyConstructedEntity: Types.Entity = classData.Constructor(newEntity)

    if props then
        DebugMode.warn("Classes | Giving props for " .. classData.Name)
        Helpers.parseAndGiveProps(newlyConstructedEntity, props)
    end

    DebugMode.warn("Classes | Creation complete for " .. classData.Name)
    
    return newlyConstructedEntity
end