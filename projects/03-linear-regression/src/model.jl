# =====================================================================
# From-Scratch Linear Regression Module (OLS & Gradient Descent)
# =====================================================================

module ScratchLinearRegression

using LinearAlgebra
using Statistics

export LinearRegressionModel, fit_ols!, fit_gd!, predict, mse, rmse, mae, r2_score

mutable struct LinearRegressionModel
    weights::Vector{Float64}
    bias::Float64
    is_fitted::Bool
    
    LinearRegressionModel() = new(Float64[], 0.0, false)
end

"""
    fit_ols!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64})

Fits linear regression using closed-form Ordinary Least Squares (Normal Equations).
"""
function fit_ols!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64})
    n = size(X, 1)
    # Add intercept column (ones)
    X_b = hcat(ones(n), X)
    
    # Normal equation: beta = (X^T X)^(-1) X^T y
    beta = (X_b' * X_b) \ (X_b' * y)
    
    model.bias = beta[1]
    model.weights = beta[2:end]
    model.is_fitted = true
    return model
end

"""
    fit_gd!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64}; alpha::Float64=0.01, epochs::Int=1000)

Fits linear regression using Gradient Descent optimization. Returns loss history.
"""
function fit_gd!(model::LinearRegressionModel, X::Matrix{Float64}, y::Vector{Float64}; alpha::Float64=0.01, epochs::Int=1000)
    n, p = size(X)
    model.weights = zeros(p)
    model.bias = 0.0
    
    loss_history = Float64[]
    
    for epoch in 1:epochs
        # Predictions
        y_pred = X * model.weights .+ model.bias
        errors = y_pred - y
        
        # Loss (MSE)
        cost = sum(errors .^ 2) / (2 * n)
        push!(loss_history, cost)
        
        # Gradients
        dw = (X' * errors) / n
        db = sum(errors) / n
        
        # Update parameters
        model.weights .-= alpha .* dw
        model.bias -= alpha * db
    end
    
    model.is_fitted = true
    return loss_history
end

"""
    predict(model::LinearRegressionModel, X::Matrix{Float64})

Makes predictions using the fitted linear regression model.
"""
function predict(model::LinearRegressionModel, X::Matrix{Float64})
    @assert model.is_fitted "Model must be fitted before making predictions."
    return X * model.weights .+ model.bias
end

# Metric functions
mse(y_true, y_pred) = mean((y_true .- y_pred) .^ 2)
rmse(y_true, y_pred) = sqrt(mse(y_true, y_pred))
mae(y_true, y_pred) = mean(abs.(y_true .- y_pred))

function r2_score(y_true, y_pred)
    ss_tot = sum((y_true .- mean(y_true)) .^ 2)
    ss_res = sum((y_true .- y_pred) .^ 2)
    return 1.0 - (ss_res / (ss_tot + 1e-12))
end

end # module
