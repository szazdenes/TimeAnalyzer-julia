include("Functions.jl")

# using Pkg
# Pkg.add("Plots")
using Plots

file = open("/home/denes/Documents/Drem/pH_mero/TimeAnalyzer/data/beallas_pH5-6_PI7.csv")
line = readline(file)
line = readline(file)
if occursin(";", line)
    replace!(line, "," , ".")
    replace!(line, ";", ",")
end

lineList = split(line, ",")
timeInterval = parse(Float64, lineList[3])

dataList = []
timeList = []

push!(timeList, timeInterval)
push!(dataList, parse(Float64, lineList[5]))

counter = 1

for line in eachline(file)
    global counter
    global timeInterval
    global timeList
    global dataList
    counter += 1
    if counter % 500 == 0
        if occursin(";", line)
            replace!(line, "," => ".")
            replace!(line, ";" => ",")
        end
        lineList = split(line, ",")
        dataValue = parse(Float64, lineList[5])
        push!(timeList, (counter*timeInterval))
        push!(dataList, dataValue)
    end
end

close(file)

smoothedValueList = gaussianSmooth(100,30,dataList)
doubleSmoothedValueList = gaussianSmooth(500,1000,smoothedValueList)
derivativeList = getDerivativeFunction(doubleSmoothedValueList, timeList)
smoothedDerivativeList = gaussianSmooth(2000, 2000, derivativeList)

setinTimeSec = calculateSetinTime(smoothedDerivativeList, timeList, 7000)
setinTimeMin = setinTimeSec / 60

p1 = plot(timeList, dataList, ylims = (-0.02, 0.06), color = "grey", linewidth = 1.0, xlabel = "time (s)", ylabel = "value (V)", label = "original")
plot!(timeList, smoothedValueList, color = "blue", label = "smoothed")
plot!(timeList, doubleSmoothedValueList, color = "red", label = "doublesmoothed")

timeListLength = length(timeList)
zeroList = zeros(timeListLength - 1)

deleteat!(timeList, timeListLength)

p2 = plot(timeList, derivativeList, color = "blue", linewidth = 1.0, xlabel = "time (s)", ylabel = "derivatives", label = "derivatives")
plot!(timeList, smoothedDerivativeList, color = "red", linewidth = 1.0, label = "smoothed derivatives")
plot!(timeList, zeroList, color = "black", linewidth = 1.0, label = "reference zero")

display(p1)
display(p2)
