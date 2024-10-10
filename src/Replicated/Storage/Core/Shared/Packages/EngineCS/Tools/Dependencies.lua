--!strict

--[[IGNORE]]
local module = {}

local injections: { [number]: number } = {}

local injectionArcheTypes: { [number]: { number } } = {}

local archeTypesByRunOrder: { [number]: number } = {}

local moduleScriptsInjected: { ModuleScript } = {}

function module:inject(moduleScriptsTable: { ModuleScript }): number
    local table: typeof(table) = table
    local moduleScriptIds: { number } = {}
    for _, moduleScript in moduleScriptsTable do
        local moduleScriptId: number = table.find(moduleScriptsInjected, moduleScript) :: number
        if not moduleScriptId then
            table.insert(moduleScriptsInjected, moduleScript)
            moduleScriptId = #moduleScriptsInjected
        end
        table.insert(moduleScriptIds, moduleScriptId)
    end

    local archeType: number;
    for archeTypeId: number, archeTypeStringIds: { number } in injectionArcheTypes do
        local archeTypeMatches: boolean = true
        for _, moduleScriptId: number in archeTypeStringIds do
            if not moduleScriptsInjected[moduleScriptId] then
                archeTypeMatches = false
                break
            end
        end
        
        if archeTypeMatches then
            archeType = archeTypeId
            break
        else
            table.insert(injectionArcheTypes, moduleScriptIds)
            archeType = #injectionArcheTypes
        end
    end

    table.insert(injections, archeType)

    return #injections
end

--[[
    Returns the module scripts that a given injection index depends on.
]]
local function readFrom(injectionIndex: number)
    local archeTypeModuleScriptIds = injectionArcheTypes[injections[injectionIndex]]
    local moduleScripts = {}
    for _, moduleScriptId: number in archeTypeModuleScriptIds do
        table.insert(moduleScripts, moduleScriptsInjected[moduleScriptId])
    end

    return moduleScripts
end

local function sortDictionairyToTableAndDictionairys(dict)
    local newDictionairysTable = {}
    local lastIndex;
    local last;
    local current = #newDictionairysTable
    for moduleScript, amount in dict do
        if last and lastIndex then
            if last < amount then
                newDictionairysTable[#newDictionairysTable + 1] = newDictionairysTable[lastIndex]
                newDictionairysTable[#newDictionairysTable - 1] = { ModuleScript = moduleScript, Amount = amount }
            end
        else
            newDictionairysTable[#newDictionairysTable + 1] = { ModuleScript = moduleScript, Amount = amount }
        end

        current = #newDictionairysTable
        lastIndex = current
        last = amount
    end
    
    table.sort(newDictionairysTable) -- Might need to flip from < to > comparison

    return newDictionairysTable
end

--[[
    Expensive operation to generate the run order for each dependency or injectionIndex.
]]
function module:__generateRunOrder()
    local runOrderByInjectionIndex = {}
    local amountOfModuleScriptsPresentPerMS = {}

    local injectionModuleScriptAndItsInjectionIndex: { [ModuleScript]: {number} } = {}
    local moduleScriptByRunOrder = {}

    for injection, architype in injections do

        for dependOrder: number, moduleScript in readFrom(injection) do
            if injectionModuleScriptAndItsInjectionIndex[moduleScript] then
                amountOfModuleScriptsPresentPerMS[moduleScript] += 1
                table.insert(injectionModuleScriptAndItsInjectionIndex[moduleScript], injection)
            else
                amountOfModuleScriptsPresentPerMS[moduleScript] = 1
                injectionModuleScriptAndItsInjectionIndex[moduleScript] = { injection }
            end
        end
    end

    --look for all the modulescripts that do not depend on anything else
    --maybe auto inject modulescripts into scheduler too after they're all sorted?
            
    local dependencyAmountByLargest = sortDictionairyToTableAndDictionairys(amountOfModuleScriptsPresentPerMS)

    for index, dictionairy in dependencyAmountByLargest do
        
    end

    

    module.__generated = true
end

function module:runorder<U>(system: U, dependency: number): number
    return 1
end
--                             ArcheType|Run Order
--{ Player, Characer }          |   1   |   1   |
--{ Player }                    |   2   |   1   |
--{ Player, Character, Models } |   3   |   3   |
--{ Models }                    |   4   |   3   |
--{ Character }                 |   5   |   2   |



return module