module IngestPipeline
using CSV
using DataFrames

export load_housing_data

function load_housing_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/housing.csv"))
    println("Loading housing dataset from SSOT: $path")
    df = CSV.read(path, DataFrame)
    println("Loaded $(nrow(df)) rows and $(ncol(df)) columns.")
    return df
end

end
