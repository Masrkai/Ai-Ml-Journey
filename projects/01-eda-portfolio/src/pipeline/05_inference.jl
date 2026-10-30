# =====================================================================
# Stage 5: Outliers, Aggregations, Moments, Spearman, ANOVA & Advanced Tests
# =====================================================================

# 5. Outlier Detection (Univariate IQR Bounds)
println("\n[5] Outlier Detection (Univariate IQR Bounds):")
push!(summary_lines, "\n[Outlier Detection]")
outlier_flags = falses(size(num_matrix, 1))

for (idx, col) in enumerate(numeric_col_names)
    vals = num_matrix[:, idx]
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    iqr = q75 - q25
    lower_bound = q25 - 1.5 * iqr
    upper_bound = q75 + 1.5 * iqr
    outliers = findall(v -> v < lower_bound || v > upper_bound, vals)
    outlier_flags[outliers] .= true
    out_str = " - $(col): $(length(outliers)) univariate outliers detected (Bounds: [$(round(lower_bound, digits=2)), $(round(upper_bound, digits=2))])"
    println(out_str)
    push!(summary_lines, out_str)
end

total_outlier_samples = sum(outlier_flags)
mv_out_str = " - Total unique samples flagged as univariate outliers: $(total_outlier_samples) out of $(size(num_matrix, 1))"
println(mv_out_str)
push!(summary_lines, mv_out_str)

# 6. Groupby and Aggregation (if target exists and is categorical)
if !isnothing(target_col)
    if !(eltype(df[!, target_col]) <: Number)
        println("\n[6] Groupby Aggregation by Target ($(target_col)):")
        push!(summary_lines, "\n[Groupby Aggregation by Target]")
        clean_df = dropmissing(df, [target_col; Symbol.(numeric_col_names)])
        gdf = groupby(clean_df, target_col)
        agg_pairs = [Symbol(col) => mean => Symbol("mean_", col) for col in numeric_col_names]
        agg_df = combine(gdf, agg_pairs...)
        println(agg_df)
        for r in eachrow(agg_df)
            means_desc = join(["$c=$(round(r[Symbol("mean_", c)], digits=2))" for c in numeric_col_names], ", ")
            agg_str = " - Target Class '$(r[target_col])': $(means_desc)"
            push!(summary_lines, agg_str)
        end
    end
end

# 7. Advanced Distributional Moments (Skewness & Excess Kurtosis)
println("\n[7] Computing Skewness and Excess Kurtosis...")
push!(summary_lines, "\n[Distributional Moments (Skewness & Excess Kurtosis)]")

function compute_skewness(vals)
    m = mean(vals)
    s = std(vals)
    n = length(vals)
    if s == 0 || n < 3 return 0.0 end
    return (n / ((n - 1) * (n - 2))) * sum(((vals .- m) ./ s) .^ 3)
end

function compute_kurtosis(vals)
    m = mean(vals)
    s = std(vals)
    n = length(vals)
    if s == 0 || n < 4 return 0.0 end
    term1 = (n * (n + 1)) / ((n - 1) * (n - 2) * (n - 3)) * sum(((vals .- m) ./ s) .^ 4)
    term2 = (3 * (n - 1)^2) / ((n - 2) * (n - 3))
    return term1 - term2
end

for (idx, col) in enumerate(numeric_col_names)
    vals = num_matrix[:, idx]
    sk = compute_skewness(vals)
    kt = compute_kurtosis(vals)
    mom_str = " - $(col): Skewness = $(round(sk, digits=3)), Excess Kurtosis = $(round(kt, digits=3))"
    println(mom_str)
    push!(summary_lines, mom_str)
end

# 8. Spearman Rank Correlation Matrix
println("\n[8] Computing Spearman Rank Correlation Matrix...")
push!(summary_lines, "\n[Spearman Rank Correlation Matrix]")

function rank_transform(vals)
    p = sortperm(vals)
    r = similar(vals, Float64)
    i = 1
    while i <= length(vals)
        j = i
        while j < length(vals) && vals[p[j+1]] == vals[p[i]]
            j += 1
        end
        avg_rank = (i + j) / 2.0
        for k in i:j
            r[p[k]] = avg_rank
        end
        i = j + 1
    end
    return r
end

ranked_matrix = similar(num_matrix, Float64)
for j in axes(num_matrix, 2)
    ranked_matrix[:, j] = rank_transform(num_matrix[:, j])
end
spearman_matrix = cor(ranked_matrix)

sp_header = lpad("Column", col_width) * join([lpad(c, col_width) for c in numeric_col_names], "")
println(sp_header)
push!(summary_lines, sp_header)

for (i, c1) in enumerate(numeric_col_names)
    row_str = lpad(c1, col_width) * join([lpad(string(round(spearman_matrix[i, j], digits=3)), col_width) for j in eachindex(numeric_col_names)], "")
    println(row_str)
    push!(summary_lines, row_str)
end

