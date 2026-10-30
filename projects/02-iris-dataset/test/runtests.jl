# =====================================================================
# Unit & Integration Tests for Project 02: Iris Dataset Pipeline
# =====================================================================

using Test
using DataFrames
using CSV
using Statistics
using LinearAlgebra
using Random

@testset "Iris Dataset Pipeline Tests" begin
    # Test 1: Ingestion
    dataset_path = "datasets/iris.csv"
    @test isfile(dataset_path)
    df = CSV.read(dataset_path, DataFrame)
    @test size(df, 1) == 150
    @test size(df, 2) == 5
    @test "species" in names(df)

    # Test 2: Summary Statistics
    numeric_cols = filter(c -> eltype(df[!, c]) <: Number, names(df))
    @test length(numeric_cols) == 4
    for col in Symbol.(numeric_cols)
        vals = df[!, col]
        @test mean(vals) > 0.0
        @test std(vals) > 0.0
    end

    # Test 3: PCA Variance
    X = Matrix{Float64}(df[!, Symbol.(numeric_cols)])
    X_scaled = (X .- mean(X, dims=1)) ./ std(X, dims=1)
    C = cov(X_scaled)
    F = eigen(C)
    ev_ratio = sort(F.values, rev=true) ./ sum(F.values)
    @test ev_ratio[1] > 0.7  # PC1 captures majority of variance

    # Test 4: Classification Baseline Accuracy
    Random.seed!(42)
    n = size(X, 1)
    perm = randperm(n)
    train_idx = perm[1:120]
    test_idx = perm[121:end]
    X_train, y_train = X_scaled[train_idx, :], df.species[train_idx]
    X_test, y_test = X_scaled[test_idx, :], df.species[test_idx]

    correct = 0
    for i in 1:length(test_idx)
        dists = [norm(X_test[i, :] - X_train[j, :]) for j in 1:size(X_train, 1)]
        if y_train[argmin(dists)] == y_test[i]
            correct += 1
        end
    end
    acc = correct / length(test_idx)
    @test acc >= 0.85 # At least 85% accuracy on Iris test split
end
