# =====================================================================
# Project 01: Exploratory Data Analysis (EDA) Portfolio in Julia
# Chronological Pipeline Orchestration Engine
# =====================================================================

using DataFrames
using CSV
using HTTP
using Statistics
using LinearAlgebra
using Plots
using Random

println("==================================================")
println(" Starting Chronological EDA Portfolio Pipeline")
println("==================================================")

# Initialize global summary report container
summary_lines = String[]

# Execute chronological pipeline stages
include("pipeline/01_ingest.jl")
include("pipeline/02_audit.jl")
include("pipeline/03_diagnostics.jl")
include("pipeline/04_statistics.jl")
include("pipeline/05_inference.jl")
include("pipeline/06_dimensionality.jl")
include("pipeline/07_visualization.jl")

println("\n==================================================")
println(" EDA Portfolio Execution Completed Successfully!")
println("==================================================")
