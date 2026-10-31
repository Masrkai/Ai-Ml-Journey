module ValidationPipeline
export validate_model
function validate_model(metrics, threshold=0.8)
    return metrics["accuracy"] >= threshold
end
end
