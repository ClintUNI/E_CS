--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JECS = require(ReplicatedStorage.Core.Shared.Packages.JECS)

export type World = JECS.World

export type Component = JECS.Entity
export type ComponentWithType<T> = JECS.Entity<T>

export type Entity = JECS.Entity

export type Tuple<A, B> = typeof(table.unpack({} :: { [number]: A | B }))

export type Yields<T> = T & { _yielding_type_notation_do_not_use: nil }

export type Hook = {
    _: {
        SetCommands: { { Key: string, NewValue: any } },
        Listeners: { [string]: { [number]: (any) -> () } }
    },

    set: (self: typeof(setmetatable({} :: Hook, {})), key: string, newValue: any) -> (),

    listen: (key: string, callback: (lastValue: any, newValue: any) -> ()) -> ({
        disconnect: () -> ()
    })

}

export type MessageBusQueue<Key, Value> = { [Key]: Value }

export type MessageBus = {
    new: (name: string) -> (number),
    queue: <U...>(bus: number, U...) -> (),

    read: (bus: number, index: number?) -> ( { [number]: { [any]: any } } ),
    
    consume: (bus: number, startIndex: number?, endIndex: number?) -> ()
}

export type Middleware = <a>(a?) -> boolean

return {}