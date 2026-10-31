using Test

include("../src/pipeline/01_ingest.jl")
include("../src/pipeline/02_preprocess.jl")
include("../src/pipeline/03_modeling.jl")

using .IngestPipeline
using .PreprocessPipeline
using .ModelingPipeline

@testset "Housing Price Predictor Tests" begin
    df = load_housing_data()
    @test nrow(df) > 0
    X_train, y_train, X_test, y_test = preprocess_data(df)
    @test size(X_train, 1) > 0
    w = train_ridge(X_train, y_train)
    @test length(w) == 5 # Intercept + 4 features
    y_pred, rmse, mae, r2 = evaluate_model(X_test, y_test, w)
    @test rmse >= 0.0
end
