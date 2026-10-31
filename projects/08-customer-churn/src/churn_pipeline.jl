# =====================================================================
# Project 08: Customer Churn Predictor - Master Driver
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
    println("Starting Project 08: Churn Predictor Pipeline")
    df = load_churn_data()
    X_train, y_train, X_test, y_test = preprocess_churn(df)
    w = train_churn_model(X_train, y_train)
    y_pred, acc = evaluate_churn(X_test, y_test, w)
    save_report(acc)
    println("Project 08 Completed! Accuracy: $(round(acc*100, digits=2))%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
