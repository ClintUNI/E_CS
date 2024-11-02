local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

export type Schematic = { Entity: Types.Entity, Value: any? }
export type ClassSchematics = { [number]: Schematic }

export type Class = { 
    Name: string, 
    Constructor: ClassConstructor, 
    SchematicId: number, 
    InheritClassSchematicsFromIds: { number } 
} 
export type ClassConstructor = (entity: Types.Entity) -> (Types.Entity)

export type StoredClassSchematics = { [number]: ClassSchematics }
export type StoredClasses = { 
    [number]: Class
}


return {}