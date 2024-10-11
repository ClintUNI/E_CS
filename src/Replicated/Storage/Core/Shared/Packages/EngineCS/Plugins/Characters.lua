--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Outlets = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Outlets)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local ModelTracking = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ModelTracking)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local System = Systems.new("Heartbeat", script.Name, 3)

local PlayerComponent: Types.ComponentWithType<Player> = Components.get("Player")
local CharacterComponent: Types.ComponentWithType<Model> = Components.get("Model")

--Custom version of model tracking soecifically for this API, I could make an abstraction tbh with a model, its creation, and removing, signals and boom-

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(CharacterComponent):iter() do
        if player.Character then
            ModelTracking:subscribe(playerEntity, player.Character)
        end
    end
end)

return System