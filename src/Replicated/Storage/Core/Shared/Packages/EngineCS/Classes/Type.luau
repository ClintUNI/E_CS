--!strict
local Field = require(script.Parent.Field)

return function(isA: string)
    return Field(isA:upper())
end
