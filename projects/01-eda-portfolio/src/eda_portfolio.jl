# =====================================================================
# Project 01: Exploratory Data Analysis (EDA) Portfolio in Julia
# =====================================================================

using DataFrames
using CSV
using HTTP
using Statistics
using LinearAlgebra
using Plots

println("==================================================")
println(" Starting Enhanced EDA Portfolio Pipeline")
println("==================================================")

# 1. Load Dataset (Iris dataset with local caching)
dataset_dir = "datasets"
dataset_path = joinpath(dataset_dir, "iris.csv")
url = "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"

df = try
    if isfile(dataset_path)
        println("\n[1] Loading dataset from local cache: $dataset_path")
        CSV.read(dataset_path, DataFrame)
    else
        println("\n[1] Downloading dataset from: $url")
        response = HTTP.get(url)
        mkpath(dataset_dir)
        write(dataset_path, response.body)
        println("Dataset cached successfully at $dataset_path")
        CSV.read(IOBuffer(String(response.body)), DataFrame)
    end
catch e
    println("Failed to load or download dataset ($(e)). Using fallback synthetic dataset.")
    DataFrame(
        sepal_length = rand(150) .* 4.0 .+ 4.0,
        sepal_width  = rand(150) .* 2.0 .+ 2.0,
        petal_length = rand(150) .* 5.0 .+ 1.0,
        petal_width  = rand(150) .* 2.5 .+ 0.1,
        species      = rand(["setosa", "versicolor", "virginica"], 150)
    )
end

println("Dataset loaded successfully! Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns.")

summary_lines = String[]
push!(summary_lines, "EDA Portfolio Summary Report")
push!(summary_lines, "=====================================")
push!(summary_lines, "Dataset Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns")

# 2. Data Quality & Missingness Audit
println("\n[2] Performing Data Quality & Missingness Audit...")
push!(summary_lines, "\n[Data Quality Audit]")
for col in names(df)
    col_data = df[!, col]
    missing_count = count(ismissing, col_data)
    missing_pct = (missing_count / length(col_data)) * 100
    unique_count = length(unique(col_data))
    audit_str = " - Column '$(col)' ($(eltype(col_data))): missing = $(missing_count) ($(round(missing_pct, digits=2))%), unique_values = $(unique_count)"
    println(audit_str)
    push!(summary_lines, audit_str)
end

# Duplicate row check
dup_count = sum(nonunique(df))
dup_str = " - Exact duplicate rows detected: $(dup_count)"
println(dup_str)
push!(summary_lines, dup_str)

# 3. Class Imbalance & Entropy Diagnostics (if target 'species' exists)
if "species" in names(df)
    println("\n[3] Computing Class Distribution & Shannon Entropy...")
    push!(summary_lines, "\n[Class Imbalance & Entropy Diagnostics]")
    species_counts = combine(groupby(df, :species), nrow => :count)
    total_rows = size(df, 1)
    entropy_val = 0.0
    for r in eachrow(species_counts)
        prop = r.count / total_rows
        global entropy_val -= prop * log2(prop)
        ratio_str = " - Species '$(r.species)': count = $(r.count) ($(round(prop * 100, digits=2))%)"
        println(ratio_str)
        push!(summary_lines, ratio_str)
    end
    ent_str = " - Shannon Entropy of Target Distribution: $(round(entropy_val, digits=4)) bits"
    println(ent_str)
    push!(summary_lines, ent_str)
end

# 4. Summary Statistics & Correlation Analysis
println("\n[4] Computing Summary Statistics & Correlation Matrix...")
push!(summary_lines, "\n[Summary Statistics & Correlations]")
numeric_col_names = names(df)[findall(col -> eltype(col) <: Number, eachcol(df))]
println("Numeric columns: ", numeric_col_names)

for col in numeric_col_names
    vals = df[!, col]
    m = mean(vals)
    s = std(vals)
    med = median(vals)
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    line_str = " - $(col): mean = $(round(m, digits=3)), std = $(round(s, digits=3)), median = $(round(med, digits=3)), IQR = $(round(q75 - q25, digits=3))"
    println(line_str)
    push!(summary_lines, line_str)
end

# Correlation Matrix among numeric columns
println("\n[4.1] Correlation Matrix (Pearson):")
push!(summary_lines, "\n[Correlation Matrix (Pearson)]")
num_matrix = Matrix(df[!, numeric_col_names])
corr_matrix = cor(num_matrix)

# Print matrix table format
header_row = lpad("Column", 15) * join([lpad(c, 15) for c in numeric_col_names], "")
println(header_row)
push!(summary_lines, header_row)

for (i, c1) in enumerate(numeric_col_names)
    row_str = lpad(c1, 15) * join([lpad(string(round(corr_matrix[i, j], digits=3)), 15) for j in eachindex(numeric_col_names)], "")
    println(row_str)
    push!(summary_lines, row_str)
end

# Multicollinearity alerts (upper triangle)
for (i, c1) in enumerate(numeric_col_names)
    for (j, c2) in enumerate(numeric_col_names)
        if i < j
            cor_val = corr_matrix[i, j]
            if abs(cor_val) > 0.8
                multico_str = "   -> High multicollinearity alert between $(c1) and $(c2) ($(round(cor_val, digits=3)))"
                println(multico_str)
                push!(summary_lines, multico_str)
            end
        end
    end
end

# 5. Outlier Detection (Univariate IQR Bounds)
println("\n[5] Outlier Detection (Univariate IQR Bounds):")
push!(summary_lines, "\n[Outlier Detection]")
outlier_flags = falses(size(df, 1))

