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

push!(dataList, parse(Float64, lineList[5]))

counter = 0

for line in eachline(file)
    global counter
    global timeInterval
    global timeList
    global dataList
    counter = counter + 1
    if counter % 1 == 0
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
