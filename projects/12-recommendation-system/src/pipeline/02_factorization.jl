module FactorizationPipeline
using DataFrames
using LinearAlgebra
using Statistics

export factorize_ratings

function factorize_ratings(df::DataFrame, k=3)
    println("Performing SVD matrix factorization...")
    users = unique(df.UserID)
    items = unique(df.ItemID)
    nu = length(users)
    ni = length(items)
    
    R = zeros(nu, ni)
    for row in eachrow(df)
        u_idx = findfirst(==(row.UserID), users)
        i_idx = findfirst(==(row.ItemID), items)
        R[u_idx, i_idx] = row.Rating
    end

    F = svd(R)
    U = F.U[:, 1:k]
    S = Diagonal(F.S[1:k])
    Vt = F.Vt[1:k, :]
    
    R_approx = U * S * Vt
    return R, R_approx
end

end
