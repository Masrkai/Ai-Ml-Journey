module IngestPipeline
using CSV
using DataFrames
export load_ab_data
function load_ab_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/ab_test.csv"))
    return CSV.read(path, DataFrame)
end
end
