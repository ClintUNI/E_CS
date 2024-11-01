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
local identify = Classes.Identify
local super = Classes.Super
local scope = Classes.Entity
local props = Classes.Props
local with = Classes.With
local private = require(ClassesFolder.Private)

export type CharacterClass = { 
    Name: string
}

return create(
    function(classId: number, class: CharacterClass, inheritances: { number }): Types.Entity
        local entity: Types.Entity = Entities.new("Character")
        scope(entity)
        super(inheritances)
        Entities:give(entity, class)

        return entity
    end,
    {
        --sync(Property("Example")) --Networked from server to client, not client to server.
        Property("Name"),
        Property("Character"),

        private(Property("ServerLocation")), --Server Side Only, but shared class.
        Property("ClientLocation"),

        Type("Character")
    }
).as("CharacterClass").save()