# =====================================================================
# Stage 4: Summary Statistics, Correlation Analysis & Workflow Diagnostics
# =====================================================================

println("\n[4] Computing Summary Statistics & Correlation Matrix...")
push!(summary_lines, "\n[Summary Statistics & Correlations]")
numeric_col_names = names(df)[findall(col -> eltype(col) <: Number, eachcol(df))]
println("Numeric columns: ", numeric_col_names)

if isempty(numeric_col_names)
    error("Error: No numeric columns found in dataset. Statistical and correlation analysis require numeric features.")
end

for col in numeric_col_names
    vals = collect(skipmissing(df[!, col]))
    if isempty(vals) continue end
    m = mean(vals)
    s = std(vals)
    med = median(vals)
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    line_str = " - $(col): mean = $(round(m, digits=3)), std = $(round(s, digits=3)), median = $(round(med, digits=3)), IQR = $(round(q75 - q25, digits=3))"
    println(line_str)
    push!(summary_lines, line_str)
end

# Correlation Matrix among numeric columns (handling potential NaNs/missing)
println("\n[4.1] Correlation Matrix (Pearson):")
push!(summary_lines, "\n[Correlation Matrix (Pearson)]")
num_matrix = Matrix(dropmissing(df[!, numeric_col_names]))
if size(num_matrix, 1) == 0
    error("Error: Dataset has no complete rows across numeric columns after dropping missing values.")
end
corr_matrix = cor(num_matrix)

col_width = 15
header_row = lpad("Column", col_width) * join([lpad(c, col_width) for c in numeric_col_names], "")
println(header_row)
push!(summary_lines, header_row)

for (i, c1) in enumerate(numeric_col_names)
    row_str = lpad(c1, col_width) * join([lpad(string(round(corr_matrix[i, j], digits=3)), col_width) for j in eachindex(numeric_col_names)], "")
    println(row_str)
    push!(summary_lines, row_str)
end

# Multicollinearity alerts (upper triangle)
for (i, c1) in enumerate(numeric_col_names)
    for (j, c2) in enumerate(numeric_col_names)
        if i < j
            cor_val = corr_matrix[i, j]
            if !isnan(cor_val) && abs(cor_val) > 0.8
                multico_str = "   -> High multicollinearity alert between $(c1) and $(c2) ($(round(cor_val, digits=3)))"
                println(multico_str)
                push!(summary_lines, multico_str)
            end
        end
    end
end

# 4.2 Supervised / Unsupervised ML Workflow Optimization Diagnostics
println("\n[4.2] ML Workflow Optimization Diagnostics ($(uppercase(workflow_mode))):")
push!(summary_lines, "\n[ML Workflow Optimization Diagnostics ($(uppercase(workflow_mode)))]")

if workflow_mode == "supervised" && !isnothing(target_col)
    target_vals = df[!, target_col]
    if eltype(target_vals) <: Number
        println(" - Supervised Regression Target Analysis:")
        push!(summary_lines, " - Supervised Regression Target Analysis:")
        clean_reg_df = dropmissing(df, [target_col; Symbol.(numeric_col_names)])
        t_vec = clean_reg_df[!, target_col]
        for col in numeric_col_names
            f_vec = clean_reg_df[!, Symbol(col)]
            r_val = cor(f_vec, t_vec)
            leak_str = "   -> Feature '$(col)' correlation with target: $(round(r_val, digits=3))"
            if abs(r_val) > 0.95
                leak_str *= " [WARNING: Potential Target Leakage (|r| > 0.95)]"
            end
            println(leak_str)
            push!(summary_lines, leak_str)
        end
    else
        println(" - Supervised Classification Target Analysis:")
        push!(summary_lines, " - Supervised Classification Target Analysis:")
        class_counts = combine(groupby(df, target_col), nrow => :count)
        max_c = maximum(class_counts.count)
        min_c = minimum(class_counts.count)
        imbalance_ratio = max_c / min_c
        imb_str = "   -> Class Imbalance Ratio (Max/Min): $(round(imbalance_ratio, digits=2))"
        println(imb_str)
        push!(summary_lines, imb_str)
        if imbalance_ratio > 3.0
            warn_str = "   -> [WARNING: Significant class imbalance detected (ratio > 3.0). Recommend SMOTE, class weighting, or stratified splitting.]"
            println(warn_str)
            push!(summary_lines, warn_str)
        else
            ok_str = "   -> Class distribution is reasonably balanced (ratio <= 3.0)."
            println(ok_str)
            push!(summary_lines, ok_str)
        end
    end
