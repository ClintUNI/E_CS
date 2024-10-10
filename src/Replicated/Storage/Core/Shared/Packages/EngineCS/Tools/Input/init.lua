--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Settings = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Settings)
local Hooks = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.Hooks)
local MessageBus = require(ReplicatedStorage.Core.Shared.Packages.EngineCS.Tools.MessageBus)
local ActionManager = require(script.ActionManager)

local InputQueue = MessageBus.new("InputActions")

local bind;--: typeof(ActionManager.bindAction);
local unbind: typeof(ActionManager.unbindAction);

if Settings.Game.IsServer then
    bind = function(actionName: string, keyboardAndMouseInput: Enum.KeyCode | Enum.UserInputType, gamepadInput: Enum.KeyCode | Enum.UserInputType, displayOrder: number?)
        
        --network to client that we want to start recieving input for a certain key, or specifiy to request once
    end

    unbind = function()
        
    end
else
    -- bind = function(actionName: string, callback: (string, Enum.UserInputState, InputObject) -> (...any), keyboardAndMouseInput: Enum.KeyCode | Enum.UserInputType, gamepadInput: Enum.KeyCode | Enum.UserInputType)
    --     ActionManager.bindAction(
    --         actionName, 
    --         function(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): ...any
    --             MessageBus:queue(InputQueue, { ActionName = actionName, InputState = inputState, InputObject = inputObject,  Callback = callback}) 
    --         end, 
    --         keyboardAndMouseInput, 
    --         gamepadInput
    --     )
    -- end

    bind = function(actionName: string, keyboardAndMouseInput: Enum.KeyCode | Enum.UserInputType, gamepadInput: Enum.KeyCode | Enum.UserInputType, displayOrder: number?)
        ActionManager.bindAction(
            actionName, 
            function(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): ...any
                Hooks:set(actionName, { State = inputState, Object = inputObject, Time = os.clock() })
            end,
            keyboardAndMouseInput, 
            gamepadInput,
            displayOrder
        )
    end

    unbind = ActionManager.unbindAction
end

--[[
    ```lua
        Hooks.listen("Test", function(lastValue, newValue)
            if Input.BootUpHookEvent(lastValue, newValue) then return end

            if newValue.State == Enum.UserInputState.Begin then
                print("Q key was pressed")
            else
                print("Q key was released | WOO")
            end
        end)

        Input.Bind("Test", Enum.KeyCode.Q, Enum.UserInputType.Gamepad3)
    ```
]]
return {
    Bind = bind,
    Unbind = unbind,

    BootUpHookEvent = function(lastValue, newValue): boolean
        if lastValue == nil or (lastValue.State == Enum.UserInputState.Cancel and newValue.State == Enum.UserInputState.Cancel) then return true end
        return false
    end
}