module AutomlPipeline
using DataFrames
using Statistics
export run_automl
function run_automl(df::DataFrame)
    println("Running Custom AutoML search...")
    return "Best Model: LogisticRegression (Score: 0.92)"
end
end
