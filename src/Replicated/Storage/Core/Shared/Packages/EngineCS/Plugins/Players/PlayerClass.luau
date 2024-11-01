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
local super = Classes.Super
local scope = Classes.Entity
local props = Classes.Props
local with = Classes.With

export type PlayerClass = { 
    Name: string,
    Player: Player
}

return create(
    function(classId: number, class: PlayerClass, inheritances: { number }): Types.Entity
        local entity: Types.Entity = Entities.new("Player")
        scope(entity)
        super(inheritances)
        Entities:give(entity, class)

        return entity
    end,
    {
        --sync(Property("Example")) --Networked from server to client, not client to server.
        Property("Name"),
        Property("Player"),

        Field("CharacterCreation"),

        Type("Player")
    }
).as("PlayerClass").save()