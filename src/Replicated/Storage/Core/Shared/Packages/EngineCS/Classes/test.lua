--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Classes = require(script.Parent.Classes)


local Field = require(script.Parent.Field)
local Flag = require(script.Parent.Flag)
local Property = require(script.Parent.Property)

local create = Classes.Create
local parse = Classes.Parse
local from = Classes.From
local class = Classes.Class

local foreignClass = 2

type testClass = { Name: string, RaceId: number, Location: CFrame, Alive: true, FFTesting: true }

create(
    function(class: testClass): Types.Entity
        local entity: Types.Entity = Entities.new("test")
        Entities:give(entity, parse(class))

        return entity
    end,
    {
        Property("Name", "Test"), --Component with default data.
        Property("RaceId", 1), 
        Property("Location"), --Component that doesn't have default data but will
                                    -- be given a value soon after creation.
        Field("Alive"), --Tag

        Flag("Testing"), -- FFTesting
    }
)

from(foreignClass)

return class()