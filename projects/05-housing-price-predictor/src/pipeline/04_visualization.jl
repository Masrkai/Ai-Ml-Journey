module VisualizationPipeline
using Plots
using Statistics

export generate_visualizations, save_report

function generate_visualizations(y_test, y_pred, w)
    println("Generating visualizations and reports...")
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)

    # 1. Regression fit / predicted vs actual
    p1 = scatter(y_test, y_pred, label="Predicted vs Actual", xlabel="Actual Price", ylabel="Predicted Price", title="Housing Price Predictor Fit")
    plot!(p1, [minimum(y_test), maximum(y_test)], [minimum(y_test), maximum(y_test)], label="Ideal", color=:red, linestyle=:dash)
    savefig(p1, joinpath(output_dir, "regression_fit.png"))

    # 2. Residuals plot
    residuals = y_test .- y_pred
    p2 = scatter(y_pred, residuals, label="Residuals", xlabel="Predicted Price", ylabel="Residuals", title="Residual Plot")
    hline!(p2, [0], color=:red, linestyle=:dash, label="Zero Line")
    savefig(p2, joinpath(output_dir, "residuals_plot.png"))
end

function save_report(rmse, mae, r2, w)
    output_dir = normpath(joinpath(@__DIR__, "../../output"))
    mkpath(output_dir)
    report_path = joinpath(output_dir, "summary_report.txt")
    open(report_path, "w") do io
        println(io, "==================================================")
        println(io, " Project 05: Housing Price Predictor Summary Report")
        println(io, "==================================================")
        println(io, "Model Weights: $w")
        println(io, "Test RMSE: $rmse")
        println(io, "Test MAE:  $mae")
        println(io, "Test R^2:  $r2")
        println(io, "==================================================")
    end
    println("Saved summary report to $report_path")
end

end
