--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local ClassesUtilities = E_CS.Classes

local Classes = require(ClassesUtilities)
local Entities =  require(E_CS.Entities)
local Systems =  require(E_CS.Systems)
local Outlets = require(E_CS.Outlets)
local Types = require(E_CS.Types)
local DebugMode = require(E_CS.DebugMode)

local new = Classes.Creation

local PlayerClass = require(script.PlayerClass)

local System = Systems.new("Heartbeat", script.Name, 2)

--[[ Setup ]]

do
    local entityIDsByPlayer: { [Player]: Types.Entity } = {}
    
    local function createPlayerEntity(player: Player): ()
        if entityIDsByPlayer[player] then return end

        DebugMode.warn("Players | Creating player for " .. player.Name)

        Entities:cTag({player}, "LivingEntity")

        entityIDsByPlayer[player] = new(PlayerClass, {
            Player = player,
        });
    end

    local function destroyPlayerEntity(player: Player): ()
        Entities:destroy(entityIDsByPlayer[player])
        entityIDsByPlayer[player] = nil
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