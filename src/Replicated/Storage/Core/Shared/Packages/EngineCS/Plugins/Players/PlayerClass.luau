--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local ClassesUtilities = E_CS.Classes

local Types = require(E_CS.Types)

local Classes = require(ClassesUtilities)
local Field = require(ClassesUtilities.Field)
local Property = require(ClassesUtilities.Property)
local Flag = require(ClassesUtilities.Flag)
local Type = require(ClassesUtilities.Type)
local Private = require(ClassesUtilities.Private)

local Declare = Classes.Declaration.open()

export type PlayerClass = { 
    Name: string,
    Player: Player
}

Declare.as("PlayerClass")

Declare.from(--[[ Inside of here, we can optionally choose what classIds our class inherits from. ]])

return Declare.create(
    function(entity: Types.Entity)
        Declare.construct(entity)

        return entity
    end,
    {
        Property("Name"),
        Property("Player"),

        Field("CharacterCreation"),

        Type("Player")
    }
)