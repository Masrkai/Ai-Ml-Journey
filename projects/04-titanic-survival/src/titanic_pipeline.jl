# =====================================================================
# Project 04: Titanic Survival Prediction in Julia
# Master Pipeline Orchestrator Driver
# =====================================================================

using DataFrames
using CSV
using Statistics
using Random
using Plots
using LinearAlgebra

println("==================================================")
println(" Starting Titanic Survival Prediction Pipeline")
println("==================================================")

include("pipeline/01_ingest.jl")
include("pipeline/02_preprocess.jl")
include("pipeline/03_modeling.jl")
include("pipeline/04_visualization.jl")

println("\n==================================================")
println(" Titanic Survival Prediction Pipeline Completed!")
println("==================================================")
