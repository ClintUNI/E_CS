--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS

local Entities = require(E_CS.Entities)
local Types = require(E_CS.Types)

local ClassesFolder = E_CS.Classes
local Classes = require(ClassesFolder)
local Field = require(ClassesFolder.Field)
local Property = require(ClassesFolder.Property)
local Flag = require(ClassesFolder.Flag)
local Type = require(ClassesFolder.Type)

local create = Classes.Create
local parse = Classes.Parse
local from = Classes.From
local as = Classes.As
local identify = Classes.Identify
local super = Classes.Super
local scope = Classes.Entity
local props = Classes.Props
local with = Classes.With

export type CharacterClass = { 
    Name: string,
    Character: Model,
    CharacterFor_Pair: Types.Entity
}

create(
    function(classId: number, class: CharacterClass, inheritances: { number }): Types.Entity
        local entity: Types.Entity = Entities.new("Character")
        scope(entity)
        super(inheritances)
        Entities:give(entity, class)
            with(props(classId) :: CharacterClass)

        return entity
    end,
    {
        Property("Name"),
        Property("Character"),

        Type("Character")
    }
)

return as("CharacterClass")