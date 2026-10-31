module IngestPipeline
using CSV
using DataFrames
export load_ml_data
function load_ml_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/multilingual.csv"))
    return CSV.read(path, DataFrame)
end
end
