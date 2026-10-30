# =====================================================================
# Stage 4: Visualizations & Summary Reporting
# =====================================================================

println("\n[4] Generating Visualizations & Summary Report...")

output_dir = joinpath(dirname(dirname(@__DIR__)), "output")
mkpath(output_dir)

gr(fmt=:png, size=(800, 600))

# 1. Actual vs Predicted Scatter Plot (OLS)
plt1 = scatter(y_test, y_pred_ols, label="Predictions",
    xlabel="Actual Values (y_test)", ylabel="Predicted Values (y_pred)",
    title="Linear Regression: Actual vs Predicted (OLS)")
plot!(plt1, [minimum(y_test), maximum(y_test)], [minimum(y_test), maximum(y_test)],
    label="Ideal Fit", linestyle=:dash, color=:red)
savefig(plt1, joinpath(output_dir, "regression_fit.png"))

# 2. Gradient Descent Loss Curve
plt2 = plot(1:length(loss_history), loss_history, label="MSE Loss",
    xlabel="Epoch", ylabel="Cost / Loss",
    title="Gradient Descent Loss Convergence Curve", color=:blue)
savefig(plt2, joinpath(output_dir, "loss_curve.png"))

# 3. Residual Distribution Plot
residuals = y_test .- y_pred_ols
plt3 = histogram(residuals, bins=15, label="Residuals",
    xlabel="Residual Value", ylabel="Frequency",
    title="OLS Residuals Distribution", alpha=0.7)
savefig(plt3, joinpath(output_dir, "residuals_plot.png"))

println("Visualizations saved successfully to $output_dir/")

report_path = joinpath(output_dir, "summary_report.txt")
open(report_path, "w") do io
    for line in summary_lines
        println(io, line)
    end
end
println("Summary report written to $report_path")
