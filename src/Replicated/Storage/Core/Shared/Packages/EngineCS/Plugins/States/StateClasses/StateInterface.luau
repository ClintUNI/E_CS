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

export type StateInterface = { 
    Name: string,
    StateEnumType: number,
}

Declare.as("StateInterface")

return Declare.create(
    function(entity: Types.Entity)
        Declare.construct(entity)

        return entity
    end,
    {
        Property("Name"),
        Property("StateEnumType"),

        Type("State")
    }
)