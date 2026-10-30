# =====================================================================
# Stage 1: Dataset Ingestion via Root SSOT Folder
# =====================================================================

dataset_path = "datasets/titanic.csv"
if !isfile(dataset_path)
    # Try running central downloader
    include(joinpath(dirname(dirname(dirname(@__DIR__))), "datasets", "download_datasets.jl"))
    ensure_datasets_downloaded()
end

println("\n[1] Loading dataset from: $dataset_path")
df = try
    CSV.read(dataset_path, DataFrame)
catch e
    error("Failed to load Titanic dataset: $e")
end

println("Dataset loaded successfully! Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns.")

summary_lines = String[]
push!(summary_lines, "Project 04: Titanic Survival Prediction Summary Report")
push!(summary_lines, "=====================================================")
push!(summary_lines, "Dataset Path: $(dataset_path)")
push!(summary_lines, "Dimensions: $(size(df, 1)) rows x $(size(df, 2)) columns")
