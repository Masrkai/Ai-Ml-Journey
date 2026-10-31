# =====================================================================
# Project 05: Housing Price Predictor - Master Pipeline Driver
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
    println("Starting Project 05: Housing Price Predictor Pipeline")
    df = load_housing_data()
    X_train, y_train, X_test, y_test = preprocess_data(df)
    w = train_ridge(X_train, y_train, 0.1)
    y_pred, rmse, mae, r2 = evaluate_model(X_test, y_test, w)
    generate_visualizations(y_test, y_pred, w)
    save_report(rmse, mae, r2, w)
    println("Project 05 Pipeline Completed Successfully!")
    println("RMSE: $rmse, R^2: $r2")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
