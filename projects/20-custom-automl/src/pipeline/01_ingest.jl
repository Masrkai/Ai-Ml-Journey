module IngestPipeline
using CSV
using DataFrames
export load_automl_data
function load_automl_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/automl_data.csv"))
    return CSV.read(path, DataFrame)
end
end
