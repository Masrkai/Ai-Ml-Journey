module EvaluationPipeline
using Statistics

export evaluate_recommender

function evaluate_recommender(R, R_approx)
    mask = R .> 0
    rmse = sqrt(mean((R[mask] .- R_approx[mask]).^2))
    return rmse
end

end
