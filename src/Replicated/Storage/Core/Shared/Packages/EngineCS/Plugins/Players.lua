--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Entities =  require(E_CS.Entities)
local Components = require(E_CS.Components)
local Systems =  require(E_CS.Systems)
local Outlets = require(E_CS.Outlets)
local Types = require(E_CS.Types)
local Settings = require(E_CS.Settings)

local System = Systems.new("Heartbeat", script.Name, 2)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")
local NetworkComponent: Types.ComponentWithType<boolean> = Components.new("Network")
local WaitsComponent:Types.ComponentWithType<number> = Components.new("Waits")

local CharacterCreation: Types.Tag = Entities.tag("CharacterCreation")

--[[ Setup ]]

do
    local entityIDsByPlayer: { [Player]: Types.Entity } = {}
    
    local function createPlayerEntity(player: Player): ()
        if entityIDsByPlayer[player] then return end

        local playerEntity: Types.Entity = Entities.new("Player")
        Entities:give(playerEntity, {
            [PlayerComponent] = player,
            [NetworkComponent] = (Settings.Game.IsServer and Settings.Plugins.Network),
            [CharacterCreation] = Entities.NULL
        })

        Entities:cTag({player}, "LivingEntity")

        entityIDsByPlayer[player] = playerEntity
    end

    local function destroyPlayerEntity(player: Player): ()
        Entities:destroy(entityIDsByPlayer[player])
    end

    local players = game:GetService("Players")


    for _, player in players:GetPlayers() do createPlayerEntity(player) end
    Outlets:plug(players.PlayerAdded, createPlayerEntity)
    Outlets:plug(players.PlayerRemoving, destroyPlayerEntity)
end

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    -- for entity: Types.Entity, player: Player in world:query(PlayerComponent):without(WaitComponent):iter() do
    --     Entities:give(entity, {
    --         [WaitComponent] = 5
    --     })
    -- end
end)

--change to use hooks when players join or leave

return System
