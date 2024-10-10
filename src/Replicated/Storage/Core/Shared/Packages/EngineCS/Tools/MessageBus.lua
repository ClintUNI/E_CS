local bus = {}

local busData = {}

local busNamesAndTheirIndex = {}

function bus.new(name: string)
    if busNamesAndTheirIndex[name] then
        return busNamesAndTheirIndex[name]
    else
        table.insert(busData, {})
        busNamesAndTheirIndex[name] = #busData
        busData[#busData] = {}

        return #busData
    end
end

function bus.queue(bus: number, queueTableOrDictionary): ()
    if assert(busData[bus] ~= nil, "Cannot queue to a message bus that does not exist.") then
        table.insert(busData[bus], queueTableOrDictionary)
    end
end

function bus.read(bus: number): { [number]: {[any]: any} }
    return busData[bus]
end

function bus.consume(bus: number, startIndex: number?, endIndex: number?): ()
    if assert(busData[bus], "Cannot consume a message bus that does not exist.") then
        if not startIndex then
            table.clear(busData[bus])
        elseif not endIndex then
            for i = #busData[bus], startIndex, -1 do
                table.remove(busData[bus], i)
            end
        else
            for i = endIndex, startIndex, -1 do
                table.remove(busData[bus], i)
            end
        end
    end
end

return bus