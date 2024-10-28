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
local Type = require(script.Parent.Type)

local create = Classes.Create
local parse = Classes.Parse
local from = Classes.From
local as = Classes.As
local identify = Classes.Identify
local super = Classes.Super
local props = Classes.Props
local scope = Classes.Entity
local with = Classes.With

local PropertyGet = Classes.PropertyGet



local foreignClassId = 2

type testClass = { Name: string, RaceId: number, Location: CFrame, Alive: true, FFTesting: true }

create(
    function(classId: number, class: testClass, inheritances: { number }): Types.Entity
        local entity: Types.Entity = Entities.new(identify(classId))
        scope(entity)

        super(inheritances) --Allows for interface and default values to be overwritten by running this first.
        Entities:give(entity, class)

        with(props(classId) :: testClass) --Props are values given before the constructor is called.
                                        -- They will be 'popped' after the constructor task.
        return entity
    end,
    {
        Property("Name", "Test"), --Component with default data.
        Property("RaceId", 1), 
        Property("Location"), --Component that doesn't have default data but will
                                    -- be given a value soon in the constructor.
        Field("Alive"), -- Tag

        Flag("Testing"), -- FFTesting Tag

        Type("Test"), -- IsATest Tag
    }
)

--[[```lua 
from(foreignClassId, ...)
```]]

return as("TestClass")