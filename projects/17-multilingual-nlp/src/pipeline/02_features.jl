module FeaturesPipeline
using DataFrames
using Random

export extract_features
function extract_features(df::DataFrame)
    texts = df.Text
    langs = df.Language
    return texts, langs
end
end
