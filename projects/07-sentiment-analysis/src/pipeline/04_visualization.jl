module VisualizationPipeline
using Plots

export save_report

function save_report(acc)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    report_path = joinpath(output_dir, "summary_report.txt")
    open(report_path, "w") do io
        println(io, "==================================================")
        println(io, " Project 07: Sentiment Analysis Summary Report")
        println(io, "==================================================")
        println(io, "Test Accuracy: $(round(acc * 100, digits=2))%")
        println(io, "==================================================")
    end
    println("Saved sentiment summary report to $report_path")
end

end
