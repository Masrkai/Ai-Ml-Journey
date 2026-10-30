# =====================================================================
# Stage 1: Dataset Ingestion, Configuration & Explicit Argument Validation
# =====================================================================

if length(ARGS) < 3
    error("""
    Error: Missing required arguments for dataset-agnostic EDA pipeline.
    All parameters must be explicitly provided.
    Usage: julia --project=. src/eda_portfolio.jl <dataset_path> <target_column> <mode>
      - dataset_path : Path to tabular CSV dataset (e.g., datasets/iris.csv)
      - target_column: Name of target column, or 'none' / 'null' for unsupervised analysis
      - mode         : Workflow optimization mode ('supervised' or 'unsupervised')
    """)
end

dataset_path = ARGS[1]
target_arg_str = lowercase(ARGS[2])
target_col = target_arg_str in ("none", "null", "") ? nothing : Symbol(ARGS[2])
workflow_mode = lowercase(ARGS[3])

if !(workflow_mode in ("supervised", "unsupervised"))
    error("Error: Workflow mode must be explicitly set to either 'supervised' or 'unsupervised'. Received: '$(workflow_mode)'")
end

dataset_dir = dirname(dataset_path)

df = try
    if isfile(dataset_path)
        println("\n[1] Loading dataset from explicit path: $dataset_path")
        CSV.read(dataset_path, DataFrame)
    else
        error("Dataset file not found at explicit path '$dataset_path'.")
    end
catch e
    error("Failed to load dataset from '$dataset_path' ($(e)).")
end

println("Dataset loaded successfully! Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns.")

push!(summary_lines, "EDA Portfolio Summary Report (Dataset-Agnostic)")
push!(summary_lines, "=====================================================")
push!(summary_lines, "Source Path: $(dataset_path)")
push!(summary_lines, "Dataset Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns")

if !isnothing(target_col) && !(string(target_col) in names(df))
    error("Error: Designated target column '$(target_col)' not found in dataset columns ($(names(df))).")
end

if !isnothing(target_col)
    println("Designated Target Column: '$(target_col)'")
    push!(summary_lines, "Target Column: $(target_col)")
else
    println("Designated Target Column: None (Unsupervised Analysis)")
    push!(summary_lines, "Target Column: None (Unsupervised Analysis)")
end

println("Workflow Optimization Mode: $(uppercase(workflow_mode))")
push!(summary_lines, "Workflow Optimization Mode: $(uppercase(workflow_mode))")
