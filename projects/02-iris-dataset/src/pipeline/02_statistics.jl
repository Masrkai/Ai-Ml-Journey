# =====================================================================
# Stage 2: Summary Statistics, Groupby & Correlations
# =====================================================================

println("\n[2] Computing Summary Statistics & Correlations...")

numeric_cols = filter(c -> eltype(df[!, c]) <: Number, names(df))
numeric_syms = Symbol.(numeric_cols)

push!(summary_lines, "\n--- Summary Statistics (Overall) ---")
for col in numeric_syms
    vals = df[!, col]
    m = mean(vals)
    med = median(vals)
    s = std(vals)
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    println("  - $col: Mean = $(round(m, digits=3)), Median = $(round(med, digits=3)), Std = $(round(s, digits=3)), IQR = $(round(q75 - q25, digits=3))")
    push!(summary_lines, "Feature: $col | Mean: $(round(m, digits=3)) | Median: $(round(med, digits=3)) | Std: $(round(s, digits=3))")
end

println("\nGroupby Statistics by Target ('$target_col'):")
grouped = groupby(df, target_col)
agg_df = combine(grouped, numeric_syms .=> mean .=> names(df)[1:end-1] .* "_mean")
show(agg_df, allcols=true)
println()

push!(summary_lines, "\n--- Groupby Means by Species ---")
push!(summary_lines, string(agg_df))

# Compute correlation matrix for numeric features
cor_matrix = cor(Matrix{Float64}(df[!, numeric_syms]))
println("\nCorrelation Matrix:")
display(cor_matrix)
println()

push!(summary_lines, "\n--- Correlation Matrix ---")
push!(summary_lines, string(cor_matrix))
