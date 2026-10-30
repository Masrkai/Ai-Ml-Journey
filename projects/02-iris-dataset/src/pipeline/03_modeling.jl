# =====================================================================
# Stage 3: PCA Dimensionality Reduction & Baseline Classification
# =====================================================================

println("\n[3] Executing PCA Dimensionality Reduction & Classification Baseline...")

X = Matrix{Float64}(df[!, numeric_syms])
y = df[!, target_col]

# Z-score standardization
X_mean = mean(X, dims=1)
X_std = std(X, dims=1)
X_scaled = (X .- X_mean) ./ X_std

# PCA via SVD
C = cov(X_scaled)
F = eigen(C)
# Sort eigenvalues/eigenvectors descending
idx = sortperm(F.values, rev=true)
eigenvalues = F.values[idx]
eigenvectors = F.vectors[:, idx]

explained_variance_ratio = eigenvalues ./ sum(eigenvalues)
println("Explained Variance Ratio (PC1, PC2, PC3, PC4):")
display(round.(explained_variance_ratio, digits=4))
println()

# Project to 2D PC space
X_pca = X_scaled * eigenvectors[:, 1:2]

push!(summary_lines, "\n--- PCA Dimensionality Reduction ---")
push!(summary_lines, "Explained Variance Ratios: $(round.(explained_variance_ratio, digits=4))")

# Baseline Distance-Based (Nearest Neighbor) Classification evaluation with Leave-One-Out or Train-Test Split
Random.seed!(42)
n_samples = size(X, 1)
shuffled_indices = randperm(n_samples)
train_size = Int(round(0.8 * n_samples))
train_idx = shuffled_indices[1:train_size]
test_idx = shuffled_indices[train_size+1:end]

X_train, y_train = X_scaled[train_idx, :], y[train_idx]
X_test, y_test = X_scaled[test_idx, :], y[test_idx]

# Simple 1-NN Classifier using Euclidean Distance
correct_predictions = 0
for i in 1:length(test_idx)
    test_sample = X_test[i, :]
    distances = [norm(test_sample - X_train[j, :]) for j in 1:size(X_train, 1)]
    nearest_j = argmin(distances)
    predicted_label = y_train[nearest_j]
    if predicted_label == y_test[i]
        global correct_predictions += 1
    end
end

accuracy = correct_predictions / length(test_idx)
println("\nBaseline 1-NN Classifier Test Accuracy: $(round(accuracy * 100, digits=2))% ($(correct_predictions)/$(length(test_idx)) correct)")
push!(summary_lines, "\n--- Baseline 1-NN Classifier ---")
push!(summary_lines, "Test Accuracy: $(round(accuracy * 100, digits=2))%")
