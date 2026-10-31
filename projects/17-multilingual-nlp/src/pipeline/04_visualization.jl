module VisualizationPipeline
export save_report
function save_report(acc)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 17 Multilingual NLP Accuracy: $(acc*100)%")
    end
end
end
