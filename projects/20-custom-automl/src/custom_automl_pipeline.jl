# =====================================================================
# Project 20: Build Your own AutoML - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_automl.jl")
include("pipeline/03_evaluation.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .AutomlPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 20: Custom AutoML Pipeline")
    df = load_automl_data()
    res = run_automl(df)
    save_report(res)
    println("Project 20 Completed! $res")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
