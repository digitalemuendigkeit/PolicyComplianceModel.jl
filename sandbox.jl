using DataFrames
using CSV

df = CSV.read(joinpath("data", "uk_structure", "uk_structure.csv"); delim=";")

print(first(df, 100))

collect(df["Population"])

populations = [parse(Int64, replace(df["Population"][i], "," => "")) for i in 1:size(df)[1]]

populations = DataFrame("Populations" => populations)

CSV.write(joinpath("data", "uk_structure", "populations_metro_areas.csv"), populations)
