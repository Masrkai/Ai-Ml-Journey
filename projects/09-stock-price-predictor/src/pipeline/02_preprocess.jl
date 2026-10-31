module PreprocessPipeline
using DataFrames
using Statistics

export create_lag_features

function create_lag_features(df::DataFrame)
    println("Creating time-series lag features...")
    prices = df.Close
    n = length(prices)
    
    # Create lag 1, 2 features
    X = hcat(ones(n-2), prices[2:n-1], prices[1:n-2])
    y = prices[3:n]

    train_size = round(Int, 0.8 * length(y))
    return X[1:train_size, :], y[1:train_size], X[train_size+1:end, :], y[train_size+1:end]
end

end
