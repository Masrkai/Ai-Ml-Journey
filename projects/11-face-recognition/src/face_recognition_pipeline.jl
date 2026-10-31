# =====================================================================
# Project 11: Face Recognition System - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_pca.jl")
include("pipeline/03_classification.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .PcaPipeline
using .ClassificationPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 11: Face Recognition Pipeline")
    df = load_face_data()
    X_proj, labels, W, mean_face = compute_eigenfaces(df, 5)
    acc = evaluate_faces(X_proj, labels)
    save_report(acc)
    println("Project 11 Completed! Accuracy: $(round(acc*100, digits=2))%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
