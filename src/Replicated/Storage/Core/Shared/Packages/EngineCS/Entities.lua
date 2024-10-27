--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local collection = game:GetService("CollectionService")

local Types = require(script.Parent.Types)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus) :: Types.MessageBus
local JECS = require(ReplicatedStorage.Core.Shared.Packages.JECS)
local Components = require(script.Parent.Components)
local Settings = require(script.Parent.Settings)

local Worlds = require(script.Parent.Worlds)

local ENTITY_TAG = "__ENTITY"

local ChangesComponent: Types.ComponentWithType<{any}> = Components.new("Changes")
local SyncComponent = Components.new("Sync")

local EntityChangesQueue = MessageBus.new("EntityChanges")

local entitiesByTypeName: { [string]: { Types.Entity } }  = {}

local entityTagsByName: { [string]: Types.Entity } = {}

local module = {}
module.NULL = 81_487_763
--[[
    @param typeName : `string` accepts a string denoting the type, for example "Player"

    @return `Types.Entity`
]]
function module.new(typeName: string): Types.Entity
    local entity: Types.Entity = Worlds.World:entity()

    if entitiesByTypeName[typeName] then 
        table.insert(entitiesByTypeName[typeName], entity) 
    else 
        entitiesByTypeName[typeName] = { entity } 
    end

    if Settings.Plugins.Changes == true  then --normally true, but this should be networked instead
        MessageBus.queue(EntityChangesQueue, { Entity = entity, Components = "CREATE" })
    end

    return entity
end

function module.tag(name: string)

    if entityTagsByName[name] then 
        return entityTagsByName[name]
    else 
        local e = Worlds.World:entity()
        entityTagsByName[name] = e

        return e
    end
end

local function give(world: Types.World, entity: Types.Entity, component: Types.Component, value: any?)
    if value then
        world:set(entity, component, value)
    else
        world:add(entity, component)
    end
end

--[[
    @param `entity` : `Types.Entity`
    @param `components` : `{ [Types.Component]: any }`
    @param `duration` : `number?`
]]
function module:give(entity: Types.Entity, components: { [Types.Component]: any }, duration: number?)
    local world: Types.World = Worlds.World

    local shouldQueueMessage: boolean = (world:get(entity, SyncComponent) or false)

    for component: Types.Component, value: any in components do
        give(world, entity, component, if value == module.NULL then nil else value)
    end

    if shouldQueueMessage then
        MessageBus.queue(EntityChangesQueue, { Entity = entity, Components = components })
    end

    if duration then
        warn("Spawning a delayed component removal using Entities:give() may error.")
        task.delay(duration, function()
            for component: Types.Component, value: any in components do
                world:remove(entity, component)
            end
        end)
    end
end

function module:insert<ComponentType>(entity: Types.Entity, componentWithTableValue: Types.ComponentWithType<ComponentType>, values: { [number | string]: any })
    local world: Types.World = Worlds.World

    local data: ComponentType? = world:get(entity, componentWithTableValue)
    if data and typeof(data) == "table" then
        for key: string | number, value: any in values do
            data[key] = value
        end

        give(world, entity, componentWithTableValue, data)

        --TODO add middleware

        if module:has(entity, SyncComponent) then
            MessageBus.queue(EntityChangesQueue, { Entity = entity, Component = data })
        end
    end
end

function module:rid(entity: Types.Entity, ...: Types.Component)
    local world = Worlds.World
    local componentsAsNull = {}
    for _, component: Types.Component in { ... } do
        world:remove(entity, component)
        componentsAsNull[component] = module.NULL

        if world:has(entity, SyncComponent) then
            MessageBus.queue(EntityChangesQueue, { Entity = entity, Components = "DELETE" })
        end
    end

    module:insert(entity, ChangesComponent, componentsAsNull)
end

function module:has(entity: Types.Entity, component: Types.Component, ...: Types.Component): boolean
    local componentsTable: { Types.Component } = { ... }
    
    local met_requirements: boolean = Worlds.World:has(entity, component)
    if componentsTable[1] and met_requirements then
        for _, _component in componentsTable do
            met_requirements = Worlds.World:has(entity, _component)
        end
    end

    return met_requirements
end

function module:destroy(entity: Types.Entity, ignoreHook: boolean?): ()
    Worlds.World:delete(entity)

    if module:has(entity, SyncComponent) then
        MessageBus.queue(EntityChangesQueue, { Entity = entity, Component = module.NULL, Value = "DELETE" })
    end
end

--[[
    Returns table consisting of any entities that exist under the provided typeName.

    @param typeName string Name of the type of which this entity belongs to, example "Player".

    @return `{ Types.Entity }?`
]]
function module:with(typeName: string): { Types.Entity }
    return entitiesByTypeName[typeName] or {}
end

function module:cTag(instances: {Instance}, tag: string)
    for index: number, instance in instances do
        collection:AddTag(instance, tag)
    end
end

function module:cUntag(instances: {Instance}, tag: string)
    for index: number, instance: Instance in instances do
        collection:RemoveTag(instance, tag)
    end
end

function module:cTagged(tag: string?)
    return collection:GetTagged(tag or ENTITY_TAG)
end

return module

