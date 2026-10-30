# =====================================================================
# Unit & Integration Tests for Project 03: Linear Regression
# =====================================================================

using Test
using Random
using LinearAlgebra
using Statistics

include("../src/model.jl")
using .ScratchLinearRegression

@testset "From-Scratch Linear Regression Tests" begin
    Random.seed!(42)
    n = 100
    p = 2
    X = randn(n, p)
    true_w = [2.5, -1.5]
    true_b = 3.0
    y = X * true_w .+ true_b .+ 0.1 * randn(n)

    # Test 1: OLS Fitting
    model_ols = LinearRegressionModel()
    fit_ols!(model_ols, X, y)
    @test model_ols.is_fitted == true
    @test isapprox(model_ols.bias, true_b, atol=0.1)
    @test isapprox(model_ols.weights, true_w, atol=0.1)

    # Test 2: Predictions & Metrics
    y_pred = predict(model_ols, X)
    @test length(y_pred) == n
    @test r2_score(y, y_pred) > 0.95
    @test mse(y, y_pred) < 0.05

    # Test 3: Gradient Descent Fitting
    model_gd = LinearRegressionModel()
    X_scaled = (X .- mean(X, dims=1)) ./ std(X, dims=1)
    loss_hist = fit_gd!(model_gd, X_scaled, y, alpha=0.1, epochs=300)
    @test model_gd.is_fitted == true
    @test loss_hist[end] < loss_hist[1] # Loss decreases
    @test r2_score(y, predict(model_gd, X_scaled)) > 0.90
end
