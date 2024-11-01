--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local Entities =  require(E_CS.Entities)
local Components = require(E_CS.Components)
local Systems =  require(E_CS.Systems)
local Outlets = require(E_CS.Outlets)
local Types = require(E_CS.Types)
local Settings = require(E_CS.Settings)

local Classes = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Classes)

local new = Classes.New
local with = Classes.With
local entity = Classes.Entity
local property = Classes.PropertyGet
local declareProps = Classes.Props
local PlayerClass = require(script.PlayerClass)

local System = Systems.new("Heartbeat", script.Name, 2)

local debugMode = _G.E_DEBUG

--[[ Setup ]]

do
    local entityIDsByPlayer: { [Player]: Types.Entity } = {}
    
    local function createPlayerEntity(player: Player): ()
        if entityIDsByPlayer[player] then return end

        if debugMode then
            warn("Creating player for", player)
        end

        declareProps(PlayerClass, {
            Player = player,
        })
        local playerEntity = new(PlayerClass);

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