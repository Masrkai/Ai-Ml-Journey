# =====================================================================
# Stage 6: Exploratory Dimensionality Reduction (PCA & Silhouette Scoring)
# =====================================================================

println("\n[11] Exploratory Dimensionality Reduction (PCA via SVD):")
push!(summary_lines, "\n[Principal Component Analysis (PCA)]")

std_devs = std(num_matrix, dims=1)
std_devs[std_devs .== 0] .= 1.0
scaled_num_matrix = (num_matrix .- mu_vec) ./ std_devs
F_pca = svd(scaled_num_matrix)
eigenvalues = (F_pca.S .^ 2) ./ (size(num_matrix, 1) - 1)
explained_var_ratio = eigenvalues ./ sum(eigenvalues)
cum_var = cumsum(explained_var_ratio)

for (idx, ev) in enumerate(explained_var_ratio)
    pca_str = " - Principal Component PC$(idx): Explained Variance = $(round(ev * 100, digits=2))% (Cumulative: $(round(cum_var[idx] * 100, digits=2))%)"
    println(pca_str)
    push!(summary_lines, pca_str)
end

if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
    clean_df = dropmissing(df, [target_col; Symbol.(numeric_col_names)])
    target_vals_clean = clean_df[!, target_col]
    if size(F_pca.V, 2) >= 2
        pc_coords = scaled_num_matrix * F_pca.V[:, 1:2]
        function compute_silhouette_score(coords, labels)
            unique_lbls = unique(labels)
            n_samples = size(coords, 1)
            scores = zeros(n_samples)
            for i in 1:n_samples
                lbl_i = labels[i]
                same_idx = findall(==(lbl_i), labels)
                same_idx = filter(!=(i), same_idx)
                a_i = isempty(same_idx) ? 0.0 : mean(norm(coords[i, :] - coords[j, :]) for j in same_idx)
                b_i = Inf
                for other_lbl in unique_lbls
                    other_lbl == lbl_i && continue
                    other_idx = findall(==(other_lbl), labels)
                    if isempty(other_idx) continue end
                    dist_other = mean(norm(coords[i, :] - coords[j, :]) for j in other_idx)
                    b_i = min(b_i, dist_other)
                end
                scores[i] = (b_i - a_i) / max(a_i, b_i)
            end
            return mean(scores)
        end
        sil_score = compute_silhouette_score(pc_coords, target_vals_clean)
        sil_str = " - Mean Silhouette Separation Score in PC1-PC2 space: $(round(sil_score, digits=3))"
        println(sil_str)
        push!(summary_lines, sil_str)
    end
end
