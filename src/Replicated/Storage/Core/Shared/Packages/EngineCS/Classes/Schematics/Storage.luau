local __Types = require(script.Parent.__Types)

local storage = {}

storage.Class = 1
storage.Schematic = 2

local storedClasses: __Types.StoredClasses = {}
local storedSchematics: __Types.StoredClassSchematics = {}

function storage.new(className: string, constructor, classSchematics: __Types.ClassSchematics, inheritanceClassIds: { number }): number
    table.insert(storedClasses, { 
        Name = className, 
        Constructor = constructor, 
        ClassId = #storedClasses + 1, 
        SchematicId = table.insert(storedSchematics, classSchematics) and #storedSchematics,
        InheritClassSchematicsFromIds = inheritanceClassIds,
    })

    return #storedClasses
end

function storage:edit(classId: number, data: { [string]: any }): ()
    for key, value in data do
        storedClasses[classId][key] = value
    end
end

function storage:get(what: number, classId: number)
    if what == self.Schematic then
        return storedSchematics[classId]
    else
        return storedClasses[classId]
    end
end

function storage:has(classId: number): boolean
    return storedClasses[classId] and true or false
end

function storage:name(classId: number): string
    return storedClasses[classId].Name
end

return storage