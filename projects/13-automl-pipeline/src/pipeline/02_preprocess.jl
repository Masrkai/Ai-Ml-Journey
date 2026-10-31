module PreprocessPipeline
using DataFrames
using Statistics
using Random

export automl_preprocess

function automl_preprocess(df::DataFrame)
    f1 = df.Feature1
    f2 = df.Feature2
    cat_enc = [df.Category .== c for c in unique(df.Category)]
    X = hcat(ones(nrow(df)), f1, f2, hcat(cat_enc...))
    y = df.Target
    return X, y
end

end
