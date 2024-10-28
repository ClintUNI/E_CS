--so, when we use priority numbers to change when a system runs, this is used to place them in the array. It will only be checked on the initial Engine run.

local engine = { __loaded = false }

type EngineStartParameters = { 
    Plugins: { [number]: ModuleScript }?,
    Services: { [number]: { [number]: ModuleScript } },
    Systems: { [number]: ModuleScript }?
}

--[[
    @yields

    Adds collections of systems known as services to the list of systems, \
    dependent on run order and other properties of each system or service.

    Returns a function which will start the engines.
    ```lua
        local start = engine.boot()

        local plugins: { ModuleScript }
        local services: { ModuleScript }
        local extraSystems: { ModuleScript }

        local engineStartParameters: { 
            Plugins: plugins, 
            Services: services, 
            Systems: extraSystems 
        }

        start(engineStartParameters)
    ```

    @return function `(engineStartParameters: EngineStartParameters) -> ()`
]]
function engine.boot(...: { 
    Plugins: { ModuleScript } ?, 
    Services: { ModuleScript } ?, 
    Systems: { ModuleScript } ?
}): (engineStartParameters: EngineStartParameters) -> ()
    local _ = require(script.Worlds).new(...)
    local _ = require(script.Entities)
    local _ = require(script.Components)
    local _ = require(script.Systems)

    return function(engineStartParameters: EngineStartParameters)
        local scheduler = require(script.Private.SchedulerV3)

        if engineStartParameters.Plugins then
            scheduler:service(engineStartParameters.Plugins)
        end
        if engineStartParameters.Services then
            scheduler:services(engineStartParameters.Services)
        end
        if engineStartParameters.Systems then
            scheduler:service(engineStartParameters.Systems)
        end
        
        local outlets = require(script.Outlets)
        outlets:start()

        scheduler:require()
        scheduler:start()
    end
end

--[[
function engine.boot(...): (engineStartParameters: EngineStartParameters) -> ()
    local _ = require(script.Worlds).new(...)
    local _ = require(script.Entities)
    local _ = require(script.Components)
    local _ = require(script.Systems)

    return function(engineStartParameters: EngineStartParameters)
        local scheduler = require(script.Private.Scheduler)

        if engineStartParameters.Services then
            scheduler:add_services(engineStartParameters.Services)
        end
        if engineStartParameters.Systems then
            scheduler:add(engineStartParameters.Systems)
        end

        engine.__loaded = scheduler:load() --Attempt to require the module files that we added.

        assert(engine.__loaded, "Something went wrong trying to load the game files.")
        scheduler:start()
    end
end
]]


return engine