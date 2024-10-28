--!strict
--!strict
--!strict
--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StateComponents = require(script.StateComponents)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Outlets = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Outlets)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local ModelTracking = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Objects)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 6)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local StateComponent: Types.ComponentWithType<number> = Components.new("State")
local ActionComponent = Components.new("Action")
local EmotionComponent = Components.new("Emotion")
local StatusEffectsComponent = Components.new("StatusEffects")


--[[ Update ]]

Systems:on_update(System, function(world: Types.World): ()
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(StateComponent):iter() do
        print("hia humanoid without health")

        Entities:give(playerEntity, {
            [ActionComponent] = StateComponents.Actions.Idle,
            [EmotionComponent] = StateComponents.Emotions.Bored,
            [StatusEffectsComponent] = StateComponents.StatusEffects.Normal
        })
    end

end)

return System