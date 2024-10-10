--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Plugins = ReplicatedStorage.Core.Shared.Packages.EngineCS.Plugins
local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
return function(): { ModuleScript }
    local plugins = Settings.Plugins
    
    local pluginModules: { [number]: ModuleScript } = {}
    for key: unknown, shouldLoad: unknown in plugins do
        local stringKey = key :: string
        
        if shouldLoad then
            local moduleScript = Plugins:FindFirstChild(stringKey) :: ModuleScript?
            if moduleScript then
                print(stringKey)
                table.insert(pluginModules, Plugins:FindFirstChild(stringKey) :: ModuleScript)
            end
        end
    end

    return pluginModules
end