for col in numeric_col_names
    vals = df[!, col]
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
mv_out_str = " - Total unique samples flagged as univariate outliers: $(total_outlier_samples) out of $(size(df, 1))"
println(mv_out_str)
push!(summary_lines, mv_out_str)

# 6. Groupby and Aggregation
if "species" in names(df)
    println("\n[6] Groupby Aggregation by Species:")
    push!(summary_lines, "\n[Groupby Aggregation by Species]")
    gdf = groupby(df, :species)
    agg_df = combine(gdf, 
        :sepal_length => mean => :mean_sepal_length,
        :sepal_width  => mean => :mean_sepal_width,
        :petal_length => mean => :mean_petal_length,
        :petal_width  => mean => :mean_petal_width
    )
    println(agg_df)
    for r in eachrow(agg_df)
        agg_str = " - Species '$(r.species)': mean sepal_l=$(round(r.mean_sepal_length, digits=2)), sepal_w=$(round(r.mean_sepal_width, digits=2)), petal_l=$(round(r.mean_petal_length, digits=2)), petal_w=$(round(r.mean_petal_width, digits=2))"
        push!(summary_lines, agg_str)
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

for col in numeric_col_names
    vals = df[!, col]
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

num_matrix = Matrix(df[!, numeric_col_names])
ranked_matrix = similar(num_matrix, Float64)
for j in axes(num_matrix, 2)
    ranked_matrix[:, j] = rank_transform(num_matrix[:, j])
end
spearman_matrix = cor(ranked_matrix)

sp_header = lpad("Column", 15) * join([lpad(c, 15) for c in numeric_col_names], "")
println(sp_header)
push!(summary_lines, sp_header)

for (i, c1) in enumerate(numeric_col_names)
    row_str = lpad(c1, 15) * join([lpad(string(round(spearman_matrix[i, j], digits=3)), 15) for j in eachindex(numeric_col_names)], "")
    println(row_str)
    push!(summary_lines, row_str)
end

# 9. Inferential Group Separability Testing (One-Way ANOVA F-Test)
if "species" in names(df)
    println("\n[9] Inferential Group Separability Testing (One-Way ANOVA F-Test):")
    push!(summary_lines, "\n[Inferential Group Separability (One-Way ANOVA)]")
    
    for col in numeric_col_names
        vals = df[!, col]
        groups = groupby(df, :species)
        overall_mean = mean(vals)
        k = length(groups)
        N = length(vals)
        
        ss_between = 0.0
        ss_within = 0.0
        for g in groups
            g_vals = g[!, col]
            n_g = length(g_vals)
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

# Threshold for chi-squared with df = 4 at p = 0.01 is ~13.277
chi2_threshold = 13.277
multiv_outliers = findall(mahalanobis_d2 .> chi2_threshold)
mah_str = " - Mahalanobis distance multivariate outliers (p < 0.01 threshold = $(chi2_threshold)): $(length(multiv_outliers)) samples flagged"
println(mah_str)
push!(summary_lines, mah_str)

# 11. Exploratory Dimensionality Reduction (PCA via SVD)
println("\n[11] Exploratory Dimensionality Reduction (PCA via SVD):")
push!(summary_lines, "\n[Principal Component Analysis (PCA)]")

std_devs = std(num_matrix, dims=1)
scaled_num_matrix = (num_matrix .- mu_vec) ./ std_devs
F_pca = svd(scaled_num_matrix)
eigenvalues = (F_pca.S .^ 2) ./ (size(num_matrix, 1) - 1)
explained_var_ratio = eigenvalues ./ sum(eigenvalues)
cum_var = cumsum(explained_var_ratio)

for (idx, ev) in enumerate(explained_var_ratio)
    pca_str = " - Principal Component PC$(idx): Explained Variance = $(round(ev * 100, digits=2))% (Cumulative: $(round(cum_var[idx] * 100, digits=2))%)"
    println(pca_str)
    push!(summary_lines, pca_str)
end

# 12. Data Visualization Generation
println("\n[12] Generating Comprehensive EDA Visualizations...")
mkpath("output")

# Histogram of sepal length
p1 = histogram(df.sepal_length, label="Sepal Length", xlabel="Length (cm)", ylabel="Frequency", title="Sepal Length Distribution", color=:dodgerblue)
savefig(p1, "output/sepal_length_hist.png")

# Scatter plot of petal length vs petal width colored by species
if "species" in names(df)
    p2 = scatter(df.petal_length, df.petal_width, group=df.species, xlabel="Petal Length (cm)", ylabel="Petal Width (cm)", title="Petal Length vs Width by Species")
else
    p2 = scatter(df.petal_length, df.petal_width, xlabel="Petal Length (cm)", ylabel="Petal Width (cm)", title="Petal Length vs Width")
end
savefig(p2, "output/petal_scatter.png")

# Scatter plot of sepal length vs sepal width
if "species" in names(df)
    p3 = scatter(df.sepal_length, df.sepal_width, group=df.species, xlabel="Sepal Length (cm)", ylabel="Sepal Width (cm)", title="Sepal Length vs Width by Species")
else
    p3 = scatter(df.sepal_length, df.sepal_width, xlabel="Sepal Length (cm)", ylabel="Sepal Width (cm)", title="Sepal Length vs Width")
end
savefig(p3, "output/sepal_width_scatter.png")

# Write summary report to file
write("output/summary_report.txt", join(summary_lines, "\n"))
println("Summary report written to 'output/summary_report.txt'")
println("All diagnostic plots saved successfully in 'output/' directory!")
