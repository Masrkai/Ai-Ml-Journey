module ModelingPipeline
using LinearAlgebra
using Statistics

export train_autoreg, evaluate_stock

function train_autoreg(X, y)
    return (X' * X) \ (X' * y)
end

function evaluate_stock(X_test, y_test, w)
    y_pred = X_test * w
    rmse = sqrt(mean((y_pred .- y_test).^2))
    return y_pred, rmse
end

end
