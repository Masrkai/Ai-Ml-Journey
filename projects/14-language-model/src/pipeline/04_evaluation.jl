module VisualizationPipeline
export save_report
function save_report(gen_text)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 14 Generated Text: $gen_text")
    end
end
end
