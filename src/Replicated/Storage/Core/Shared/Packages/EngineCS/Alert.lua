--!strict
return {

    Unstable = function(keyword: string)
        warn("\n", "Warning | " .. keyword .. " is an unstable feature and may not work or even break!")
    end

}