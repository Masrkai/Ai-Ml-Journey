# =====================================================================
# Project 06: Image Classification System - Master Pipeline Driver
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
    println("Starting Project 06: Image Classification Pipeline")
    df = load_digits_data()
    X_train, y_train, X_test, y_test = preprocess_digits(df)
    W = train_softmax(X_train, y_train, 3, 0.1, 200)
    y_pred, acc = evaluate_classifier(X_test, y_test, W)
    generate_visualizations(y_test, y_pred)
    save_report(acc)
    println("Project 06 Pipeline Completed Successfully! Accuracy: $(round(acc*100, digits=2))%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
