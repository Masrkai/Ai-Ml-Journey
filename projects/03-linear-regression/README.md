# Project 03: Build your own Linear Regression from Scratch

## Overview
This project implements **Linear Regression from scratch** in pure Julia without relying on pre-built machine learning modeling libraries (such as GLM.jl or ScikitLearn). We implement both the **Closed-Form Ordinary Least Squares (OLS) solution** via Normal Equations ($\beta = (X^T X)^{-1} X^T y$) and the **Iterative Gradient Descent optimization algorithm** with configurable learning rates and convergence monitoring.

## Key Objectives
1. **From-Scratch Algorithm Implementation**: Build robust Julia structs and functions for fitting linear regression models using matrix operations (`LinearAlgebra.jl`).
2. **Optimization Comparison**: Compare closed-form OLS solutions against iterative Gradient Descent convergence paths.
3. **Evaluation Metrics**: Implement custom metric functions for Mean Squared Error (MSE), Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), and $R^2$ Score.
4. **Residual Analysis & Visualization**: Generate regression fit plots, gradient descent loss convergence curves, and residual distribution plots.

## How to Run

### Command Line Execution
Run the pipeline script from the repository root:
```bash
julia --project=projects/03-linear-regression projects/03-linear-regression/src/regression_pipeline.jl
```

### Running via Julia REPL
1. Enter the Julia REPL in the project directory:
   ```julia
   julia --project=projects/03-linear-regression
   ```
2. Run the pipeline:
   ```julia
   include("src/regression_pipeline.jl")
   ```

## Chronological Source Code Architecture
```text
src/
├── regression_pipeline.jl        # Master Pipeline Orchestrator Driver
├── model.jl                      # From-Scratch Linear Regression Module (OLS & GD)
└── pipeline/
    ├── 01_data.jl                # 1. Dataset Generation / Loading & Train-Test Split
    ├── 02_ols.jl                 # 2. Closed-Form OLS Fitting & Evaluation
    ├── 03_gradient_descent.jl    # 3. Iterative Gradient Descent Optimization
    └── 04_visualization.jl       # 4. Residual Analysis, Loss Curves & Reporting
```
