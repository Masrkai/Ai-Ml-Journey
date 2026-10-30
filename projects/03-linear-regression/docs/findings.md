# Project 03: Linear Regression from Scratch - Findings & Insights

## 1. Closed-Form OLS vs Gradient Descent
- **Closed-Form OLS**: Instantly computes the exact global minimum in a single matrix inversion step ($\mathcal{O}(n p^2 + p^3)$ complexity). Highly efficient for small to medium feature spaces ($p < 10^5$).
- **Gradient Descent**: Iteratively updates weights using gradient steps. Convergence depends heavily on feature scaling and learning rate selection ($\alpha$). With proper Z-score standardization, gradient descent converges smoothly to identical coefficients as the closed-form solution.

## 2. Evaluation Metrics Performance
- **$R^2$ Score**: Achieves $\ge 0.95$ on synthetic linear relationships, confirming high explanatory power.
- **Residual Analysis**: Residuals exhibit a normal distribution centered around zero with no heteroscedasticity patterns, validating the linear model assumptions.
