module PreprocessPipeline
using DataFrames
using Random

export preprocess_digits

function preprocess_digits(df::DataFrame)
    println("Preprocessing digits data...")
    labels = df.Label .+ 1 # 1-indexed for classes (1, 2, 3)
    feature_cols = Not(:Label)
    X = Matrix(df[:, feature_cols])
    
    # Normalize features
    X = X ./ maximum(X)
    X = hcat(ones(nrow(df)), X) # add intercept

    n = nrow(df)
    train_size = round(Int, 0.8 * n)
    indices = shuffle(1:n)
    
    train_idx = indices[1:train_size]
    test_idx = indices[train_size+1:end]

    return X[train_idx, :], labels[train_idx], X[test_idx, :], labels[test_idx]
end

end
