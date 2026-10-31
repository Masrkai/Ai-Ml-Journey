module ModelingPipeline
using LinearAlgebra
using Statistics

export train_ridge, evaluate_model

function train_ridge(X, y, lambda=0.1)
    println("Training Ridge Regression model (lambda=$lambda)...")
    d = size(X, 2)
    # Ridge analytical solution: w = (X'X + lambda * I)^(-1) X'y
    I_mat = lambda * Matrix{Float64}(I, d, d)
    I_mat[1, 1] = 0.0 # do not penalize intercept
    w = (X' * X + I_mat) \ (X' * y)
    return w
end

function evaluate_model(X_test, y_test, w)
    y_pred = X_test * w
    mse = mean((y_pred .- y_test).^2)
    rmse = sqrt(mse)
    mae = mean(abs.(y_pred .- y_test))
    ss_tot = sum((y_test .- mean(y_test)).^2)
    ss_res = sum((y_test .- y_pred).^2)
    r2 = 1.0 - (ss_res / ss_tot)
    return y_pred, rmse, mae, r2
end

end
