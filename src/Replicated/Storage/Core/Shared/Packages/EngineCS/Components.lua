--!strict
local Worlds = require(script.Parent.Worlds)
local Types = require(script.Parent.Types)


type PluginComponents = "Player"? | "Network"?

local componentEntitiesByName: {[string | PluginComponents]: Types.Component} = {}

local module = {}

--[[
    Creates, or locates, a named component entity and returns it. \
    When created, the component will be stored in a hashmap.

    @param name : `string`

    @return Component
]]
function module.new<T>(name: string): Types.ComponentWithType<T>
    local world: Types.World = Worlds.World

    local componentExists = module.get(name)
    if componentExists then
        return componentExists
    else
        local component: Types.ComponentWithType<T> = world:component()
        componentEntitiesByName[name] = component
        return component
    end
end

--[[
    Get a component with the given name.

    @param name : `string`

    @return Component
]]
function module.get<T>(name: string): Types.ComponentWithType<T>
    return componentEntitiesByName[name]
end

return module