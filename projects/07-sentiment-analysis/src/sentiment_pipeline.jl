# =====================================================================
# Project 07: Sentiment Analysis System - Master Driver
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
    println("Starting Project 07: Sentiment Analysis Pipeline")
    df = load_sentiment_data()
    X_train, y_train, X_test, y_test = vectorize_text(df)
    w = train_logistic(X_train, y_train, 0.1, 150)
    y_pred, acc = evaluate_sentiment(X_test, y_test, w)
    save_report(acc)
    println("Project 07 Completed! Accuracy: $(round(acc*100, digits=2))%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
