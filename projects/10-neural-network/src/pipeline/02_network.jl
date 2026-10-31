module NetworkPipeline
using LinearAlgebra
using Statistics

export init_network, train_mlp, evaluate_mlp

relu(x) = max.(0.0, x)
relu_deriv(x) = x .> 0.0 ? 1.0 : 0.0

sigmoid(z) = 1.0 ./ (1.0 .+ exp.(-clamp.(z, -500, 500)))

function init_network(input_dim, hidden_dim)
    W1 = randn(input_dim, hidden_dim) .* 0.1
    b1 = zeros(1, hidden_dim)
    W2 = randn(hidden_dim, 1) .* 0.1
    b2 = zeros(1, 1)
    return W1, b1, W2, b2
end

function train_mlp(X, y, epochs=500, lr=0.05)
    n, d = size(X)
    W1, b1, W2, b2 = init_network(d, 8)
    y_mat = reshape(Float64.(y), n, 1)

    for epoch in 1:epochs
        # Forward pass
        Z1 = X * W1 .+ b1
        A1 = max.(0.0, Z1)
        Z2 = A1 * W2 .+ b2
        A2 = sigmoid(Z2)

        # Backward pass
        error = A2 .- y_mat
        dZ2 = error .* (A2 .* (1.0 .- A2))
        dW2 = A1' * dZ2 / n
        db2 = sum(dZ2, dims=1) / n

        dZ1 = (dZ2 * W2') .* (Z1 .> 0.0)
        dW1 = X' * dZ1 / n
        db1 = sum(dZ1, dims=1) / n

        # Update weights
        W1 .-= lr * dW1
        b1 .-= lr * db1
        W2 .-= lr * dW2
        b2 .-= lr * db2
    end
    return W1, b1, W2, b2
end

function evaluate_mlp(X, y, W1, b1, W2, b2)
    Z1 = X * W1 .+ b1
    A1 = max.(0.0, Z1)
    Z2 = A1 * W2 .+ b2
    preds = Int.(sigmoid(Z2) .>= 0.5)
    acc = mean(preds .== reshape(y, length(y), 1))
    return acc
end

end
