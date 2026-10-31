module PcaPipeline
using DataFrames
using LinearAlgebra
using Statistics

export compute_eigenfaces

function compute_eigenfaces(df::DataFrame, k=5)
    println("Computing PCA Eigenfaces...")
    labels = df.PersonID
    X = Matrix(df[:, Not(:PersonID)])
    
    mean_face = mean(X, dims=1)
    X_centered = X .- mean_face
    
    # Covariance matrix
    C = (X_centered' * X_centered) / (size(X, 1) - 1)
    F = eigen(C)
    
    # Sort eigenvalues descending
    idx = sortperm(F.values, rev=true)
    eigenvectors = F.vectors[:, idx]
    
    # Top k eigenfaces
    W = eigenvectors[:, 1:k]
    X_projected = X_centered * W
    
    return X_projected, labels, W, mean_face
end

end
