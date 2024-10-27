--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Classes = require(script.Parent)


local Field = require(script.Parent.Field)
local Flag = require(script.Parent.Flag)
local Property = require(script.Parent.Property)

local create = Classes.Create
local parse = Classes.Parse
local from = Classes.From
local class = Classes.Class
local identify = Classes.Identify

local debugMode = _G.E_DEBUG

local foreignClassId = 2

type testClass = { Name: string, RaceId: number, Location: CFrame, Alive: true, FFTesting: true }

create(
    function(classId: number, class: testClass, inheritances: { [Types.Component | Types.Entity]: any }): Types.Entity
        local entity: Types.Entity = Entities.new(identify(classId))
        Entities:give(entity, inheritances) --Allows for interface and default values to be overwritten.
        Entities:give(entity, class)

        if debugMode then
            warn("Creating entity with class", identify(classId))
        end

        return entity
    end,
    {
        Property("Name", "Test"), --Component with default data.
        Property("RaceId", 1), 
        Property("Location", Vector3.zero), --Component that doesn't have default data but will
                                    -- be given a value soon after creation.
        Field("Alive"), --Tag

        Flag("Testing"), -- FFTesting
    }
)

--[[```lua from(foreignClassId, ...)```]]

return class("TestClass")