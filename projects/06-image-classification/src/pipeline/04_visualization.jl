module VisualizationPipeline
using Plots
using Statistics

export generate_visualizations, save_report

function generate_visualizations(y_test, y_pred)
    println("Generating classification visualizations...")
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)

    # Confusion matrix or prediction comparison bar chart
    classes = unique(vcat(y_test, y_pred))
    cm = zeros(Int, length(classes), length(classes))
    for (t, p) in zip(y_test, y_pred)
        cm[t, p] += 1
    end

    p = heatmap(cm, title="Confusion Matrix", xlabel="Predicted Class", ylabel="Actual Class", yflip=true)
    savefig(p, joinpath(output_dir, "confusion_matrix.png"))
end

function save_report(acc)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    report_path = joinpath(output_dir, "summary_report.txt")
    open(report_path, "w") do io
        println(io, "==================================================")
        println(io, " Project 06: Image Classification Summary Report")
        println(io, "==================================================")
        println(io, "Test Accuracy: $(round(acc * 100, digits=2))%")
        println(io, "==================================================")
    end
    println("Saved summary report to $report_path")
end

end
