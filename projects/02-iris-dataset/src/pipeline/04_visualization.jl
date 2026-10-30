# =====================================================================
# Stage 4: Visualization Generation & Summary Reporting
# =====================================================================

println("\n[4] Generating Visualizations & Summary Report...")

output_dir = joinpath(dirname(dirname(@__DIR__)), "output")
mkpath(output_dir)

# Set non-interactive backend for plots if needed
gr(fmt=:png, size=(800, 600))

# 1. Petal scatter plot colored by species
plt1 = scatter(df.petal_length, df.petal_width, group=df[!, target_col],
    xlabel="Petal Length (cm)", ylabel="Petal Width (cm)",
    title="Iris Dataset: Petal Length vs Width by Species",
    markerstrokewidth=0, alpha=0.8)
savefig(plt1, joinpath(output_dir, "petal_scatter.png"))

# 2. PCA scatter plot
plt2 = scatter(X_pca[:, 1], X_pca[:, 2], group=y,
    xlabel="Principal Component 1", ylabel="Principal Component 2",
    title="Iris Dataset: PCA 2D Projection",
    markerstrokewidth=0, alpha=0.8)
savefig(plt2, joinpath(output_dir, "pca_scatter.png"))

# 3. Sepal distribution histogram
plt3 = histogram(df.sepal_length, bins=15, label="Sepal Length",
    xlabel="Value (cm)", ylabel="Frequency",
    title="Iris Dataset: Sepal Length Distribution", alpha=0.7)
savefig(plt3, joinpath(output_dir, "sepal_length_hist.png"))

println("Visualizations saved successfully to $output_dir/")

# Write summary report
report_path = joinpath(output_dir, "summary_report.txt")
open(report_path, "w") do io
    for line in summary_lines
        println(io, line)
    end
end
println("Summary report written to $report_path")
