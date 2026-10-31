module PreprocessPipeline
using DataFrames
using Statistics

export preprocess_data

function preprocess_data(df::DataFrame)
    println("Preprocessing housing data...")
    # Features: SqFt, Bedrooms, Bathrooms, Age; Target: Price
    X_raw = Matrix(df[:, [:SqFt, :Bedrooms, :Bathrooms, :Age]])
    y = df.Price

    # Standardize features (mean 0, std 1)
    μ = mean(X_raw, dims=1)
    σ = std(X_raw, dims=1)
    σ[σ .== 0] .= 1.0 # avoid division by zero
    X = (X_raw .- μ) ./ σ

    # Add intercept column
    X_design = hcat(ones(nrow(df)), X)

    # Train/test split (80/20)
    n = nrow(df)
    train_size = round(Int, 0.8 * n)
    indices = randperm(n)
    
    train_idx = indices[1:train_size]
    test_idx = indices[train_size+1:end]

    return X_design[train_idx, :], y[train_idx], X_design[test_idx, :], y[test_idx]
end

# simple randperm helper if Random not loaded in module
function randperm(n::Int)
    return shuffle(1:n)
end

using Random

end
