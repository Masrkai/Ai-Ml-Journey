# =====================================================================
# Project 09: Stock Price Predictor - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_preprocess.jl")
include("pipeline/03_modeling.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .PreprocessPipeline
using .ModelingPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 09: Stock Predictor Pipeline")
    df = load_stock_data()
    X_train, y_train, X_test, y_test = create_lag_features(df)
    w = train_autoreg(X_train, y_train)
    y_pred, rmse = evaluate_stock(X_test, y_test, w)
    save_report(rmse)
    println("Project 09 Completed! Test RMSE: $rmse")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
