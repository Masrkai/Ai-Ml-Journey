module IngestPipeline
using CSV
using DataFrames

export load_sentiment_data

function load_sentiment_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/sentiment.csv"))
    println("Loading sentiment dataset: $path")
    df = CSV.read(path, DataFrame)
    return df
end

end
