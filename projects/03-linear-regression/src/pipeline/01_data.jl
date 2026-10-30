# =====================================================================
# Stage 1: Dataset Generation & Train-Test Splitting
# =====================================================================

using Random
using DataFrames

println("\n[1] Generating / Loading Regression Dataset...")

Random.seed!(42)
n_samples = 200
n_features = 3

# Generate synthetic multi-feature linear dataset with Gaussian noise
X_raw = randn(n_samples, n_features)
true_weights = [3.5, -2.0, 1.8]
true_bias = 5.0
noise = 0.5 * randn(n_samples)

y = X_raw * true_weights .+ true_bias .+ noise

# Train-test split (80% train, 20% test)
shuffled_indices = randperm(n_samples)
train_size = Int(round(0.8 * n_samples))
train_idx = shuffled_indices[1:train_size]
test_idx = shuffled_indices[train_size+1:end]

X_train = X_raw[train_idx, :]
y_train = y[train_idx]
X_test = X_raw[test_idx, :]
y_test = y[test_idx]

println("Dataset generated successfully!")
println("  - Training samples: $(length(train_idx))")
println("  - Testing samples: $(length(test_idx))")
println("  - Features: $n_features")

summary_lines = String[]
push!(summary_lines, "Project 03: Linear Regression Pipeline Summary Report")
push!(summary_lines, "=====================================================")
push!(summary_lines, "Total Samples: $n_samples")
push!(summary_lines, "Features: $n_features")
push!(summary_lines, "Train/Test Split: $(length(train_idx)) / $(length(test_idx))")
