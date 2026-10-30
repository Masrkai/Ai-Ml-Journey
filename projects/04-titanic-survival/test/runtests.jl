# =====================================================================
# Unit & Integration Tests for Project 04: Titanic Survival Prediction
# =====================================================================

using Test
using DataFrames
using CSV
using Statistics
using Random

@testset "Titanic Survival Prediction Tests" begin
    dataset_path = "datasets/titanic.csv"
    @test isfile(dataset_path)
    df = CSV.read(dataset_path, DataFrame)
    @test size(df, 1) > 0
    @test "Survived" in names(df)
    @test "Pclass" in names(df)

    # Test preprocessing integrity
    df_clean = dropmissing(select(df, [:Survived, :Pclass, :Age, :Sex]), [:Survived])
    @test size(df_clean, 1) > 0

    # Test survival rate bounds
    survival_rate = mean(df_clean.Survived)
    @test 0.0 <= survival_rate <= 1.0
end
