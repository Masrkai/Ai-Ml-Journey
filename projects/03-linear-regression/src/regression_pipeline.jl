# =====================================================================
# Project 03: Build your own Linear Regression in Julia
# Master Pipeline Orchestrator Driver
# =====================================================================

using LinearAlgebra
using Statistics
using Random
using Plots
using DataFrames

println("==================================================")
println(" Starting Linear Regression Pipeline Orchestration")
println("==================================================")

include("model.jl")
using .ScratchLinearRegression

include("pipeline/01_data.jl")
include("pipeline/02_ols.jl")
include("pipeline/03_gradient_descent.jl")
include("pipeline/04_visualization.jl")

println("\n==================================================")
println(" Linear Regression Pipeline Completed Successfully!")
println("==================================================")
