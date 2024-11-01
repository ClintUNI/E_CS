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

export type StateInterface = { 
    Name: string,
    StateId: number,
}

return create(
    function()  warn("Cannot call interface contructors."); return nil :: Types.Entity; end,
    {
        --sync(Property("Example")) --Networked from server to client, not client to server.
        Property("Name"),
        Property("StateId"),

        Type("BaseState")
    }
).as("AbstractState").save()