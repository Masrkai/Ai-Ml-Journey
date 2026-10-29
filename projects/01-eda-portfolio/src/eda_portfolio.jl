# =====================================================================
# Project 01: Exploratory Data Analysis (EDA) Portfolio in Julia
# =====================================================================

using DataFrames
using CSV
using HTTP
using Statistics
using Plots

println("==================================================")
println(" Starting Exploratory Data Analysis (EDA) Portfolio")
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

# 2. Basic Inspection
println("\n[2] First 5 rows of the dataset:")
println(first(df, 5))

println("\n[3] Dataset Schema & Column Types:")
println(describe(df))

# 3. Summary Statistics & Correlation Analysis
println("\n[4] Computing Summary Statistics & Correlation Matrix...")
numeric_col_names = names(df)[findall(col -> eltype(col) <: Number, eachcol(df))]
println("Numeric columns: ", numeric_col_names)

summary_lines = String[]
push!(summary_lines, "EDA Portfolio Summary Report")
push!(summary_lines, "============================")

for col in numeric_col_names
    vals = df[!, col]
    m = mean(vals)
    s = std(vals)
    med = median(vals)
    line_str = " - $(col): mean = $(round(m, digits=3)), std = $(round(s, digits=3)), median = $(round(med, digits=3))"
    println(line_str)
    push!(summary_lines, line_str)
end

# Correlation Matrix among numeric columns
println("\n[4.1] Correlation Matrix (Pearson):")
num_matrix = Matrix(df[!, numeric_col_names])
corr_matrix = cor(num_matrix)
for (i, c1) in enumerate(numeric_col_names)
    for (j, c2) in enumerate(numeric_col_names)
        println("  cor($(c1), $(c2)) = $(round(corr_matrix[i, j], digits=3))")
    end
end

# Outlier Detection via IQR Method
println("\n[4.2] Outlier Detection (IQR Method):")
for col in numeric_col_names
    vals = df[!, col]
    q25 = quantile(vals, 0.25)
    q75 = quantile(vals, 0.75)
    iqr = q75 - q25
    lower_bound = q25 - 1.5 * iqr
    upper_bound = q75 + 1.5 * iqr
    outliers = findall(v -> v < lower_bound || v > upper_bound, vals)
    println(" - $(col): $(length(outliers)) potential outliers detected (Bounds: [$(round(lower_bound, digits=2)), $(round(upper_bound, digits=2))])")
    push!(summary_lines, " - $(col) Outliers: $(length(outliers))")
end

# 4. Groupby and Aggregation
if "species" in names(df)
    println("\n[5] Grouping by species and computing mean petal length & width:")
    gdf = groupby(df, :species)
    agg_df = combine(gdf, :petal_length => mean => :mean_petal_length, :petal_width => mean => :mean_petal_width)
    println(agg_df)
end

# 5. Data Visualization
println("\n[6] Generating EDA Visualizations...")
# Ensure plots output directory exists
mkpath("output")

# Histogram of sepal length
p1 = histogram(df.sepal_length, label="Sepal Length", xlabel="Length", ylabel="Frequency", title="Sepal Length Distribution", color=:dodgerblue)
savefig(p1, "output/sepal_length_hist.png")

# Scatter plot of petal length vs petal width
if "species" in names(df)
    p2 = scatter(df.petal_length, df.petal_width, group=df.species, xlabel="Petal Length", ylabel="Petal Width", title="Petal Length vs Width by Species")
else
    p2 = scatter(df.petal_length, df.petal_width, xlabel="Petal Length", ylabel="Petal Width", title="Petal Length vs Width")
end
savefig(p2, "output/petal_scatter.png")

# Write summary report to file
write("output/summary_report.txt", join(summary_lines, "\n"))
println("Summary report written to 'output/summary_report.txt'")

println("Plots saved successfully in 'output/' directory!")
println("\n==================================================")
println(" EDA Portfolio Execution Completed Successfully!")
println("==================================================")
