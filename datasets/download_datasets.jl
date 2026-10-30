# =====================================================================
# Centralized Dataset Downloader & Verification Utility
# Ensures all datasets reside in the root datasets/ folder (SSOT).
# =====================================================================

using HTTP
using CSV
using DataFrames

const DATASETS_DIR = @__DIR__

const DATASET_URLS = Dict(
    "iris.csv" => "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv",
    "titanic.csv" => "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
)

function ensure_datasets_downloaded()
    println("==================================================")
    println(" Verifying and Downloading Required Datasets")
    println("==================================================")
    
    for (filename, url) in DATASET_URLS
        filepath = joinpath(DATASETS_DIR, filename)
        # Force re-download if file is small / truncated (< 10KB)
        if isfile(filepath) && filesize(filepath) > 10000
            println("  [OK] Dataset '$filename' already exists at $filepath")
        else
            println("  [DOWNLOADING] Fetching '$filename' from $url...")
            try
                HTTP.download(url, filepath)
                println("  [SUCCESS] Downloaded '$filename' successfully (size: $(filesize(filepath)) bytes).")
            catch e
                println("  [ERROR] Failed to download '$filename': $e")
            end
        end
    end
    println("==================================================")
end

if abspath(PROGRAM_FILE) == @__FILE__
    ensure_datasets_downloaded()
end
