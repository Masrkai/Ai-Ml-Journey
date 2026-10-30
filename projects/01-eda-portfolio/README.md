# Project 01: Exploratory Data Analysis (EDA) Portfolio

## Overview
This project implements a comprehensive Exploratory Data Analysis (EDA) pipeline in Julia. EDA is the critical first step in any data science workflow, enabling us to understand data distributions, uncover anomalies, detect missing values, and identify key relationships between features before model training.

## Dataset
We utilize the classic **Iris Dataset** (or other tabular datasets) stored in the repository-wide Single Source of Truth root `datasets/` folder (e.g., `datasets/iris.csv`) to demonstrate rigorous data inspection, summary statistics, grouping, aggregation, and visualization techniques using Julia's data ecosystem (`DataFrames.jl`, `CSV.jl`, `Plots.jl`).

## Key Objectives
1. **Data Loading & Inspection**: Load CSV data into a `DataFrame`, inspect schema, dimensions, and head/tail rows.
2. **Data Cleaning & Missing Value Analysis**: Identify missing values, handle imputations or filtering.
3. **Summary Statistics**: Compute mean, median, standard deviation, quartiles, and correlation matrices.
4. **Groupby & Aggregation**: Group data by categorical variables and compute aggregate statistics.
5. **Data Visualization**: Generate histograms, scatter plots, and box plots to visualize feature distributions and correlations.

## How to Run (Dataset-Agnostic Engine)

The EDA portfolio pipeline is fully dataset-agnostic and can be executed from the command line with custom tabular CSV datasets and optional target column supervision.

### Command Line Execution & Workflow Modes
Run the script from the repository root passing the dataset path (from the root `datasets/` SSOT folder), target column name, and workflow optimization mode as command-line arguments:

```bash
julia --project=projects/01-eda-portfolio projects/01-eda-portfolio/src/eda_portfolio.jl datasets/iris.csv species supervised
```

Or for unsupervised clustering / anomaly detection workflows:
```bash
julia --project=projects/01-eda-portfolio projects/01-eda-portfolio/src/eda_portfolio.jl datasets/iris.csv none unsupervised
```

#### Workflow Optimization Modes:
1. **Supervised Mode (`supervised`)**:
   - **Classification**: Computes class distribution balance ratios (Max/Min count) and flags significant class imbalances ($> 3.0$) to recommend SMOTE, class weighting, or stratified splitting.
   - **Regression**: Computes feature-to-target correlations and flags potential **Target Leakage** ($|r| > 0.95$).
2. **Unsupervised Mode (`unsupervised`)**:
   - **Hopkins Statistic**: Quantifies spatial clustering tendency (values $> 0.65$ confirm suitability for distance-based clustering like K-Means/Hierarchical clustering).
   - **Feature Redundancy Analysis**: Flags highly collinear feature pairs ($|r| > 0.85$) that could distort distance metrics or weight spatial centroids disproportionately.

*(All parameters—dataset path, target column, and workflow mode—must be explicitly provided when executing the pipeline).*

### Running via Julia REPL
1. Enter the Julia REPL in this project folder or activate the environment:
   ```julia
   julia --project=.
   ```
2. Instantiate dependencies:
   ```julia
   using Pkg
   Pkg.instantiate()
   ```
3. Run the EDA script:
   ```julia
   include("src/eda_portfolio.jl")
   ```

## Chronological Source Code Architecture

The source code in `src/` is modularized chronologically into sequential stages matching the data science exploratory analysis lifecycle:

```text
src/
├── eda_portfolio.jl              # Master Pipeline Orchestrator Driver
├── preprocessor.jl               # Reusable Preprocessing Module
└── pipeline/
    ├── 01_ingest.jl              # 1. Dataset Ingestion, CLI Arguments & Caching / Fallback
    ├── 02_audit.jl               # 2. Data Quality & Missingness Audit
    ├── 03_diagnostics.jl         # 3. Target Distribution & Shannon Entropy Diagnostics
    ├── 04_statistics.jl          # 4. Summary Statistics, Pearson Correlations & Workflow Modes
    ├── 05_inference.jl           # 5. Outliers (IQR & Mahalanobis), ANOVA & Non-Parametric Tests
    ├── 06_dimensionality.jl      # 6. PCA Dimensionality Reduction & Silhouette Scoring
    └── 07_visualization.jl       # 7. Visualization Generation & Summary Reporting
```

---

## Output Transcription & Interpretation Guide

When you execute `src/eda_portfolio.jl`, the pipeline generates console outputs, saved charts (`output/`), and a summary report (`output/summary_report.txt`). This section instructs how to transcribe these outputs and apply them to specific data science objectives.

### 1. How to Transcribe Analysis Outputs

- **Summary Statistics (`mean`, `median`, `std`)**:
  - *Transcription*: Compare `mean` and `median`. If `mean` significantly exceeds `median`, the feature is right-skewed. If `median` exceeds `mean`, it is left-skewed. Compare standard deviation (`std`) relative to the mean to gauge dispersion.
- **Correlation Matrix (`cor(x, y)`)**:
  - *Transcription*: Look for coefficients close to `+1.0` or `-1.0`. High correlation (> 0.8) between feature pairs indicates multicollinearity. Correlation with target/species indicates predictive power.
- **Outlier Detection (IQR Bounds)**:
  - *Transcription*: Review the number of values falling outside `[Q1 - 1.5*IQR, Q3 + 1.5*IQR]`. Document whether outliers are measurement errors or legitimate extreme values.
- **Visualizations & Summary Reports**:
  - *Transcription*: Inspect histograms for modality (unimodal vs multimodal), scatter plots for cluster separability across classes, correlation heatmaps for multicollinearity hotspots, and PCA scree plots for variance retention elbows.
- **Advanced Statistical Tests (Kruskal-Wallis, Levene, Silhouette)**:
  - *Transcription*: Compare Kruskal-Wallis H-statistic with ANOVA F-statistics to verify group separability without normality assumptions. Check Levene test scores for variance homogeneity across groups. Evaluate silhouette scores (> 0.4 indicates good cluster separation).

### 2. Examples of Using Outputs for Given Objectives

#### Objective A: Feature Selection for Classification Models
- **Insight from EDA**: The correlation matrix shows that `petal_length` and `petal_width` have a high positive correlation (`0.963`) with each other and strong separability across species groups.
- **Application**: In a predictive modeling phase (e.g., Project 02 or 04), you can select `petal_length` and `petal_width` as primary predictors, or apply dimensionality reduction (PCA) if multicollinearity impairs model stability.

#### Objective B: Handling Outliers Before Model Training
- **Insight from EDA**: The IQR outlier analysis identifies 4 potential outliers in `sepal_width`.
- **Application**: For sensitive models like Linear Regression or Neural Networks, either cap/winsorize these values or use robust models (e.g., Decision Trees / Gradient Boosting) that are insensitive to monotonic feature scaling and outliers.

#### Objective C: Data Normalization Strategy
- **Insight from EDA**: Summary statistics show features operating on different scales (e.g., `sepal_length` ranging from 4.3 to 7.9 vs `petal_width` from 0.1 to 2.5).
- **Application**: Feed these transcription findings into downstream preprocessing pipelines to apply Z-score standardization or Min-Max scaling before training distance-based algorithms (like KNN or SVM).