# 9. Inferential Group Separability Testing (One-Way ANOVA F-Test if target is categorical)
if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
    println("\n[9] Inferential Group Separability Testing (One-Way ANOVA F-Test):")
    push!(summary_lines, "\n[Inferential Group Separability (One-Way ANOVA)]")
    
    clean_df = dropmissing(df, [target_col; Symbol.(numeric_col_names)])
    target_vals_clean = clean_df[!, target_col]
    unique_classes = unique(target_vals_clean)
    
    if length(unique_classes) > 1
        for (idx, col) in enumerate(numeric_col_names)
            vals = clean_df[!, Symbol(col)]
            overall_mean = mean(vals)
            k = length(unique_classes)
            N = length(vals)
            
            ss_between = 0.0
            ss_within = 0.0
            for g in unique_classes
                g_vals = vals[target_vals_clean .== g]
                n_g = length(g_vals)
                if n_g == 0 continue end
                mean_g = mean(g_vals)
                ss_between += n_g * (mean_g - overall_mean)^2
                ss_within += sum((g_vals .- mean_g).^2)
            end
            
            df_between = k - 1
            df_within = N - k
            ms_between = df_between > 0 ? ss_between / df_between : 0.0
            ms_within = df_within > 0 ? ss_within / df_within : 0.0
            F_stat = ms_within > 0 ? ms_between / ms_within : 0.0
            
            anova_str = " - Feature '$(col)': One-Way ANOVA F-statistic = $(round(F_stat, digits=2)) (df: $(df_between), $(df_within))"
            println(anova_str)
            push!(summary_lines, anova_str)
        end
    end
end

# 10. Multivariate Outlier Detection (Mahalanobis Distance)
println("\n[10] Multivariate Outlier Detection (Mahalanobis Distance):")
push!(summary_lines, "\n[Multivariate Outlier Detection (Mahalanobis)]")

mu_vec = mean(num_matrix, dims=1)
centered_mat = num_matrix .- mu_vec
cov_mat = cov(num_matrix)
inv_cov_mat = try
    inv(cov_mat)
catch
    pinv(cov_mat)
end

mahalanobis_d2 = zeros(size(num_matrix, 1))
for i in 1:size(num_matrix, 1)
    diff = reshape(centered_mat[i, :], 1, size(num_matrix, 2))
    mahalanobis_d2[i] = dot(diff, inv_cov_mat, diff')
end

df_dim = length(numeric_col_names)
chi2_threshold = df_dim * (1.0 - 2.0/(9.0*df_dim) + 2.576*sqrt(2.0/(9.0*df_dim)))^3
multiv_outliers = findall(mahalanobis_d2 .> chi2_threshold)
mah_str = " - Mahalanobis distance multivariate outliers (p < 0.01 threshold ≈ $(round(chi2_threshold, digits=2))): $(length(multiv_outliers)) samples flagged"
println(mah_str)
push!(summary_lines, mah_str)

# 12. Advanced Non-Parametric & Homoscedasticity Tests (if categorical target exists)
if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
    println("\n[12] Advanced Statistical Diagnostics (Kruskal-Wallis & Levene Tests):")
    push!(summary_lines, "\n[Advanced Statistical Diagnostics]")
    
    clean_df = dropmissing(df, [target_col; Symbol.(numeric_col_names)])
    target_vals_clean = clean_df[!, target_col]
    unique_groups = unique(target_vals_clean)
    
    if length(unique_groups) > 1
        n = size(clean_df, 1)
        for (idx, col) in enumerate(numeric_col_names)
            vals = clean_df[!, Symbol(col)]
            r = rank_transform(vals)
            sum_term = 0.0
            for g in unique_groups
                idx_g = findall(==(g), target_vals_clean)
                n_g = length(idx_g)
                if n_g == 0 continue end
                r_g = sum(r[idx_g])
                sum_term += (r_g^2) / n_g
            end
            H_stat = (12.0 / (n * (n + 1))) * sum_term - 3.0 * (n + 1)
            
            z = similar(vals, Float64)
            for g in unique_groups
                idx_g = findall(==(g), target_vals_clean)
                if isempty(idx_g) continue end
                med = median(vals[idx_g])
                z[idx_g] = abs.(vals[idx_g] .- med)
            end
            overall_mean_z = mean(z)
            ss_between = 0.0
            ss_within = 0.0
            k = length(unique_groups)
            for g in unique_groups
                idx_g = findall(==(g), target_vals_clean)
                if isempty(idx_g) continue end
                z_g = z[idx_g]
                n_g = length(z_g)
                mean_z_g = mean(z_g)
                ss_between += n_g * (mean_z_g - overall_mean_z)^2
                ss_within += sum((z_g .- mean_z_g).^2)
            end
            df_between = k - 1
            df_within = n - k
            ms_between = df_between > 0 ? ss_between / df_between : 0.0
            ms_within = df_within > 0 ? ss_within / df_within : 0.0
            levene_stat = ms_within > 0 ? ms_between / ms_within : 0.0
            
            adv_str = " - Feature '$(col)': Kruskal-Wallis H = $(round(H_stat, digits=2)), Levene Stat = $(round(levene_stat, digits=2))"
            println(adv_str)
            push!(summary_lines, adv_str)
        end
    end
end
