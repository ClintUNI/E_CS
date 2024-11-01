local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)

local function newClass(id)
    return {
        Id = id,
        Entities = {},
        Properties = {
            Types = {},
            Components = {},
            ComponentsAndNames = {},
        },
        Fields = {
            NameTagIds = {},
            Tags = {},
        },
        Flags = {
            NameTagIds = {},
            Tags = {}
        }
    }
end


local E_debug = _G.E_DEBUG

local classes; classes = {
    ClassesList = {},
    ClassIds = {},
    ClassScripts = {},
    ClassNames = {},

    SaveClass = function(self, name, ClassScript)
        local class = newClass(#self.ClassesList + 1)

        self.ClassesList[class.Id] = class
        self.ClassScripts[class.Id] = ClassScript
        self.ClassNames[class.Id] = name

        if E_debug then
            warn("Saving class " .. name .. " with the schematic:", ClassScript)
        end

        return class.Id
    end,
    
    GetClassSchematic = function(self, classId): {[any]: any}
        return self.ClassScripts[classId]
    end,

    GetClassName = function(self, classId): string
        return self.ClassNames[classId]
    end
}

return classes