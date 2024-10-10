--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Components)
local Entities = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Entities)
local Systems = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Systems)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local Types = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Types)
local Worlds = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Worlds)
local World = Worlds.World

local System = Systems.new("Heartbeat", script.Name, 1)

local hook = Entities.new("Hook")
local hookObject = Hooks

local listenerComponentsMap = {}

Systems:on_update(System, function(world: Types.World): ()
    local listeners = hookObject._.Listeners
    local setCommands = hookObject._.SetCommands

    for key: string, comp: {(any) -> ()} in listeners do
        if not listenerComponentsMap[key] then
            listenerComponentsMap[key] = Components.new(key)
        end
        for _: number, command: { Key: string, NewValue: any } in setCommands[key] do
            local component: Types.ComponentWithType<any> = listenerComponentsMap[command.Key]
            local last: any? = world:get(hook, component)
            Entities:give(hook, {[component] = command.NewValue})

            for _, callback: (any, any) -> () in comp do
                callback(last or nil, command.NewValue)
            end
        end

        setCommands[key] = {  }
    end
end)

return System


