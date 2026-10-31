# =====================================================================
# Project 16: Image Generation System - Master Driver
# =====================================================================

include("pipeline/01_model.jl")
include("pipeline/02_generation.jl")
include("pipeline/03_evaluation.jl")
include("pipeline/04_visualization.jl")

using .ModelPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 16: Image Generation Pipeline")
    grid = generate_pattern(32, 10)
    save_report(grid)
    println("Project 16 Completed!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
