# =====================================================================
# Stage 3: Baseline Classification & Evaluation
# =====================================================================

println("\n[3] Training Baseline Classification Model...")

using Random
using LinearAlgebra

Random.seed!(42)
feature_cols = [:Pclass, :Age, :SibSp, :Parch, :Fare, :FamilySize, :IsFemale]
X = Matrix{Float64}(df_clean[!, feature_cols])
y = Int.(df_clean.Survived)

# Standardize features
X_mean = mean(X, dims=1)
X_std = std(X, dims=1)
X_scaled = (X .- X_mean) ./ X_std

# Train-test split (80% train, 20% test)
n = size(X, 1)
perm = randperm(n)
train_size = Int(round(0.8 * n))
train_idx = perm[1:train_size]
test_idx = perm[train_size+1:end]

X_train, y_train = X_scaled[train_idx, :], y[train_idx]
X_test, y_test = X_scaled[test_idx, :], y[test_idx]

# k-NN Classifier (k=5) using Euclidean Distance
k = 5
correct = 0
y_pred = Int[]

for i in 1:length(test_idx)
    dists = [norm(X_test[i, :] - X_train[j, :]) for j in 1:size(X_train, 1)]
    nearest_indices = sortperm(dists)[1:k]
    # Majority vote
    votes = y_train[nearest_indices]
    pred = sum(votes) >= (k / 2.0) ? 1 : 0
    push!(y_pred, pred)
    if pred == y_test[i]
        global correct += 1
    end
end

accuracy = correct / length(test_idx)

# Confusion Matrix metrics
true_positives = sum((y_test .== 1) .& (y_pred .== 1))
false_positives = sum((y_test .== 0) .& (y_pred .== 1))
false_negatives = sum((y_test .== 1) .& (y_pred .== 0))
true_negatives = sum((y_test .== 0) .& (y_pred .== 0))

precision = true_positives / max(1, (true_positives + false_positives))
recall = true_positives / max(1, (true_positives + false_negatives))
f1 = 2 * (precision * recall) / max(1e-12, (precision + recall))

println("Classification Test Evaluation (k-NN, k=$k):")
println("  - Accuracy : $(round(accuracy * 100, digits=2))%")
println("  - Precision: $(round(precision * 100, digits=2))%")
println("  - Recall   : $(round(recall * 100, digits=2))%")
println("  - F1-Score : $(round(f1 * 100, digits=2))%")

push!(summary_lines, "\n--- Classification Model Results (k-NN) ---")
push!(summary_lines, "Accuracy: $(round(accuracy * 100, digits=2))% | Precision: $(round(precision * 100, digits=2))% | Recall: $(round(recall * 100, digits=2))% | F1: $(round(f1 * 100, digits=2))%")
