module PreprocessPipeline
using DataFrames
using Statistics
using Random

export preprocess_churn

function preprocess_churn(df::DataFrame)
    println("Preprocessing churn data...")
    tenure = df.Tenure
    mc = df.MonthlyCharges
    tc = df.TotalCharges
    contract_onehot = [df.Contract .== c for c in unique(df.Contract)]
    
    X_raw = hcat(tenure, mc, tc, hcat(contract_onehot...))
    y = df.Churn

    μ = mean(X_raw, dims=1)
    σ = std(X_raw, dims=1)
    σ[σ .== 0] .= 1.0
    X = (X_raw .- μ) ./ σ
    X = hcat(ones(nrow(df)), X)

    n = nrow(df)
    indices = shuffle(1:n)
    train_size = round(Int, 0.8 * n)
    return X[indices[1:train_size], :], y[indices[1:train_size]], X[indices[train_size+1:end], :], y[indices[train_size+1:end]]
end

end
