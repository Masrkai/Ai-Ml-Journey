module DataPipeline
using Random

export generate_synth_data

function generate_synth_data()
    println("Generating synthetic classification data...")
    Random.seed!(42)
    n = 200
    X = randn(n, 2)
    y = [X[i, 1]^2 + X[i, 2]^2 > 1.0 ? 1 : 0 for i in 1:n]
    return X, y
end

end
