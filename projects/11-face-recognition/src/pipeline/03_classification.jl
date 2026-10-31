module ClassificationPipeline
using Statistics
using LinearAlgebra

export evaluate_faces

function evaluate_faces(X_proj, labels)
    n = length(labels)
    correct = 0
    for i in 1:n
        # leave-one-out nearest neighbor
        dists = [norm(X_proj[i, :] .- X_proj[j, :]) for j in 1:n if j != i]
        min_idx = argmin(dists)
        neighbor_idx = min_idx >= i ? min_idx + 1 : min_idx
        if labels[i] == labels[neighbor_idx]
            correct += 1
        end
    end
    acc = correct / n
    return acc
end

end
