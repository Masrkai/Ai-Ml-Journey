# =====================================================================
# Stage 7: Data Visualization Generation & Summary Reporting
# =====================================================================

println("\n[13] Generating Comprehensive EDA Visualizations...")
mkpath("output")

p1 = histogram(num_matrix[:, 1], label=numeric_col_names[1], xlabel="$(numeric_col_names[1])", ylabel="Frequency", title="$(numeric_col_names[1]) Distribution", color=:dodgerblue)
savefig(p1, "output/sepal_length_hist.png")

if length(numeric_col_names) >= 2
    c_x, c_y = numeric_col_names[1], numeric_col_names[2]
    if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
        p2 = scatter(clean_df[!, Symbol(c_x)], clean_df[!, Symbol(c_y)], group=clean_df[!, target_col], xlabel="$(c_x)", ylabel="$(c_y)", title="$(c_y) vs $(c_x) by Target")
    else
        p2 = scatter(df[!, Symbol(c_x)], df[!, Symbol(c_y)], xlabel="$(c_x)", ylabel="$(c_y)", title="$(c_y) vs $(c_x)")
    end
    savefig(p2, "output/petal_scatter.png")
end

if length(numeric_col_names) >= 3
    c_x, c_y = numeric_col_names[2], numeric_col_names[3]
    if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
        p3 = scatter(clean_df[!, Symbol(c_x)], clean_df[!, Symbol(c_y)], group=clean_df[!, target_col], xlabel="$(c_x)", ylabel="$(c_y)", title="$(c_y) vs $(c_x) by Target")
    else
        p3 = scatter(df[!, Symbol(c_x)], df[!, Symbol(c_y)], xlabel="$(c_x)", ylabel="$(c_y)", title="$(c_y) vs $(c_x)")
    end
    savefig(p3, "output/sepal_width_scatter.png")
end

p_heatmap = heatmap(numeric_col_names, numeric_col_names, corr_matrix, title="Pearson Correlation Heatmap", c=:thermal, aspect_ratio=:equal)
savefig(p_heatmap, "output/correlation_heatmap.png")

p_scree = bar(1:length(explained_var_ratio), explained_var_ratio .* 100, label="Individual (%)", xlabel="Principal Component", ylabel="Explained Variance (%)", title="PCA Scree Plot", color=:teal)
plot!(p_scree, 1:length(cum_var), cum_var .* 100, label="Cumulative (%)", marker=:circle, color=:orange, lw=2)
savefig(p_scree, "output/pca_scree_plot.png")

if size(F_pca.V, 2) >= 2
    pc_coords = scaled_num_matrix * F_pca.V[:, 1:2]
    if !isnothing(target_col) && !(eltype(clean_df[!, target_col]) <: Number)
        p_biplot = scatter(pc_coords[:, 1], pc_coords[:, 2], group=clean_df[!, target_col], xlabel="PC1 ($(round(explained_var_ratio[1]*100, digits=1))%)", ylabel="PC2 ($(round(explained_var_ratio[2]*100, digits=1))%)", title="PCA Biplot (PC1 vs PC2)")
    else
        p_biplot = scatter(pc_coords[:, 1], pc_coords[:, 2], xlabel="PC1 ($(round(explained_var_ratio[1]*100, digits=1))%)", ylabel="PC2 ($(round(explained_var_ratio[2]*100, digits=1))%)", title="PCA Biplot (PC1 vs PC2)")
    end
    savefig(p_biplot, "output/pca_biplot.png")
end

write("output/summary_report.txt", join(summary_lines, "\n"))
println("Summary report written to 'output/summary_report.txt'")
println("All diagnostic plots saved successfully in 'output/' directory!")