elseif workflow_mode == "unsupervised"
    println(" - Unsupervised Cluster Tendency & Redundancy Analysis:")
    push!(summary_lines, " - Unsupervised Cluster Tendency & Redundancy Analysis:")
    
    function compute_hopkins_statistic(X::Matrix{Float64}; m::Int = min(50, size(X, 1)))
        n, d = size(X)
        if n <= 1 return 0.5 end
        m = min(m, n)
        rand_indices = randperm(n)[1:m]
        sample_pts = X[rand_indices, :]
        mins = minimum(X, dims=1)
        maxs = maximum(X, dims=1)
        synth_pts = similar(sample_pts)
        for j in 1:d
            synth_pts[:, j] = rand(m) .* (maxs[1, j] - mins[1, j]) .+ mins[1, j]
        end
        sum_w = 0.0
        for i in 1:m
            pt = sample_pts[i, :]
            min_dist = Inf
            for k in 1:n
                if all(X[k, :] .== pt) continue end
                d_val = norm(X[k, :] - pt)
                if d_val < min_dist min_dist = d_val end
            end
            if min_dist == Inf min_dist = 0.0 end
            sum_w += min_dist
        end
        sum_u = 0.0
        for i in 1:m
            pt = synth_pts[i, :]
            min_dist = Inf
            for k in 1:n
                d_val = norm(X[k, :] - pt)
                if d_val < min_dist min_dist = d_val end
            end
            sum_u += min_dist
        end
        denom = sum_w + sum_u
        if denom == 0.0 return 0.5 end
        return sum_u / denom
    end
    
    hopkins_val = compute_hopkins_statistic(num_matrix)
    hop_str = "   -> Hopkins Statistic for Cluster Tendency: $(round(hopkins_val, digits=3))"
    println(hop_str)
    push!(summary_lines, hop_str)
    if hopkins_val > 0.65
        hop_desc = "   -> [Interpretation: Hopkins > 0.65 indicates strong spatial clustering tendency. Highly suitable for K-Means / Hierarchical Clustering.]"
        println(hop_desc)
        push!(summary_lines, hop_desc)
    elseif hopkins_val < 0.4
        hop_desc = "   -> [Interpretation: Hopkins < 0.4 indicates regular spatial distribution or lack of clustering tendency.]"
        println(hop_desc)
        push!(summary_lines, hop_desc)
    else
        hop_desc = "   -> [Interpretation: Hopkins ≈ 0.5 indicates spatial randomness.]"
        println(hop_desc)
        push!(summary_lines, hop_desc)
    end
    
    local redundant_pairs = 0
    for (i, c1) in enumerate(numeric_col_names)
        for (j, c2) in enumerate(numeric_col_names)
            if i < j
                r_val = corr_matrix[i, j]
                if !isnan(r_val) && abs(r_val) > 0.85
                    redundant_pairs += 1
                    red_str = "   -> Redundancy Alert: High collinearity between '$(c1)' and '$(c2)' (r = $(round(r_val, digits=3))). Recommend dimensionality reduction (PCA) or feature pruning for distance-based clustering."
                    println(red_str)
                    push!(summary_lines, red_str)
                end
            end
        end
    end
    if redundant_pairs == 0
        no_red_str = "   -> No severe feature redundancy (|r| > 0.85) detected."
        println(no_red_str)
        push!(summary_lines, no_red_str)
    end
end
