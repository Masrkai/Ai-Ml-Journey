# =====================================================================
# Project 10: Build your own Neural Network - Master Driver
# =====================================================================

include("pipeline/01_data.jl")
include("pipeline/02_network.jl")
include("pipeline/03_training.jl")
include("pipeline/04_visualization.jl")

using .DataPipeline
using .NetworkPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 10: Neural Network Pipeline")
    X, y = generate_synth_data()
    W1, b1, W2, b2 = train_mlp(X, y, 600, 0.1)
    acc = evaluate_mlp(X, y, W1, b1, W2, b2)
    save_report(acc)
    println("Project 10 Completed! Accuracy: $(round(acc*100, digits=2))%")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
