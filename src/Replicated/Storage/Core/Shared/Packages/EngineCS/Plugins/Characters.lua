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

local System = Systems.new("Heartbeat", script.Name, 3)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local CharacterComponent: Types.ComponentWithType<Model> = Components.new("Character")
local WaitComponent:Types.ComponentWithType<number> = Components.new("Wait")

--Custom version of model tracking soecifically for this API, I could make an abstraction tbh with a model, its creation, and removing, signals and boom-

local teleportLocation = CFrame.new(20, 80, -20)

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):without(CharacterComponent):iter() do
        print("hia char")

        if player.Character then
            Entities:give(playerEntity, {[CharacterComponent] = player.Character})
        end
    end

    for playerEntity: Types.Entity, player: Player, character: Model in world:query(PlayerComponent, CharacterComponent):iter() do
        if character ~= player.Character then
            print('not same :O')
            Entities:give(playerEntity, {[CharacterComponent] = player.Character})
        end
    end

    if Settings.Game.IsServer then return end

    for playerEntity: Types.Entity, character: Model in world:query(CharacterComponent):without(WaitComponent):iter() do
        print(character)
        character:PivotTo(teleportLocation)

        Entities:give(playerEntity, {
            [WaitComponent] = 3
        })
    end
end)

return System