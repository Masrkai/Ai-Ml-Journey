module VisualizationPipeline
export save_report
function save_report(acc)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 11 Face Recognition LOO Accuracy: $(round(acc*100, digits=2))%")
    end
end
end
