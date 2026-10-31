module IngestPipeline
using CSV
using DataFrames

export load_stock_data

function load_stock_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/stock.csv"))
    return CSV.read(path, DataFrame)
end

end
