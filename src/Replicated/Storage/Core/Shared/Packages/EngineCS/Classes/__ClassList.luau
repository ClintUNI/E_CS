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

local parse = function(class)
    local classCommands = {}
    for key, value in class do
        if typeof(key) == "table" then
            classCommands[key.Entity] = key.Value or Entities.NULL
        end
    end

    return classCommands
end

local classes; classes = {
    ClassesList = {},
    ClassIds = {},
    ClassScripts = {},
    ClassGiveCommands = {},
    ClassNames = {},

    SaveProperty = function(self, class, component, name, value)
        table.insert(self.ClassesList[class].Properties.Components, component)
        local index = #self.ClassesList[class].Properties.Components
        self.ClassesList[class].Properties.ComponentsAndNames[index] = name:upper()

        if value then
            if self.ClassesList[class].Properties.Types[typeof(value)] then
                table.insert(self.ClassesList[class].Properties.Types[typeof(value)], index)
            end
        end
        
        return index
    end,

    SaveField = function(self, class, tag, name)
        table.insert(self.ClassesList[class].Fields.Tags, tag)
        self.ClassesList[class].Fields.NameTagIds[name:upper()] = tag
        
        return #self.ClassesList[class].Fields.Tags
    end,

    SaveFlag = function(self, class, tag, name)
        table.insert(self.ClassesList[class].Flags.Tags, tag)
        local index = #self.ClassesList[class].Flags.Tags
        self.ClassesList[class].Fields.NameClassIdPairs[name:upper()] = index
        
        return #index
    end,

    SaveClass = function(self, name, ClassScript)
        local class = newClass(#self.ClassesList + 1)

        self.ClassesList[class.Id] = class
        self.ClassScripts[class.Id] = ClassScript
        self.ClassNames[class.Id] = name
        self.ClassGiveCommands[class.Id] = parse(ClassScript)
        self.ClassGiveCommands[class.Id][Entities.tag("Class" .. name)] = Entities.NULL

        return class.Id
    end,
    
    GetClassGiveCommands = function(self, class)
        return self.ClassGiveCommands[class]
    end
}

return classes