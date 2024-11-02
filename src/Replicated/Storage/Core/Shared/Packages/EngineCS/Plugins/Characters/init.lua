--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS
local ClassesUtilies = E_CS.Classes

local Classes = require(ClassesUtilies)
local Components = require(E_CS.Components)
local DebugMode = require(E_CS.DebugMode)
local Entities =  require(E_CS.Entities)
local Systems =  require(E_CS.Systems)
local ECS = require(E_CS.Tools.ECS)
local Types = require(E_CS.Types)

local new = Classes.Creation
local get = Classes.Get

local CharacterClass = require(script.CharacterClass)

local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")

local CharacterFor: Types.Tag = Entities.tag("CharacterFor")
local CharacterCreation: Types.Tag = Entities.tag("CharacterCreation")

local CharacterClasses: Types.Tag = get.Type("Character")

Entities:give(CharacterFor, { [ECS.pair(ECS.OnDeleteTarget, ECS.Remove)] = Entities.NULL })


local System = Systems.new("Heartbeat", script.Name, 3)

--[[ Update ]]

Systems:on_update(System, function(world: Types.World)
    for playerEntity: Types.Entity, player: Player in world:query(PlayerComponent):with(CharacterCreation):iter() do
        if player.Character then
            DebugMode.warn("Characters | " .. player.Name .. " | Creating." )

            world:add(playerEntity, new(CharacterClass, {
                Name = player.Character.Name,
                Character = player.Character,
                [ECS.pair(CharacterFor, playerEntity)] = Entities.NULL,
            }))

            Entities:rid(playerEntity, CharacterCreation)
        end
    end
end)

return System