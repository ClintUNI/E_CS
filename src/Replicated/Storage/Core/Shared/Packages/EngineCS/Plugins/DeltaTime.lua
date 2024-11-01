--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local system = Systems.new("Heartbeat", script.Name, 1)

local DeltaTime: Types.ComponentWithType<number> = Components.new("DeltaTime")
local Game = Entities.new("Game")

local oS: typeof(os) = os

local lastFrameClock: number;
local deltaTime: number = 0

Systems:on_update(system, function(world: Types.World): ()
    local currentFrameClock: number = oS.clock()
    deltaTime = currentFrameClock - (lastFrameClock or currentFrameClock)
    lastFrameClock = currentFrameClock

    Entities:give(Game, {[DeltaTime] = deltaTime})

    --/
end)


return system