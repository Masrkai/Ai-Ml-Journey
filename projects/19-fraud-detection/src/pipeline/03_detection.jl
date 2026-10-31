module DetectionPipeline
using Statistics
export detect_anomalies
function detect_anomalies(amount, distance, true_fraud)
    score = @. (amount > mean(amount) + 2*std(amount)) | (distance > mean(distance) + 2*std(distance))
    pred_fraud = Int.(score)
    acc = mean(pred_fraud .== true_fraud)
    return acc
end
end
