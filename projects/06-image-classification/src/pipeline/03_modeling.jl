module ModelingPipeline
using LinearAlgebra
using Statistics

export train_softmax, evaluate_classifier

function softmax(z)
    exp_z = exp.(z .- maximum(z, dims=2))
    return exp_z ./ sum(exp_z, dims=2)
end

function train_softmax(X, y, num_classes=3, lr=0.1, epochs=100)
    println("Training Softmax Regression classifier...")
    n, d = size(X)
    W = zeros(d, num_classes)
    
    # One-hot encode y
    Y_onehot = zeros(n, num_classes)
    for i in 1:n
        Y_onehot[i, y[i]] = 1.0
    end

    for epoch in 1:epochs
        scores = X * W
        probs = softmax(scores)
        grad = (1 / n) * (X' * (probs .- Y_onehot))
        W .-= lr * grad
    end
    return W
end

function evaluate_classifier(X_test, y_test, W)
    scores = X_test * W
    probs = softmax(scores)
    y_pred = argmax(probs, dims=2)
    y_pred_idx = [i[2] for i in y_pred]
    
    acc = mean(y_pred_idx .== y_test)
    return y_pred_idx, acc
end

end
