# =====================================================================
# Project 15: A/B Testing Framework - Master Driver
# =====================================================================

include("pipeline/01_ingest.jl")
include("pipeline/02_hypothesis.jl")
include("pipeline/03_power.jl")
include("pipeline/04_visualization.jl")

using .IngestPipeline
using .HypothesisPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 15: A/B Testing Pipeline")
    df = load_ab_data()
    p_c, p_t, z = run_ab_test(df)
    save_report(p_c, p_t, z)
    println("Project 15 Completed! Z-Stat: $z")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
