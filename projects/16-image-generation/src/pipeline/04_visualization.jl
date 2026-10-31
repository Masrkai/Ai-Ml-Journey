module VisualizationPipeline
export save_report
function save_report(grid)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 16 Image Generation complete. Grid size: $(size(grid))")
    end
end
end
