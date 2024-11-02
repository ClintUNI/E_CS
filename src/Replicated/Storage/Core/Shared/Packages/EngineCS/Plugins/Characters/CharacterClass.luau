--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local ClassesUtilities = E_CS.Classes

local Benchmark = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Benchmark)
local Types = require(E_CS.Types)

local Classes = require(ClassesUtilities)
local Field = require(ClassesUtilities.Field)
local Property = require(ClassesUtilities.Property)
local Flag = require(ClassesUtilities.Flag)
local Type = require(ClassesUtilities.Type)
local Private = require(ClassesUtilities.Private)

local Declare = Classes.Declaration.open()

export type CharacterClass = { 
    Name: string,
    Character: Model,
    ClientLocation: Vector3
}

Declare.as("CharacterClass")

return Declare.create(
    function(entity: Types.Entity)
        Declare.construct(entity)


        return entity
    end,
    {
        --sync(Property("Example")) --Networked from server to client, not client to server.
        Property("Name"),
        Property("Character"),

        Private(Property("ServerLocation")), --Server Side Only, but shared class.
        Property("ClientLocation"),

        Type("Character")
    }
)