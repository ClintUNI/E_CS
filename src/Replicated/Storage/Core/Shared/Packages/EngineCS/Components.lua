--!strict
local Worlds = require(script.Parent.Worlds)
local Types = require(script.Parent.Types)


type PluginComponents = "Player"? | "Network"?

local componentEntitiesByName: {[string | PluginComponents]: Types.Component} = {}

local module = {}

function module.new<T>(name: string): Types.ComponentWithType<T>
    local world: Types.World = Worlds.World

    local component: Types.ComponentWithType<T> = world:component()
    componentEntitiesByName[name] = component
    return component
end

function module.get<T>(name: string): Types.ComponentWithType<T>
    return componentEntitiesByName[name]
end

function module:for_each<T>(...: Types.ComponentWithType<T>): typeof(Worlds.World:query(... :: Types.ComponentWithType<T>):iter())
    local world: Types.World = Worlds.World

    return world:query(...):iter()
end

return module