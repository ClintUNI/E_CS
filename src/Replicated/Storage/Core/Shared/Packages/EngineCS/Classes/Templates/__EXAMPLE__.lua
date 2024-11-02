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

local Declare = Classes.Declaration.open()

type testClass = { Name: string, RaceId: number, Location: CFrame, Alive: true, FFTesting: true }

Declare.as("TestClass")

Declare.from(--[[ Inside of here, we can optionally choose what classIds our class inherits from. ]])

return Declare.create(
    function(entity: Types.Entity)
        Declare.construct(entity)  --Classes API V2 handles construction for you using this method.

        --The constructor is meant to be used to change known default values.

        return entity
    end, 
    {
        Property("Name", "Test"), --Component with default data.
        Property("RaceId", 1), 
        Property("Location"), --Component that doesn't have default data but will
                                    -- be given a value soon in the constructor.
        Field("Alive"), -- Tag

        Flag("Testing"), -- FFTesting Tag

        Type("Test"), -- TEST Tag
    }
)