module IngestPipeline
using CSV
using DataFrames

export load_digits_data

function load_digits_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/digits.csv"))
    println("Loading digits dataset from SSOT: $path")
    df = CSV.read(path, DataFrame)
    println("Loaded $(nrow(df)) rows and $(ncol(df)) columns.")
    return df
end

end
