module PreprocessPipeline
using DataFrames
export preprocess_fraud
function preprocess_fraud(df::DataFrame)
    return df.Amount, df.DistanceFromHome, df.IsFraud
end
end
