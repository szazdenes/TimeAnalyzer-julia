include("Functions.jl")

file = open("/home/denes/Documents/Drem/pH_mero/TimeAnalyzer/data/beallas_pH5-6_PI7.csv")
line = readline(file)
line = readline(file)
if occursin(";", line)
    replace!(line, "," => ".")
    replace!(line, ";" => ",")
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
