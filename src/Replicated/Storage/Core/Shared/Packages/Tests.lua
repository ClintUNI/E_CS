--!strict
local module = {}

local function average(haystack: {number}): number
	local a = 0
	for _, value in haystack do
		a += value
	end
	
	return a / #haystack
end

type Float = number
function module:GetDecimalPlace(t: Float): number
	local x = 1

	for i = 1, 8 do
		if t >= (1 / x) then
			return x
		end
		x *= 10
	end

    return 0
end

function module.clock(testIterations: number, callback: (any?) -> (), value: any?)
    local as = table.create(testIterations)

    for index = 1, testIterations do
        local s = os.clock()

        callback(value)

        local e = os.clock()

        local speed = e - s

        as[index] = speed
    end

    local avg = average(as)

    print("|-------|", avg, ", this is", module:GetDecimalPlace(avg)," decimals. |-------| \n ")

    return avg
end

return module