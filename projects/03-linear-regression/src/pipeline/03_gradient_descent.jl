# =====================================================================
# Stage 3: Iterative Gradient Descent Optimization
# =====================================================================

println("\n[3] Fitting via Iterative Gradient Descent...")

gd_model = LinearRegressionModel()
# Standardize features for stable GD convergence
X_mean = mean(X_train, dims=1)
X_std = std(X_train, dims=1)
X_train_scaled = (X_train .- X_mean) ./ X_std
X_test_scaled = (X_test .- X_mean) ./ X_std

loss_history = fit_gd!(gd_model, X_train_scaled, y_train, alpha=0.05, epochs=500)

println("Gradient Descent Fitted Successfully!")
println("  - Initial Loss: $(round(loss_history[1], digits=4))")
println("  - Final Loss (Epoch 500): $(round(loss_history[end], digits=4))")
println("  - Estimated Bias: $(round(gd_model.bias, digits=4))")
println("  - Estimated Weights: $(round.(gd_model.weights, digits=4))")

y_pred_gd = predict(gd_model, X_test_scaled)
gd_mse = mse(y_test, y_pred_gd)
gd_r2 = r2_score(y_test, y_pred_gd)

println("Gradient Descent Test Evaluation:")
println("  - MSE: $(round(gd_mse, digits=4))")
println("  - R² : $(round(gd_r2, digits=4))")

push!(summary_lines, "\n--- Gradient Descent Results ---")
push!(summary_lines, "Final GD Loss: $(loss_history[end]) | Test MSE: $gd_mse | R²: $gd_r2")
