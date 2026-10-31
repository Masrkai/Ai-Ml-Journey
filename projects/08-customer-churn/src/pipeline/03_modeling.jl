module ModelingPipeline
using LinearAlgebra
using Statistics

export train_churn_model, evaluate_churn

sigmoid(z) = 1.0 ./ (1.0 .+ exp.(-clamp.(z, -500, 500)))

function train_churn_model(X, y, lr=0.1, epochs=150)
    n, d = size(X)
    w = zeros(d)
    for epoch in 1:epochs
        preds = sigmoid(X * w)
        grad = (1 / n) * (X' * (preds .- y))
        w .-= lr * grad
    end
    return w
end

function evaluate_churn(X_test, y_test, w)
    probs = sigmoid(X_test * w)
    y_pred = Int.(probs .>= 0.5)
    acc = mean(y_pred .== y_test)
    return y_pred, acc
end

end
