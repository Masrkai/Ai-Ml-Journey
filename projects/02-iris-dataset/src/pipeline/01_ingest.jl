# =====================================================================
# Stage 1: Dataset Ingestion & Validation for Iris Pipeline
# =====================================================================

dataset_path = length(ARGS) >= 1 ? ARGS[1] : "datasets/iris.csv"
target_col = length(ARGS) >= 2 ? Symbol(ARGS[2]) : :species

println("\n[1] Loading dataset from: $dataset_path")
df = try
    if isfile(dataset_path)
        CSV.read(dataset_path, DataFrame)
    else
        # Fallback to absolute/relative root path if needed
        alt_path = joinpath(dirname(dirname(dirname(@__DIR__))), dataset_path)
        if isfile(alt_path)
            CSV.read(alt_path, DataFrame)
        else
            error("Dataset not found at '$dataset_path' or '$alt_path'.")
        end
    end
catch e
    error("Failed to load dataset: $e")
end

println("Dataset loaded successfully! Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns.")

summary_lines = String[]
push!(summary_lines, "Project 02: Iris Dataset Pipeline Summary Report")
push!(summary_lines, "=====================================================")
push!(summary_lines, "Dataset Path: $(dataset_path)")
push!(summary_lines, "Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns")
push!(summary_lines, "Columns: $(join(names(df), ", "))")

if !(string(target_col) in names(df))
    error("Target column '$target_col' not found in dataset columns ($(names(df))).")
end
println("Designated Target Column: '$(target_col)'")
push!(summary_lines, "Target Column: $(target_col)")
