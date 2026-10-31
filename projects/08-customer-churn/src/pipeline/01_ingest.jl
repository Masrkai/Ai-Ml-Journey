module IngestPipeline
using CSV
using DataFrames

export load_churn_data

function load_churn_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/churn.csv"))
    return CSV.read(path, DataFrame)
end

end
