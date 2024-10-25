local bus = {}

local busData: { [ Queue<any | number> ]: any } = {}

local busNamesAndTheirIndex = {}

export type Queue<T = nil> = T

function bus.new<value>(name: string): Queue<value | number>
    if busNamesAndTheirIndex[name] then
        return busNamesAndTheirIndex[name]
    else
        table.insert(busData, {})
        busNamesAndTheirIndex[name] = #busData

        return #busData
    end
end

function bus.type<QueueValue>(): number & QueueValue
    return 1 :: number & QueueValue
end

function bus.queue<T, E>(queue: Queue<T>, queueEntry: E): ()
    if assert(busData[queue] ~= nil, "Cannot queue to a message bus that does not exist.") then
        table.insert(busData[queue], queueEntry)
    end
end

function bus.read<T>(queue: T): { [number]: any }
    return busData[queue]
end

function bus.consume<T>(queue: T, startIndex: number?, endIndex: number?): ()
    if assert(busData[queue], "Cannot consume a message bus that does not exist.") then
        if not startIndex then
            table.clear(busData[queue])
        elseif not endIndex then
            for i = #busData[queue], startIndex, -1 do
                table.remove(busData[queue], i)
            end
        else
            for i = endIndex, startIndex, -1 do
                table.remove(busData[queue], i)
            end
        end
    end
end

return bus