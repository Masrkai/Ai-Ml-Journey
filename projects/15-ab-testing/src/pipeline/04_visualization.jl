module VisualizationPipeline
export save_report
function save_report(p_c, p_t, z)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    open(joinpath(output_dir, "summary_report.txt"), "w") do io
        println(io, "Project 15 A/B Test Report: Control: $p_c, Treatment: $p_t, Z-Stat: $z")
    end
end
end
