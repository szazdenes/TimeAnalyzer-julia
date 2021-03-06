function getDerivativeFunction(dataList, timeList)
    dataListSize = length(dataList)
    local derivativeList = []

    for i in 1:(dataListSize-1)
        push!(derivativeList, ((dataList[i+1] - dataList[i]) / (timeList[i+1] - timeList[i])))
    end

    derivativeList
end

function gaussianSmooth(halfKernel, sigma, dataList)
    local smoothedData = []
    local sum = 0
    local weight = 0
    local weightSum = 0
    dataListSize = length(dataList)
    for i in 1:dataListSize
       for j in -halfKernel:halfKernel
           if (i+j) >= 1 && (i+j) <= dataListSize
               weight = exp(-(j*j)/(2*sigma*sigma))
               sum += dataList[i+j] * weight
           end

           if (i+j) < 1 || (i+j) > dataListSize
               weight = 0
               sum += weight
           end

           weightSum += weight
       end

       smoothed = sum / weightSum
       push!(smoothedData, smoothed)
   end

   smoothedData
end

function calculateSetinTime(dataList, timeList, startingTime)
    local setinTime = 0
    local timeListLength = length(timeList)
    local time = 0
    for i in 1:(timeListLength-1)
        time = timeList[i]
        if time > startingTime && abs(dataList[i] < 0.00000001)
            setinTime = time
            return setinTime
        end
    end
    setinTime
end
