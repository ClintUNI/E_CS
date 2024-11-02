local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Helpers = require(script.Parent.Helpers)
local DebugMode = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.DebugMode)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Storage = require(script.Parent.Storage)
local __Types = require(script.Parent.__Types)


local constructor = {}



function constructor.open()
    local scoped = {}

    local scopedClassId: number;
    local scopedClassSchematic: __Types.ClassSchematics;
    local scopedInheritedIds: { number };
    local scopedName: string;

    function scoped.from(inheritanceClassIds: { number }): ()
        scopedInheritedIds = inheritanceClassIds
    end

    function scoped.as(className: string): ()
        scopedName = className
    end

    function scoped.construct(entity: Types.Entity)
        Entities:give(entity, Helpers.parseClassSchematic(scopedClassSchematic))
    end

    function scoped.create(constructor: __Types.ClassConstructor, classSchematic: __Types.ClassSchematics)
        assert(scopedName, "Classes | In order to create a class, it must first have a name.")

        scopedClassId = Storage.new(scopedName, constructor, classSchematic, scopedInheritedIds or {})
        scopedClassSchematic = classSchematic
        return scopedClassId
    end

    return scoped
end

return constructor