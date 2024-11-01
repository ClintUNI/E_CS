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
local identify = Classes.Identify
local super = Classes.Super
local props = Classes.Props
local scope = Classes.Entity
local with = Classes.With

local PropertyGet = Classes.Get.Property



local foreignClassId = 2

type testClass = { Name: string, RaceId: number, Location: CFrame, Alive: true, FFTesting: true }

return create(
    function(classId: number, class: testClass, inheritances: { number }): Types.Entity
        local entity: Types.Entity = Entities.new(identify(classId))
        scope(entity)

        super(inheritances) --Allows for interface and default values to be overwritten by running this first.
        Entities:give(entity, class)

        --do not do this if you use the withProps(), this is meant for declareProps()
        with(props(classId) :: testClass) --Props are values given before the constructor is called.
                                        -- They will be 'popped' after the constructor task.
                                         -- == to withProps({}) in the systems scope.
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
).as("TestClass").save()