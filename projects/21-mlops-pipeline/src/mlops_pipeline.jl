# =====================================================================
# Project 21: MLOps Pipeline - Master Driver
# =====================================================================

include("pipeline/01_registry.jl")
include("pipeline/02_validation.jl")
include("pipeline/03_artifacts.jl")
include("pipeline/04_visualization.jl")

using .RegistryPipeline
using .ValidationPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 21: MLOps Pipeline")
    metrics = Dict("accuracy" => 0.92)
    register_model("HousingPredictor", "1.0", metrics)
    valid = validate_model(metrics, 0.85)
    save_report(valid)
    println("Project 21 Completed! Model Validated: $valid")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
