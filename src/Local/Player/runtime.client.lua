--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local ExpressLoad = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ExpressLoad)
local EngineCS = require(E_CS)
local start = EngineCS.boot()

local plugins: {ModuleScript} = { E_CS.Plugins.Wait, E_CS.Plugins.Players, E_CS.Plugins.Characters, E_CS.Plugins.Sync, E_CS.Plugins.Changes, E_CS.Plugins.Hooks }

local engineStartParameters = { Plugins = ExpressLoad(), Services = {} }

start(engineStartParameters)
