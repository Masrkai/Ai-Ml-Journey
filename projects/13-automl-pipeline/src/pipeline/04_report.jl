module ReportPipeline
export save_leaderboard
function save_leaderboard(scores)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 13 AutoML Leaderboard: $scores")
    end
end
end
