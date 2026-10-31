module VisualizationPipeline
export save_report
function save_report(res)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 20 AutoML Report: $res")
    end
end
end
