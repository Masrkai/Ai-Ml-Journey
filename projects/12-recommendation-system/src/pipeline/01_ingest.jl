module IngestPipeline
using CSV
using DataFrames

export load_ratings_data

function load_ratings_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/ratings.csv"))
    return CSV.read(path, DataFrame)
end

end
