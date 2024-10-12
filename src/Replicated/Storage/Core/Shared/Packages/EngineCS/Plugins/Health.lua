--!strict
--!strict
--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Outlets = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Outlets)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local ModelTracking = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ModelTracking)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 5)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local HealthComponent: Types.ComponentWithType<number> = Components.new("Health")
local HumanoidComponent: Types.ComponentWithType<Humanoid> = Components.new("Humanoid")

--[[ Update ]]

Systems:on_update(System, function(world: Types.World): ()
    for playerEntity: Types.Entity, humanoid: Humanoid in world:query(HumanoidComponent):without(HealthComponent):iter() do
        print("hia humanoid without health")

        Entities:give(playerEntity, {[HealthComponent] = 100})
    end

    for playerEntity: Types.Entity, healthAmount: number, humanoid: Humanoid in world:query(HealthComponent, HumanoidComponent):iter() do
        if humanoid.Health ~= healthAmount then
            humanoid.Health = healthAmount
        end
    end
end)

return System