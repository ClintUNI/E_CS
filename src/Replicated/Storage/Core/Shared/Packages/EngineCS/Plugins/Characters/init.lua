--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Classes)
local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Outlets = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Outlets)
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Systems =  require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local ECS = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.ECS)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Input = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Input)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local ModelTracking = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Objects)

local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)

local new = Classes.New
local get = Classes.Get
local withProps = Classes.WithProps
local CharacterClass = require(script.CharacterClass)

local System = Systems.new("Heartbeat", script.Name, 3)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local Characters: Types.ComponentWithType<Model> = Components.new("Character")

local CharacterFor: Types.Tag = Entities.tag("CharacterFor")
local CharacterCreation: Types.Tag = Entities.tag("CharacterCreation")

local debugMode = _G.E_DEBUG

Entities:give(CharacterFor, { [ECS.pair(ECS.OnDeleteTarget, ECS.Remove)] = Entities.NULL })

--Custom version of model tracking soecifically for this API, I could make an abstraction tbh with a model, its creation, and removing, signals and boom-

local teleportLocation = CFrame.new(20, 80, -20)

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity in world:query(CharacterCreation):iter() do
        local player = world:get(playerEntity, PlayerComponent)
        if player and player.Character then
            if debugMode then
                warn("Creating character for", player)
            end


            local characterEntity = new(CharacterClass);
            withProps({
                Name = player.Character.Name,
                Character = player.Character,
                [ECS.pair(CharacterFor, playerEntity)] = Entities.NULL,
            })

            Entities:give(playerEntity, {[characterEntity] = Entities.NULL})

            Entities:rid(playerEntity, CharacterCreation)
        end
    end

    -- for characterEntity: Types.Entity in world:query(get.Type("Character")):iter() do
    --     print(characterEntity, world:get(characterEntity, Components.new("Character")))
    -- end

    -- for character in world:query(Characters, ECS.pair(CharacterOf, ECS._W)):iter() do
    --     print(character, world:target(character, CharacterOf))
    -- end

    -- for playerEntity: Types.Entity, player: Player, character: Model in world:query(PlayerComponent, CharacterComponent):iter() do
    --     if character ~= player.Character then
    --         print('not same :O')
    --         local characterEntity = world:target(playerEntity, ECS.pair(CharacterComponent, ECS.Wildcard))
    --         if char
    --         Entities:give(playerEntity, {[ECS.pair(CharacterComponent, )] = player.Character})
    --     end
    -- end

    -- if Settings.Game.IsServer then return end


    -- for playerEntity: Types.Entity, character: Model in world:query(CharacterComponent):without(WaitComponent):iter() do
    --     print(character)
    --     character:PivotTo(teleportLocation)
    -- end
end)

return System