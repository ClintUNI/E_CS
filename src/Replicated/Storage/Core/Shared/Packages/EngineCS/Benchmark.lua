local benchmark = {}

local oS: typeof(os) = os

type TestedTimes = { [string]: {{ EndTime: number, StartTime: number }} }

local roundToTenThousandths = function(amount: number): number
    return math.floor(amount * 10000 + 0.5) / 10000
end

local timeToFrameFraction = function(amount: number): string
    local frameDuration: number = 1 / 60

    local frames: number = roundToTenThousandths(amount / frameDuration)

    return frames .. "th"
end

local getNumberOfZeros = function(amount: number): number
        local amountAsString: string = tostring(amount)
    
        local decimalPointPosition: number? = string.find(amountAsString, "%.")
        
        if amount >= 1 or not decimalPointPosition then
            return 0
        end
    
        local zeroCount: number = 0
    
        for i = decimalPointPosition + 1, #amountAsString do
            local char: string = string.sub(amountAsString, i, i)
            if char == "0" then
                zeroCount = zeroCount + 1
            else
                return zeroCount
            end
        end
    
        return zeroCount
end

function benchmark.open()
    local clock: () -> number = oS.clock
    local startTime: number;

    local tt: TestedTimes = {}

    return {
        start = function()
            startTime = clock()
        end,

        --[[
            Paired with benchmark.open()'s start() method.
        ]]
        log = function()
            local t = clock()
            print(t - startTime)
        end,

        --[[
            Paired with benchmark.open()'s results() method.
        ]]
        test = function(testData: { Name: string, Callback: () -> () }, ...)
            (tt :: TestedTimes)[testData.Name] = {}

            for i = 1, 500 do
                local t = clock()
                testData.Callback(...)
                local e = clock()

                table.insert((tt :: TestedTimes)[testData.Name], { StartTime = t, EndTime = e })
            end
        end,

                --[[
            Paired with benchmark.open()'s test() method.
        ]]
        results = function()
            warn("Benchmark Tests Results")
            for name: string, testedTimesData: {{ EndTime: number, StartTime: number }} in tt :: TestedTimes do
                print("Test Name: " .. name)
                print("=------------:------------->")

                local maxTime = 0
                local minTime = math.huge
                local avgTime = 0
                local totalTests = #testedTimesData

                for _, testData in testedTimesData do
                    local s = testData.StartTime
                    local e = testData.EndTime

                    local difference = e - s

                    if maxTime < difference then
                        maxTime = difference
                    end

                    if minTime > difference then
                        minTime = difference
                    end

                    avgTime += difference
                end

                avgTime /= totalTests

                print("AvgTime |", 
                    tostring(avgTime), 
                    "| ", 
                    tostring(getNumberOfZeros(avgTime)) .. " zeros.",
                    "| ",
                    timeToFrameFraction(avgTime) .. " of a frame @ 60FPS."
                )
                print("MaxTime |", 
                    tostring(maxTime), 
                    "| ", 
                    tostring(getNumberOfZeros(maxTime)) .. " zeros.",
                    "| ",
                    timeToFrameFraction(maxTime) .. " of a frame @ 60FPS."
                )

                print("MinTime  |", 
                    tostring(minTime), 
                    "| ", 
                    tostring(getNumberOfZeros(minTime)) .. " zeros.",
                    "| ",
                    timeToFrameFraction(minTime) .. " of a frame @ 60FPS."
                )

                print("Total tests: " .. tostring(totalTests))

                print("<------------:-------------=")
            end
        end,

        close = function()
            startTime = 0
            tt = {} :: TestedTimes
        end,
    }
end


return benchmark