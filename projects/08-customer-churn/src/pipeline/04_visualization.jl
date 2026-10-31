module VisualizationPipeline
export save_report

function save_report(acc)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 08 Churn Predictor Accuracy: $(round(acc*100, digits=2))%")
    end
end

end
