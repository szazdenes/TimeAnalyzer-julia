function getDerivativeFunction(dataList, timeList)
    dataListSize = sizeof(dataList);
    derivativeList = []

    for i in 1:(dataListSize-1)
        push!(derivativeList, ((dataList[i+1] - dataList[i]) / (timeList[i+1] - timeList[i])));
    end

    derivativeList
end

function gaussianSmooth(halfKernel, sigma, dataList)
    smoothedData[]
    dataListSize = sizeof(dataList);
    for i in i:dataListSize
       for j in -halfKernel:halfKernel
           if (i+j) >= 0 && (i+j) < dataListSize
               weight = exp(-(j*j)/(2*sigma*sigma))
               sum += dataList[i+j] * weight;
           end

           if (i+j) < 0 || (i+j) >= dataListSize
               weight = 0
               sum += weight
           end

           weightSum += weight;
       end

       smoothed = sum / weightSum;
       push!(smoothedData, smoothed)
   end

   smoothedData
end
