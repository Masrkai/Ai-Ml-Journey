module BenchmarkPipeline
using LinearAlgebra
using Statistics

export benchmark_models

sigmoid(z) = 1.0 ./ (1.0 .+ exp.(-clamp.(z, -500, 500)))

function benchmark_models(X, y)
    println("Benchmarking models in AutoML...")
    n, d = size(X)
    w = zeros(d)
    for epoch in 1:100
        preds = sigmoid(X * w)
        grad = (1 / n) * (X' * (preds .- y))
        w .-= 0.1 * grad
    end
    acc = mean(Int.(sigmoid(X * w) .>= 0.5) .== y)
    return Dict("LogisticRegression" => acc)
end

end
