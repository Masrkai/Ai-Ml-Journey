# =====================================================================
# Project 22: Distributed ML System - Master Driver
# =====================================================================

include("pipeline/01_parallel.jl")
include("pipeline/02_training.jl")
include("pipeline/03_aggregation.jl")
include("pipeline/04_visualization.jl")

using .ParallelPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 22: Distributed ML Pipeline")
    val = parallel_compute(100000)
    save_report(val)
    println("Project 22 Completed! Result: $val")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
