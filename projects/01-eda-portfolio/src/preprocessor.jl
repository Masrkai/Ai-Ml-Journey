# =====================================================================
# Reusable Preprocessing Module based on EDA Findings
# =====================================================================

module EDAPreprocessor

using Statistics
using DataFrames

export winsorize_column!, standardize_dataframe!, yeo_johnson_transform!

"""
    yeo_johnson_transform!(df::DataFrame, col::Symbol, lambda::Float64 = 0.0)

Applies Yeo-Johnson power transformation to stabilize variance and reduce skewness.
"""
function yeo_johnson_transform!(df::DataFrame, col::Symbol, lambda::Float64 = 1.0)
    vals = df[!, col]
    transformed = similar(vals, Float64)
    Threads.@threads for i in eachindex(vals)
        x = vals[i]
        if x >= 0
            if abs(lambda) > 1e-12
                transformed[i] = ((x + 1)^lambda - 1) / lambda
            else
                transformed[i] = log(x + 1)
            end
        else
            if abs(lambda - 2.0) > 1e-12
                transformed[i] = -((-x + 1)^(2 - lambda) - 1) / (2 - lambda)
            else
                transformed[i] = -log(-x + 1)
            end
        end
    end
    df[!, col] = transformed
    return df
end

"""
    winsorize_column!(df::DataFrame, col::Symbol)

Caps extreme univariate outliers at the 25th and 75th percentiles ± 1.5 * IQR.
"""
function winsorize_column!(df::DataFrame, col::Symbol)
    vals = df[!, col]
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    iqr = q75 - q25
    lower_bound = q25 - 1.5 * iqr
    upper_bound = q75 + 1.5 * iqr
    
    df[!, col] = clamp.(vals, lower_bound, upper_bound)
    return df
end

"""
    standardize_dataframe!(df::DataFrame, numeric_cols::Vector{Symbol})

Applies Z-score standardization (mean = 0, std = 1) to specified numeric columns.
"""
function standardize_dataframe!(df::DataFrame, numeric_cols::Vector{Symbol})
    Threads.@threads for col in numeric_cols
        vals = df[!, col]
        m = mean(vals)
        s = std(vals)
        if s > 0
            df[!, col] = (vals .- m) ./ s
        end
    end
    return df
end

end # module
