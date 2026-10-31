# =====================================================================
# Project 18: Reinforcement Learning AI Game - Master Driver
# =====================================================================

include("pipeline/01_env.jl")
include("pipeline/02_agent.jl")
include("pipeline/03_training.jl")
include("pipeline/04_visualization.jl")

using .EnvPipeline
using .AgentPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 18: RL Game Pipeline")
    rew = train_q_learning(500)
    save_report(rew)
    println("Project 18 Completed! Total Reward: $rew")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
