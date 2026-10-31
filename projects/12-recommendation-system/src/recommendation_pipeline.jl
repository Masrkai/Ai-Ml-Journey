# =====================================================================
# Project 12: Recommendation System - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_factorization.jl")
include("pipeline/03_evaluation.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .FactorizationPipeline
using .EvaluationPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 12: Recommendation System Pipeline")
    df = load_ratings_data()
    R, R_approx = factorize_ratings(df, 3)
    rmse = evaluate_recommender(R, R_approx)
    save_report(rmse)
    println("Project 12 Completed! RMSE: $rmse")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
