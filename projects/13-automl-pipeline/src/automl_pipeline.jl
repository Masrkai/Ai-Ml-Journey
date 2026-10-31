# =====================================================================
# Project 13: Automated ML Pipeline - Master Driver
# =====================================================================

include("pipeline/01_audit.jl")
include("pipeline/02_preprocess.jl")
include("pipeline/03_benchmark.jl")
include("pipeline/04_report.jl")

using .AuditPipeline
using .PreprocessPipeline
using .BenchmarkPipeline
using .ReportPipeline

function run_pipeline()
    println("Starting Project 13: AutoML Pipeline")
    df = audit_dataset()
    X, y = automl_preprocess(df)
    scores = benchmark_models(X, y)
    save_leaderboard(scores)
    println("Project 13 Completed! Leaderboard: $scores")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
