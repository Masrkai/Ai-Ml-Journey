# =====================================================================
# Stage 2: Closed-Form OLS Fitting & Evaluation
# =====================================================================

println("\n[2] Fitting Closed-Form Ordinary Least Squares (OLS)...")

ols_model = LinearRegressionModel()
fit_ols!(ols_model, X_train, y_train)

println("OLS Fitted Successfully!")
println("  - Estimated Bias (Intercept): $(round(ols_model.bias, digits=4))")
println("  - Estimated Weights: $(round.(ols_model.weights, digits=4))")

y_pred_ols = predict(ols_model, X_test)
ols_mse = mse(y_test, y_pred_ols)
ols_rmse = rmse(y_test, y_pred_ols)
ols_mae = mae(y_test, y_pred_ols)
ols_r2 = r2_score(y_test, y_pred_ols)

println("OLS Test Evaluation:")
println("  - MSE : $(round(ols_mse, digits=4))")
println("  - RMSE: $(round(ols_rmse, digits=4))")
println("  - MAE : $(round(ols_mae, digits=4))")
println("  - R²  : $(round(ols_r2, digits=4))")

push!(summary_lines, "\n--- Closed-Form OLS Results ---")
push!(summary_lines, "Bias: $(ols_model.bias) | Weights: $(ols_model.weights)")
push!(summary_lines, "Test MSE: $ols_mse | RMSE: $ols_rmse | MAE: $ols_mae | R²: $ols_r2")
