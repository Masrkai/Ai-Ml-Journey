module IngestPipeline
using CSV
using DataFrames
export load_fraud_data
function load_fraud_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/transactions.csv"))
    return CSV.read(path, DataFrame)
end
end
