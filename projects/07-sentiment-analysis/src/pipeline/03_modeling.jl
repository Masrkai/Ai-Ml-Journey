module ModelingPipeline
using LinearAlgebra
using Statistics

export train_logistic, evaluate_sentiment

sigmoid(z) = 1.0 ./ (1.0 .+ exp.(-clamp.(z, -500, 500)))

function train_logistic(X, y, lr=0.1, epochs=150)
    println("Training logistic regression sentiment classifier...")
    n, d = size(X)
    w = zeros(d)
    for epoch in 1:epochs
        preds = sigmoid(X * w)
        grad = (1 / n) * (X' * (preds .- y))
        w .-= lr * grad
    end
    return w
end

function evaluate_sentiment(X_test, y_test, w)
    probs = sigmoid(X_test * w)
    y_pred = Int.(probs .>= 0.5)
    acc = mean(y_pred .== y_test)
    return y_pred, acc
end

end
