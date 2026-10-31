# =====================================================================
# Project 19: Real Time Fraud Detection System - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_preprocess.jl")
include("pipeline/03_detection.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .PreprocessPipeline
using .DetectionPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 19: Fraud Detection Pipeline")
    df = load_fraud_data()
    amount, distance, true_fraud = preprocess_fraud(df)
    acc = detect_anomalies(amount, distance, true_fraud)
    save_report(acc)
    println("Project 19 Completed! Accuracy: $(acc*100)%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
