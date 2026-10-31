# =====================================================================
# Project 17: Multi-language NLP Pipeline - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_features.jl")
include("pipeline/03_classification.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .FeaturesPipeline
using .ClassificationPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 17: Multi-language NLP Pipeline")
    df = load_ml_data()
    texts, langs = extract_features(df)
    acc = evaluate_langs(texts, langs)
    save_report(acc)
    println("Project 17 Completed! Accuracy: $(acc*100)%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
