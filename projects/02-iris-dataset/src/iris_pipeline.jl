# =====================================================================
# Project 02: Iris Dataset Analysis & Classification Pipeline in Julia
# Master Pipeline Orchestrator Driver
# =====================================================================

using DataFrames
using CSV
using Statistics
using LinearAlgebra
using Plots
using Random

println("==================================================")
println(" Starting Iris Dataset Pipeline Orchestration")
println("==================================================")

include("pipeline/01_ingest.jl")
include("pipeline/02_statistics.jl")
include("pipeline/03_modeling.jl")
include("pipeline/04_visualization.jl")

println("\n==================================================")
println(" Iris Dataset Pipeline Completed Successfully!")
println("==================================================")
