--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local E_CS = ReplicatedStorage.Core.Shared.Packages.EngineCS

--[[ These are core 'classes' of E_CS, they are not used in every use case but are 
    the mandatory way of interacting with the framework.
]]

local Types = require(E_CS.Types)

local Entities =  require(E_CS.Entities)
local Components = require(E_CS.Components)
local Systems =  require(E_CS.Systems)

local Worlds = require(E_CS.Worlds)

local Outlets = require(E_CS.Outlets)
local Settings = require(E_CS.Settings)

--

--[[ These are tools, they're pre-packaged utilities.
    They usually come with their own systems that you need to include in the run cycle.
]]

local Hooks = require(E_CS.Tools.Hooks)
local MessageBus = require(E_CS.Tools.MessageBus)
local ModelTracking = require(E_CS.Tools.ModelTracking)
local UniqueKey = require(E_CS.Tools.UniqueKey)
local Input = require(E_CS.Tools.Input)

--

--This will be our system 'Instance' or entity. In reality, it is just a number.
local System = Systems.new("Heartbeat", script.Name, 2)

--This is our component which uniquely stores the player, and acts as the root of a player.
local PlayerComponent: Types.ComponentWithType<Player> = Components.new("Player")

--[[ Setup ]]

do
    --Basic functionality that will be run on boot up, but not during the system update cycle.
end

--[[ Update ]]

--This will designate what the system we defined earlier should do on each update cycle.
--In this example, we're only iterating over existing player Components.
--This can also be used to make skills as systems which run when that skill action component is on a 'LivingEntity'
Systems:on_update(System, function(world: Types.World): ()
    for entity: Types.Entity, player: Player in world:query(PlayerComponent):iter() do
        
    end

    --[[
        ```lua
        for entity: Types.Entity, player: Player in world:query(PlayerComponent):without(CharacterComponent):iter() do
            
        end
        ```
    ]]
end)

return System